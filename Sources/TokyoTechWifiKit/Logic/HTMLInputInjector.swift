import Foundation

enum HTMLInputInjector {
    static func inject(_ inputs: [HTMLInput], username: String, password: String) throws -> [HTMLInput] {
        guard
            let firstTextInput = inputs.first(where: { $0.type == .text }),
            let firstPasswordInput = inputs.first(where: { $0.type == .password })
        else {
            throw TokyoTechWifiError.injectUsernameOrPasswordFailed
        }

        return inputs.map {
            if $0 == firstTextInput {
                var newInput = $0
                newInput.value = username
                return newInput
            }
            if $0 == firstPasswordInput {
                var newInput = $0
                newInput.value = password
                return newInput
            }
            return $0
        }
    }
}
