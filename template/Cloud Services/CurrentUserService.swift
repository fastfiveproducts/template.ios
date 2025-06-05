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
import FirebaseDataConnect
import DefaultConnector

@MainActor
class CurrentUserService: ObservableObject, DebugPrintable {
    
    static let shared = CurrentUserService()     // this store passed to view models as singleton
    
    // ***** Status and Modes *****
    @Published var isCreatingUser = false
    @Published var isSigningIn = false
    @Published var isSignedIn = false
    @Published var isCreatingUserProfile = false
    @Published var isWaitingOnEmailVerification = false
    
    // ***** User *****
    @Published var userAccount: UserAccount = UserAccount.blankUser
    var userKey: UserKey { UserKey(uid: userAccount.auth.uid, displayName: userAccount.profile.displayName) }
    
    // ***** Cloud Auth *****
    @Published var error: Error?
    private let auth = Auth.auth()
    private var userAuth = UserAuth.blankUser
    private var listener: AuthStateDidChangeListenerHandle?
    let signInPublisher = PassthroughSubject<Void, Never>()
    let signOutPublisher = PassthroughSubject<Void, Never>()
    
    init() {
        setupListener()
    }
    
    
    // ***** Listener and Publisher Functions *****
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
    
    private func postSignInSetup() {
        Task {
            if isCreatingUser {
                userAccount = UserAccount(auth: userAuth, profile: UserProfile.blankUser)
                isSigningIn = false
                isCreatingUser = false
                isSignedIn = true
                debugprint ("setup after user sign-in as part of creating new user; publishing sign-in")
                signInPublisher.send()
            } else {
                do {
                    let userProfile = try await fetchMyUserProfile()
                    userAccount = UserAccount(auth: userAuth, profile: userProfile)
                    isSigningIn = false
                    isSignedIn = true
                    debugprint ("setup after user sign-in; publishing sign-in")
                    signInPublisher.send()
                }
                catch {
                    userAccount = UserAccount(auth: userAuth, profile: UserProfile.blankUser)
                    isSigningIn = false
                    isSignedIn = true
                    debugprint ("WARNING: unable to fetch user profile after user sign-in; execution will continue")
                    debugprint ("setup after user sign-in; publishing sign-in")
                    signInPublisher.send()
                    self.error = UserProfileError.userProfileFetch(error)
                    throw UserProfileError.userProfileFetch(error)
                }
            }
        }
    }
    
    private func postSignOutCleanup() {
        userAuth = UserAuth.blankUser
        userAccount = UserAccount(auth: userAuth, profile: UserProfile.blankUser)
        isSignedIn = false
        debugprint ("cleaned-up after user sign-out; publishing sign-out")
        signOutPublisher.send()
    }
    
    
    // ***** Auth Functions *****
    func signInExistingUser(email: String, password: String) async throws -> String {
        do {
            isSigningIn = true
            let result = try await auth.signIn(withEmail: email, password: password)
            if !result.user.uid.isEmpty {
                isSigningIn = false
                debugprint("signIn returned successful but user.uid is empty.")
                self.error = SignInError.userIdNotFound
            }
            return result.user.uid          // user existed + sign-in successful = we are done
        } catch {
            isSigningIn = false
            let nsError = error as NSError
            if nsError.code == AuthErrorCode.userNotFound.rawValue {
                debugprint("User not found for Sign-In, error: \(error)")
                throw SignInError.userNotFound
            } else {
                debugprint("User Sign-In error: \(error)")
                self.error = error
                throw error
            }
        }
    }
    
