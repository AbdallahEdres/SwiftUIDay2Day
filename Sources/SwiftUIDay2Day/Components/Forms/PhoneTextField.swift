//
//  PhoneTextField.swift
//  SwiftUIDay2Day
//
//  Created by Abdallah Edres on 09/09/2025.
//

import SwiftUI

public struct CountryEntity: SelectableItem {
    public var id: Int? { self._id }
    public var title: String { "\(callingCode ?? "") \(name ?? "")" }
    public var isSelected: Bool = false
    public var image: String? { flag }
    
    private let _id: Int?
    public let name: String?
    public let callingCode: String?
    public let flag: String?
    
    public init(
        id: Int? = nil,
        name: String? = nil,
        callingCode: String? = nil,
        flag: String? = nil
    ) {
        self._id = id
        self.name = name
        self.callingCode = callingCode
        self.flag = flag
    }
    
    public static func == (lhs: CountryEntity, rhs: CountryEntity) -> Bool {
        lhs.id == rhs.id
    }
}

public struct PhoneTextField: View {
    
    @Binding private var items: [CountryEntity]
    @Binding private var phone: String?
    @Binding private var countryCode: String?
    @Binding private var errorMessage: String?
    @FocusState private var isFocused: Bool
    @State private var showPicker: Bool = false
    @State private var selectedCountry: CountryEntity?
    
    private let label: String
    private let placeHolder: String
    private let isRequired: Bool
    private let image: Image?
    
    public init(
        items: Binding<[CountryEntity]>,
        phone: Binding<String?>,
        countryCode: Binding<String?>,
        errorMessage: Binding<String?> = .constant(nil),
        label: String = "Phone Number",
        placeHolder: String = "Enter your phone number",
        isRequired: Bool = true,
        image: Image? = Image(systemName: "phone")
    ) {
        self._items = items
        self._phone = phone
        self._countryCode = countryCode
        self._errorMessage = errorMessage
        self.label = label
        self.placeHolder = placeHolder
        self.isRequired = isRequired
        self.image = image
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            labelView
            textField
            if let errorMessage, !errorMessage.isEmpty {
                errorView
            }
        }
        .onChange(of: selectedCountry) { newValue in
            countryCode = newValue?.callingCode
        }
        .onChange(of: items) { _ in
            selectDefaultCountry()
        }
    }
    
    private var labelView: some View {
        HStack(spacing: 4) {
            Text(label)
                .appText(.bodyRegular)
            
            if !isRequired {
                Text("(Optional)")
                    .appText(.caption, color: .gray)
            }
        }
    }
    
    private var textField: some View {
        HStack(alignment: .center) {
            countyCodeView
            
            TextField(placeHolder, text: $phone.unwrapped(default: ""))
                .appText(.bodyRegular)
                .focused($isFocused)
                .keyboardType(.phonePad)
            
            image?
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(phone.isNilOrEmpty ? .gray : .blue)
                .frame(maxWidth: 20)
        }
        .environment(\.layoutDirection, .leftToRight)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
        .frame(height: 48)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    (isFocused || phone?.isEmpty == false) ? .blue : .clear,
                    lineWidth: 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
    
    private var countyCodeView: some View {
        VStack(alignment: .center) {
            Spacer()
            HStack(alignment: .center, spacing: 4) {
                Text(selectedCountry?.flag ?? "🇺🇸")
                    .frame(width: 30)
                Text(countryCode ?? "+1")
                    .appText(.bodyRegular)
            }
            Spacer()
        }
        .environment(\.layoutDirection, .leftToRight)
        .onTapGesture {
            showPicker = true
        }
        .sheet(isPresented: $showPicker) {
            SheetContainer {
                SingleSelectableView(items: $items, selectedItem: $selectedCountry)
            }
        }
    }
    
    private var errorView: some View {
        Text(errorMessage ?? "")
            .appText(.bodyRegular, color: .red)
    }
    
    private func selectDefaultCountry() {
        if !items.isEmpty, selectedCountry == nil {
            selectedCountry = items.first
        }
    }
}

struct PhoneTextField_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var countries: [CountryEntity] = [
            CountryEntity(id: 1, name: "United States", callingCode: "+1", flag: "🇺🇸"),
            CountryEntity(id: 2, name: "Egypt", callingCode: "+20", flag: "🇪🇬"),
            CountryEntity(id: 3, name: "Germany", callingCode: "+49", flag: "🇩🇪")
        ]
        @State private var phone: String? = ""
        @State private var countryCode: String? = "+1"
        @State private var errorMessage: String? = nil
        
        var body: some View {
            VStack(spacing: 20) {
                PhoneTextField(
                    items: $countries,
                    phone: $phone,
                    countryCode: $countryCode,
                    errorMessage: $errorMessage,
                    label: "Phone Number",
                    placeHolder: "Enter your phone number"
                )
                
                Button("Simulate Error") {
                    errorMessage = "Invalid phone number"
                }
                
                Text("Current phone: \(phone ?? "")")
                Text("Selected country code: \(countryCode ?? "")")
            }
            .padding()
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
    }
}
