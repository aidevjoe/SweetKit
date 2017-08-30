import Foundation
import LocalAuthentication

// MARK: - SKTouchID struct

/// This struct adds some useful functions to use TouchID.
public struct SKTouchID {
    // MARK: - Variables
    
    /// Touch result enum:
    ///
    /// - success:              Success.
    /// - error:                Error.
    /// - authenticationFailed: Authentication Failed.
    /// - userCancel:           User Cancel.
    /// - userFallback:         User Fallback.
    /// - systemCancel:         System Cancel.
    /// - passcodeNotSet:       Passcode Not Set.
    /// - notAvailable:         Touch IDNot Available.
    /// - notEnrolled:          Touch ID Not Enrolled.
    /// - lockout:              Touch ID Lockout.
    /// - appCancel:            App Cancel.
    /// - invalidContext:       Invalid Context.
    public enum TouchIDResult: Int {
        case success
        case authenticationFailed
        case userCancel
        case userFallback
        case systemCancel
        case passcodeNotSet
        case notAvailable
        case notEnrolled
        case lockout
        case appCancel
        case invalidContext
        case error
    }
    
    // MARK: - Functions
    
    /// Shows the TouchID authentication.
    ///
    /// - Parameters:
    ///   - reason:        Text to show in the alert.
    ///   - fallbackTitle: Default title "Enter Password" is used when this property is left nil. If set to empty string, the button will be hidden.
    ///   - completion:     Completion handler.
    ///   - result:         Returns the TouchID result, from the TouchIDResult enum.
    public static func showTouchID(reason: String, fallbackTitle: String? = nil, completion: @escaping (_ result: TouchIDResult) -> Void) {
        let context: LAContext = LAContext()
        
        context.localizedFallbackTitle = fallbackTitle
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success: Bool, error: Error?) -> Void in
                if success {
                    completion(.success)
                } else {
                    if #available(iOS 9.0, *) {
                        switch error! {
                        case LAError.authenticationFailed:
                            completion(.authenticationFailed)
                        case LAError.userCancel:
                            completion(.userCancel)
                        case LAError.userFallback:
                            completion(.userFallback)
                        case LAError.systemCancel:
                            completion(.systemCancel)
                        case LAError.touchIDLockout:
                            completion(.lockout)
                        case LAError.appCancel:
                            completion(.appCancel)
                        case LAError.invalidContext:
                            completion(.invalidContext)
                        default:
                            completion(.error)
                        }
                    } else {
                        switch error! {
                        case LAError.authenticationFailed:
                            completion(.authenticationFailed)
                        case LAError.userCancel:
                            completion(.userCancel)
                        case LAError.userFallback:
                            completion(.userFallback)
                        case LAError.systemCancel:
                            completion(.systemCancel)
                        default:
                            completion(.error)
                        }
                    }
                }
            })
        } else {
            if #available(iOS 9.0, *) {
                switch error! {
                case LAError.passcodeNotSet:
                    completion(.passcodeNotSet)
                case LAError.touchIDNotAvailable:
                    completion(.notAvailable)
                case LAError.touchIDNotEnrolled:
                    completion(.notEnrolled)
                case LAError.touchIDLockout:
                    completion(.lockout)
                case LAError.appCancel:
                    completion(.appCancel)
                case LAError.invalidContext:
                    completion(.invalidContext)
                default:
                    completion(.error)
                }
            } else {
                switch error! {
                case LAError.passcodeNotSet:
                    completion(.passcodeNotSet)
                case LAError.touchIDNotAvailable:
                    completion(.notAvailable)
                case LAError.touchIDNotEnrolled:
                    completion(.notEnrolled)
                default:
                    completion(.error)
                }
            }
        }
    }
}
