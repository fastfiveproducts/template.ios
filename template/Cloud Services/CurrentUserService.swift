//
//  CurrentUserService.swift
//
//  Template by Pete Maiser, July 2024 through May 2025
//      made availble here:
//      https://github.com/fastfiveproducts/template.ios
//      per terms of the MIT License
//
//  This particular implementation is for:
//      APP_NAME
//      DATE
//      YOUR_NAME
//


import Foundation
import Combine
import FirebaseAuth

@MainActor
class CurrentUserService: ObservableObject {
    
    static let shared = CurrentUserService()     // this store passed to view models as singleton
    
    // ***** Status and Modes *****
    @Published var isSignedIn = false
    @Published var isCreatingUser = false
    @Published var isWaitingOnEmailVerification = false
    @Published var isSigningIn = false
    @Published var isCreatingUserProfile = false
    
    // ***** User and User Messages *****
    @Published var user: User = User.blankUser
    @Published var messagesToUser: Loadable<[PrivateMessage]> = .empty
    @Published var messagesFromUser: Loadable<[PrivateMessage]> = .empty
    var userKey: UserKey { UserKey(uid: user.profile.uid, displayName: user.profile.displayName) }
    
    // ***** Cloud Data *****
    private let messageService: MessageService = MessageService()
    
    // ***** Cloud Auth *****
    @Published var authError: Error?
    private let auth = Auth.auth()
    private var userAuth = UserAuth.blankUser
    private var listener: AuthStateDidChangeListenerHandle?
    let signInPublisher = PassthroughSubject<Void, Never>()
    let signOutPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        setupListener()
    }
    
    
    // ***** Auth Functions *****
    
    func setupListener() {
        listener = auth.addStateDidChangeListener { [weak self] _, user in
            self?.userAuth = user.map(UserAuth.init(from:)) ?? UserAuth.blankUser
            if Auth.auth().currentUser != nil {
                debugPrint( "[setupListener]: " + (self?.userAuth.uid ?? "no uid") )
                self?.postSignInSetup()
            } else {
                self?.postSignOutCleanup()
            }
        }
    }
    
    
//    func requestNewAccountWithCandidate(_ candidate: UserCandidate) async throws {
//        guard candidate.isValid else {
//            throw AccountCreationError.invalidInput
//        }
//        
//        // start the process
//        isCreatingUser = true
//        UserDefaults.standard.set(candidate.displayName, forKey: "displayName")
//        
//        // request that service email a link to start account creation
//        do {
//            try await requestSignInLinkEmail(toEmail: candidate.email)
//        } catch {
//            isCreatingUser = false
//            throw error
//        }
//    }
        
//    func requestSignInLinkEmail(toEmail email: String) async throws {
//        
//        isWaitingOnEmailVerification = true
//        UserDefaults.standard.set(email, forKey: "emailForSignIn")
//
//        let actionCodeSettings = ActionCodeSettings()
//        actionCodeSettings.url = URL(string: "https://bracketdash.page.link/ios")
//        actionCodeSettings.handleCodeInApp = true
//        try await auth.sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
//        
//    }
    
//    func completeSignInWithUrlLink(_ url: URL) async {
//        
//        isWaitingOnEmailVerification = false
//        guard let email = UserDefaults.standard.string(forKey: "emailForSignIn")
//        else {
//            authError = SignInError.signInInputsNotFound
//            isCreatingUser = false
//            return
//        }
//        
//        if auth.isSignIn(withEmailLink: url.absoluteString) {
//            
//            isSigningIn = true
//            do {
//                let authDataResult = try await auth.signIn(withEmail: email, link: url.absoluteString)
//                debugPrint("[completeCreateAccount]: " + authDataResult.user.uid)
//                postSignInSetup()
//                isSigningIn = false
//            } catch {
//                authError = error
//                isSigningIn = false
//                isCreatingUser = false
//                return
//            }
//        } else {
//            authError = SignInError.emailLinkInvalid
//            isCreatingUser = false
//            return
//        }
//        
//        if isCreatingUser {
//            await createUserProfile()
//        }
//        UserDefaults.standard.removeObject(forKey: "emailForSignIn")
//    }
    
    func createUserProfile() async {

        // create our custom user profile
        isCreatingUserProfile = true
        
        guard let email = UserDefaults.standard.string(forKey: "emailForSignIn"),
              let diplayName = UserDefaults.standard.string(forKey: "displayName")
        else {
            authError = AccountCreationError.userProfileInputsNotFound
            isCreatingUserProfile = false
            isCreatingUser = false
            return
        }

        do {
            let profile = UserProfileCandidate(
                uid: self.userAuth.uid,
                updateDeviceStamp: deviceIdentifierstamp(),
                updateDeviceTimestamp: deviceTimestamp(),
                createUserEmail: email,
                displayName: diplayName)
            
            let profileId = try await createUserProfile(profile)
            user.profile = UserProfile(id: profileId,
                                       uid: profile.uid,
                                       updateDeviceStamp: profile.updateDeviceStamp,
                                       updateDeviceTimestamp: profile.updateDeviceTimestamp,
                                       createUserEmail: profile.createUserEmail,
                                       displayName: profile.displayName)
        }
        catch {
            authError = AccountCreationError.userProfileCreationIncomplete(error)
        }
    
        // finish the create process
        UserDefaults.standard.removeObject(forKey: "displayName")
        isCreatingUserProfile = false
        isCreatingUser = false
    }
    
    func signOut() throws {
        try auth.signOut()
    }
 
        
    // ***** App Functions *****
    
    func postSignInSetup() {
        Task {
            if !isCreatingUser {
                do {
                    user.profile = try await fetchUserProfile(forUserId: userAuth.uid)
                }
                catch {
                    throw UserProfileError.userProfileFetch(error)
                }
            }
            
            messagesToUser = .loading
            do {
                messagesToUser = .loaded(try await messageService.fetchPrivateMessagesToUser(uid: userAuth.uid))
            }
            catch {
                messagesToUser = .error(error)
            }
            
            messagesFromUser = .loading
            do {
                messagesFromUser = .loaded(try await messageService.fetchPrivateMessagesFromUser(uid: userAuth.uid))
            }
            catch {
                messagesFromUser = .error(error)
            }
            
            isSignedIn = true
            signInPublisher.send()
        }
    }
    
    func postSignOutCleanup() {
        user = User.blankUser
        messagesToUser = .empty
        messagesFromUser = .empty
        self.isSignedIn = false
        signOutPublisher.send()
    }
    
}