    func signInOrCreateUser(email: String, password: String) async throws -> String {
        do {
            isSigningIn = true
            let result = try await auth.signIn(withEmail: email, password: password)
            if !result.user.uid.isEmpty {
                isSigningIn = false
                debugprint("signIn - via signInOrCreateUser func - returned successful but user.uid is empty.")
                self.error = SignInError.userIdNotFound
            }
            return result.user.uid          // user existed + sign-in successful = we are done
        } catch {
            let nsError = error as NSError
            
            if nsError.code == AuthErrorCode.userNotFound.rawValue {
                isCreatingUser = true
                do {
                    let result = try await auth.createUser(withEmail: email, password: password)
                    guard !result.user.uid.isEmpty else {
                        isCreatingUser = false
                        /* isCreatingUser = false  // let postSignInSetup() flip this */
                        debugprint("createUser returned successful but user.uid is empty.")
                        self.error = AccountCreationError.userIdNotFound
                        throw AccountCreationError.userIdNotFound
                    }
                    return result.user.uid  // user did not exist + create successful = we are done
                } catch {
                    isSigningIn = false     // failed
                    isCreatingUser = false  // failed
                    debugprint("User Create error: \(error)")
                    self.error = AccountCreationError.userCreationIncomplete(error)
                    throw AccountCreationError.userCreationIncomplete(error)
                }
            } else {
                isSigningIn = false
                debugprint("User Sign-In error: \(error)")
                self.error = error
                throw error
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
}


extension CurrentUserService {
    func createUserProfile(_ profile: UserProfileCandidate) async throws {
        guard profile.isValid
        else { throw UpsertDataError.invalidFunctionInput }

        isCreatingUserProfile = true
        do {
            let _ = try await DataConnect.defaultConnector.createUserMutation.execute(
                createDeviceIdentifierstamp: deviceIdentifierstamp(),
                createDeviceTimestamp: deviceTimestamp(),
                displayNameText: profile.displayName,
                photoUrl: profile.photoUrl
            )
            let userProfile = UserProfile(uid: profile.uid, displayName: profile.displayName, photoUrl: profile.displayName)
            userAccount.profile = userProfile
            isCreatingUserProfile = false
        }
        catch {
            isCreatingUserProfile = false   // failed
            self.error = AccountCreationError.userProfileCreationIncomplete(error)
            throw AccountCreationError.userProfileCreationIncomplete(error)
        }
    }
}


// ***** Auth Functions via Passwordless Email Link *****
// ***** WARNING - placeholder only - not fully implemented - not tested *****
extension CurrentUserService {
    
    func requestNewAccount(email: String, displayName: String) async throws {
        guard !email.isEmpty, !displayName.isEmpty else {
            throw AccountCreationError.invalidInput
        }
        
        // start the process
        isCreatingUser = true
        UserDefaults.standard.set(displayName, forKey: "displayName")
        
        // request that service email a link to start account creation
        do {
            try await requestSignInLinkEmail(toEmail: email)
        } catch {
            isCreatingUser = false
            throw error
        }
    }
    
    func requestSignInLinkEmail(toEmail email: String) async throws {
          
          isWaitingOnEmailVerification = true
          UserDefaults.standard.set(email, forKey: "emailForSignIn")

          let actionCodeSettings = ActionCodeSettings()
          actionCodeSettings.url = URL(string: "https://placeholder.page.link/ios")
          actionCodeSettings.handleCodeInApp = true
          try await auth.sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
          
      }
      
      func completeSignInWithUrlLink(_ url: URL) async {
          
          isWaitingOnEmailVerification = false
          
          guard let email = UserDefaults.standard.string(forKey: "emailForSignIn"),
                let diplayName = UserDefaults.standard.string(forKey: "displayName")
          else {
              self.error = SignInError.signInInputsNotFound
              isCreatingUserProfile = false
              isCreatingUser = false
              return
          }
          
          var userId: String = ""
          
          if auth.isSignIn(withEmailLink: url.absoluteString) {
              
              isSigningIn = true
              do {
                  let result = try await auth.signIn(withEmail: email, link: url.absoluteString)
                  userId = result.user.uid
                  debugPrint("[completeCreateAccount]: " + result.user.uid)
                  postSignInSetup()
                  isSigningIn = false
              } catch {
                  self.error = error
                  isSigningIn = false
                  isCreatingUser = false
                  return
              }
          } else {
              self.error = SignInError.emailLinkInvalid
              isCreatingUser = false
              return
          }
          
          if isCreatingUser {
              do {
                  try await createUserProfile(UserProfileCandidate(uid: userId, displayName: diplayName, photoUrl: ""))
                  UserDefaults.standard.removeObject(forKey: "emailForSignIn")
                  UserDefaults.standard.removeObject(forKey: "displayName")
              } catch {
                  debugprint("(View) User \(userId) created but Clould error creating User Profile. Error: \(error)")
                  self.error = error
              }
          }
      }
}


// ***** User Profile Functions *****
extension CurrentUserService {
    
    func fetchMyUserProfile() async throws -> UserProfile {
        let queryRef = DataConnect.defaultConnector.getMyUserProfileQuery.ref()
        let operationResult = try await queryRef.execute()
        let profiles = try operationResult.data.users.compactMap { firebaseProfile -> UserProfile? in
            let profile = try makeUserProfile(from: firebaseProfile)
            guard profile.isValid else { throw FetchDataError.invalidCloudData }
            return profile
        }
        if profiles.count == 1 { return profiles.first! }
        else if profiles.count >= 1 { throw FetchDataError.userDataDuplicatesFound }
        else { throw FetchDataError.userDataNotFound }
    }
    
    func updateUserProfile(_ profile: UserProfile) async throws {
        guard profile.isValid
        else { throw UpsertDataError.invalidFunctionInput }
        let _ = try await DataConnect.defaultConnector.updateUserMutation.execute(
            updateDeviceIdentifierstamp: deviceIdentifierstamp(),
            updateDeviceTimestamp: deviceTimestamp(),
            displayNameText: profile.displayName,
            photoUrl: profile.photoUrl
        )
    }
    
    func fetchUserProfile(forUserId uid: String) async throws -> UserProfile {
        guard !uid.isEmpty else { throw FetchDataError.invalidFunctionInput}
        let queryRef = DataConnect.defaultConnector.getUserProfileQuery.ref(userId: uid)
        let operationResult = try await queryRef.execute()
        let profiles = try operationResult.data.users.compactMap { firebaseProfile -> UserProfile? in
            let profile = try makeUserProfile(from: firebaseProfile)
            guard profile.isValid else { throw FetchDataError.invalidCloudData }
            return profile
        }
        if profiles.count == 1 { return profiles.first! }
        else if profiles.count >= 1 { throw FetchDataError.userDataDuplicatesFound }
        else { throw FetchDataError.userDataNotFound }
    }
}


// ***** helpers to make local structs *****

private extension UserAuth {
    init(from firebaseUser: FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.phoneNumber = firebaseUser.phoneNumber ?? ""
    }
}

extension CurrentUserService {
    private func makeUserProfile(
        from firebaseProfile: GetUserProfileQuery.Data.User
    ) throws -> UserProfile {
        return UserProfile(
            uid: firebaseProfile.id,
            displayName: firebaseProfile.displayNameText,
            photoUrl: firebaseProfile.photoUrl
        )
    }
    private func makeUserProfile(
        from firebaseProfile: GetMyUserProfileQuery.Data.User
    ) throws -> UserProfile {
        return UserProfile(
            uid: firebaseProfile.id,
            displayName: firebaseProfile.displayNameText,
            photoUrl: firebaseProfile.photoUrl
        )
    }
}


// ***** Custom Auth User Profile Data *****
/* This code below allows you to put custom keyed-value data on to the auth user profile
 * This app doesn't intend this and will use a custom data connect user profile instead
private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
*/


#if DEBUG
class CurrentUserTestService: CurrentUserService {
    let startSignedIn: Bool
    let startCreatingUser: Bool
    
    init(startSignedIn: Bool, startCreatingUser: Bool = false) {
        self.startSignedIn = startSignedIn
        self.startCreatingUser = startCreatingUser
    }
    
    static let sharedSignedIn = CurrentUserTestService(startSignedIn: true) // as CurrentUserService
    static let sharedSignedOut = CurrentUserTestService(startSignedIn: false) // as CurrentUserService
    static let sharedCreatingUser = CurrentUserTestService(startSignedIn: false, startCreatingUser: true) // as CurrentUserService
    
    func nextSignInState() {
        if isSigningIn {
            debugprint("was isSigningIn")
            isCreatingUser = false
            isSigningIn = false
            isSignedIn = true
            isCreatingUserProfile = false
        } else if isSignedIn {
            debugprint("was CreatingUserProfile")
            isCreatingUser = false
            isSigningIn = false
            isSignedIn = false
            isCreatingUserProfile = false
        } else {
            debugprint("was Signed Out")
            isCreatingUser = false
            isSigningIn = true
            isSignedIn = false
            isCreatingUserProfile = false
        }
    }
    
    func nextCreateState() {
        if isCreatingUser {
            debugprint("was isCreatingUser")
            isCreatingUser = false
            isSigningIn = false
            isSignedIn = true
            isCreatingUserProfile = true
        } else if isCreatingUserProfile {
            debugprint("was CreatingUserProfile")
            isCreatingUser = false
            isSigningIn = false
            isSignedIn = true
            isCreatingUserProfile = false
        } else {
            debugprint("reset")
            isCreatingUser = true
            isSigningIn = false
            isSignedIn = false
            isCreatingUserProfile = false
        }
    }
    
    override func setupListener() {
        if startSignedIn {
            loadTestUser()
        } else {
            loadBlankUser()
        }
        isCreatingUser = startCreatingUser
    }
    
    override func signInExistingUser(email: String, password: String) async throws -> String {
        loadTestUser()
        return self.userKey.uid
    }
    
    override func signInOrCreateUser(email: String, password: String) async throws -> String {
        loadTestUser()
        return self.userKey.uid
    }
        
    override func signOut() throws {
        loadBlankUser()
    }
    
    private func loadTestUser() {
        userAccount = UserAccount.testObject
        isCreatingUser = false
        isSigningIn = false
        isSignedIn = true
        isCreatingUserProfile = false
    }
    
    private func loadBlankUser() {
        self.userAccount = UserAccount.blankUser
        userAccount = UserAccount.testObject
        isCreatingUser = false
        isSigningIn = false
        isSignedIn = false
        isCreatingUserProfile = false
    }
    
}
#endif
