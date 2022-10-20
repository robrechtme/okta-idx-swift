//
// Copyright (c) 2022-Present, Okta, Inc. and/or its affiliates. All rights reserved.
// The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
//
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and limitations under the License.
//

import SwiftUI
import NativeAuthentication

extension StringInputField.ContentType {
    var type: UITextContentType? {
        switch self {
        case .name:
            return .name
        case .firstName:
            return .givenName
        case .middleName:
            return .middleName
        case .lastName:
            return .familyName
        case .telephoneNumber:
            return .telephoneNumber
        case .emailAddress:
            return .emailAddress
        case .username:
            return .username
        case .password:
            return .password
        case .newPassword:
            return .newPassword
        case .oneTimeCode:
            return .oneTimeCode
        case .generic:
            return nil
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension StringInputField: ComponentView {
    func body(in form: SignInForm, section: SignInSection) -> AnyView {
        let keyboardType: UIKeyboardType
        let capitalization: Compatibility.TextInputAutocapitalizationMode?
        let autocorrectionDisabled: Bool
        
        switch inputStyle {
        case .email:
            keyboardType = .emailAddress
            capitalization = .never
            autocorrectionDisabled = true
        case .password:
            keyboardType = .default
            capitalization = .never
            autocorrectionDisabled = true
        case .generic:
            keyboardType = .default
            capitalization = nil
            autocorrectionDisabled = false
        case .name:
            keyboardType = .asciiCapable
            capitalization = .words
            autocorrectionDisabled = false
        }
        
        let result: any View
        result = VStack(spacing: 12.0) {
            HStack {
                if isSecure && id.hasSuffix("passcode") {
                    Image(systemName: "lock")
                } else if id.hasSuffix("identifier") {
                    Image(systemName: "at")
                }
                
                if isSecure {
                    SecureField(label, text: $value.value) {
                        section.action?(self)
                    }
                    .keyboardType(keyboardType)
                    .textContentType(contentType.type)
                    .autocorrectionDisabled(autocorrectionDisabled)
                    .compatibility.textInputAutocapitalization(capitalization)

                    if section.type == .body,
                       let recoverAction = section.components.first(type: RecoverAction.self)
                    {
                        recoverAction.body(in: form, section: section)
                    }
                } else {
                    TextField(label, text: $value.value) {
                        section.action?(self)
                    }
                    .keyboardType(keyboardType)
                    .textContentType(contentType.type)
                    .autocorrectionDisabled(autocorrectionDisabled)
                    .compatibility.textInputAutocapitalization(capitalization)
                }
            }
            Divider()
        }

        return AnyView(result)
    }
}
