# Sign with Apple demo

## 1.用户点击了苹果登录，拉起登录

```swift
@available(iOS 13.0, *)
    @IBAction func signInWithApple(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
```

## 2.在delegate方法中处理登录结果的回调

```swift
@available(iOS 13.0, *)
extension LoginController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    /// - Tag: did_complete_authorization
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                // Create an account in your system.
                let user = appleIDCredential.user
                var params: [String : Any] = [
                    "openid": user,
                    "cid": userManager.getuiCID,
                    "smid": deviceUuid,
                    "type": 2]
                if let fullName = appleIDCredential.fullName {
                    params["nickname"] = fullName
                }
                
                print("apple login params: \(params)")
                self.thirdLogin(type: .apple, params)
                
            case _ as ASPasswordCredential:
                // Sign in using an existing iCloud Keychain credential.
                /*
                 let username = passwordCredential.user
                 let password = passwordCredential.password
                 */
                break
            default:
                break
        }
    }
}

```