extension CurrentUserService {
    
    private func makeUser(
        from userAuth: UserAuth,
        userProfile: UserProfile
    ) -> User {
        return User(
            email: userAuth.email,
            phoneNumber: userAuth.phoneNumber,
            profile: userProfile
        )
    }
    
    private func makeUserProfile(
        from firebaseProfile: GetUserProfileQuery.Data.UserProfile
    ) throws -> UserProfile {
        return UserProfile(
            id: firebaseProfile.id,
            uid: firebaseProfile.uid,
            createTimestamp: firebaseProfile.createTimestamp.dateValue(),
            updateDeviceStamp: firebaseProfile.updateDeviceStamp,
            updateDeviceTimestamp: firebaseProfile.updateDeviceTimestamp,
            createUserEmail: firebaseProfile.createUserEmail,
            displayName: firebaseProfile.displayName,
            photoUrl: firebaseProfile.photoUrl == nil ? nil : firebaseProfile.displayName,
            settingsString: firebaseProfile.settingsString == nil ? nil : firebaseProfile.settingsString
        )
    }
    
}


private extension CurrentUserService {
    
    func fetchUserProfile(forUserId uid: String) async throws -> UserProfile {
        guard !uid.isEmpty else { throw FetchDataError.invalidFunctionInput}
        let queryRef = DataConnect.defaultConnector.getUserProfileQuery.ref(uid: uid)
        let operationResult = try await queryRef.execute()
        let profiles = try operationResult.data.userProfiles.compactMap { firebaseProfile -> UserProfile? in
            let profile = try makeUserProfile(from: firebaseProfile)
            guard profile.isValid else { throw FetchDataError.invalidCloudData }
            return profile
        }
        if profiles.count == 1 { return profiles.first! }
        else if profiles.count >= 1 { throw FetchDataError.userDataDuplicatesFound }
        else { throw FetchDataError.userDataNotFound }
    }
    
    func createUserProfile(_ profile: UserProfileCandidate) async throws -> UUID {
        guard profile.isValid else { throw UpsertDataError.invalidFunctionInput }
        let operationResult = try await DataConnect.defaultConnector.insertUserProfileMutation.execute(
            uid: profile.uid,
            updateDeviceStamp: profile.updateDeviceStamp,
            updateDeviceTimestamp: profile.updateDeviceTimestamp,
            createUserEmail: profile.createUserEmail,
            displayName: profile.displayName
        )
        return operationResult.data.userProfile_insert.id
    }

    func updateUserProfile(_ profile: UserProfile) async throws {
        guard profile.isValid,
              let profileId = profile.id
        else { throw UpsertDataError.invalidFunctionInput }
        _ = try await DataConnect.defaultConnector.updateUserProfileMutation.execute(
            id: profileId,
            updateDeviceStamp: profile.updateDeviceStamp,
            updateDeviceTimestamp: profile.updateDeviceTimestamp,
            displayName: profile.displayName,
            photoUrl: profile.photoUrl ?? "",
            settingsString: profile.settingsString ?? ""
        )
    }
    
}


private extension UserAuth {
    init(from firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.phoneNumber = firebaseUser.phoneNumber ?? ""
    }
}

/* This code below allows you to put custom keyed-value data on to the auth user profile
 * we don't intend to do this, will use a custom data connect user profile instead
private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
*/


#if DEBUG
class CurrentUserTestData: CurrentUserService {
    let startSignedIn: Bool
    
    init(startSignedIn: Bool = true) {
        isPreviewTestData = true
        self.startSignedIn = startSignedIn
    }
    
    static let sharedSignedIn = CurrentUserTestData(startSignedIn: true) as CurrentUserService
    static let sharedSignedOut = CurrentUserTestData(startSignedIn: false) as CurrentUserService
    
    override func setupListener() {
        if startSignedIn {
            testSignIn()
        } else {
            testSignOut()
        }
    }
 
//    override func requestSignInLinkEmail(toEmail: String) async throws {
//        testSignIn()
//    }
    
    func testSignIn() {
        self.user = User.testUser
        self.messagesToUser = .loaded([PrivateMessage.testMessage])
        self.messagesFromUser = .loaded([PrivateMessage.testMessageAnother])
        self.isSignedIn = true
    }

    override func signOut() throws {
        testSignOut()
    }
    
    func testSignOut() {
        self.user = User.blankUser
        self.messagesToUser = .empty
        self.messagesFromUser = .empty
        self.isSignedIn = false
    }
}
#endif
