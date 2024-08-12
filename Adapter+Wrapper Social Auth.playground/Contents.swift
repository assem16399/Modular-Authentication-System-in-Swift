import Foundation

struct GoogleUser {
    let firstName: String
    let lastName: String
    let email: String
}

struct FacebookUser {
    let firstName: String
    let lastName: String
    let email: String
}

struct User {
    let fullName: String
    let email: String
}

protocol GoogleAuthWrapperProtocol{
    func loginWithGoogle() -> GoogleUser
}


protocol FacebookAuthWrapperProtocol{
    func loginWithFacebook() -> FacebookUser
}

protocol FacebookAuthAdapterProtocol{
    func loginWithFacebook() -> User
}

protocol GoogleAuthAdapterProtocol{
    func loginWithGoogle() -> User
}


struct GoogleAuthAdapter: GoogleAuthAdapterProtocol  {
    private let googleAuthWrapper: GoogleAuthWrapperProtocol
    
    init(googleAuthWrapper: GoogleAuthWrapperProtocol) {
        self.googleAuthWrapper = googleAuthWrapper
    }
    
    func loginWithGoogle() -> User {
        let googleUser = googleAuthWrapper.loginWithGoogle()
        return User(fullName: "\(googleUser.firstName) \(googleUser.lastName)", email: googleUser.email)
    }
}

struct FacebookAuthAdapter: FacebookAuthAdapterProtocol  {
    private let facebookAuthWrapper: FacebookAuthWrapperProtocol
    
    init(facebookAuthWrapper: FacebookAuthWrapperProtocol) {
        self.facebookAuthWrapper = facebookAuthWrapper
    }
    
    func loginWithFacebook() -> User {
        let facebookUser = facebookAuthWrapper.loginWithFacebook()
        return User(fullName: "\(facebookUser.firstName) \(facebookUser.lastName)", email: facebookUser.email)
    }
}


protocol AuthRepoProtocol{
    func auth(user: User)
}


protocol AuthInteractorProtocol {
    func googleAuth()
    func facebookAuth()
    func auth(user: User)
}

struct AuthInteractor: AuthInteractorProtocol {
    
    private let facebookAuthAdapter: FacebookAuthAdapterProtocol
    private let googleAuthAdapter: GoogleAuthAdapterProtocol
    private let authRepo: AuthRepoProtocol
    
    init(facebookAuthAdapter: FacebookAuthAdapterProtocol, googleAuthAdapter: GoogleAuthAdapterProtocol, authRepo: AuthRepoProtocol) {
        self.facebookAuthAdapter = facebookAuthAdapter
        self.googleAuthAdapter = googleAuthAdapter
        self.authRepo = authRepo
    }
    
    func googleAuth() {
        let user = googleAuthAdapter.loginWithGoogle()
        auth(user: user)
    }
    
    func facebookAuth() {
        let user = facebookAuthAdapter.loginWithFacebook()
        auth(user: user)
    }
    
    func auth(user: User) {
        authRepo.auth(user: user)
    }
    
}


// MARK: - Testing

class MockGoogleAuthWrapper: GoogleAuthWrapperProtocol {
    func loginWithGoogle() -> GoogleUser {
        return GoogleUser(firstName: "Google", lastName: "User", email: "test.user@example.com")
    }
}

class MockFacebookAuthWrapper: FacebookAuthWrapperProtocol {
    func loginWithFacebook() -> FacebookUser {
        return FacebookUser(firstName: "Facebook", lastName: "User", email: "test.user@example.com")
    }
}

class MockAuthRepo: AuthRepoProtocol {
    func auth(user: User) {
        // Mock authentication logic
        print("User \(user.fullName) authenticated with email \(user.email)")
    }
}

// Usage
let mockGoogleAuthWrapper = MockGoogleAuthWrapper()
let mockFacebookAuthWrapper = MockFacebookAuthWrapper()
let mockAuthRepo = MockAuthRepo()

let googleAuthAdapter = GoogleAuthAdapter(googleAuthWrapper: mockGoogleAuthWrapper)
let facebookAuthAdapter = FacebookAuthAdapter(facebookAuthWrapper: mockFacebookAuthWrapper)
let authInteractor = AuthInteractor(facebookAuthAdapter: facebookAuthAdapter, googleAuthAdapter: googleAuthAdapter, authRepo: mockAuthRepo)

authInteractor.googleAuth()
//authInteractor.facebookAuth()
