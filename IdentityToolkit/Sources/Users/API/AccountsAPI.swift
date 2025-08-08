import Core
import Foundation
import AsyncHTTPClient
import NIO
import NIOHTTP1

public protocol AccountsAPI {
    /// Sends a SMS verification code for phone number sign-in
    /// - Parameters:
    ///   - phoneNumber: The phone number to send the verification code to in E.164 format
    ///   - iosReceipt: Receipt of successful iOS app token validation
    ///   - iosSecret: Secret delivered to iOS app as a push notification
    ///   - recaptchaToken: Recaptcha token for app verification
    ///   - tenantId: Tenant ID of the Identity Platform tenant the user is signing in to
    ///   - autoRetrievalInfo: Android only. Used by Google Play Services to identify the app for auto-retrieval
    ///   - safetyNetToken: Android only. Used to assert application identity in place of a recaptcha token
    ///   - playIntegrityToken: Android only. Used to assert application identity in place of a recaptcha token
    ///   - captchaResponse: The reCAPTCHA Enterprise token
    ///   - clientType: The client type (web, android or ios)
    ///   - recaptchaVersion: The reCAPTCHA version
    ///   - locale: The language code for localizing the SMS text (e.g. "en", "es", "fr")
    func sendVerificationCode(
        phoneNumber: String,
        iosReceipt: String?,
        iosSecret: String?,
        recaptchaToken: String?,
        tenantId: String?,
        autoRetrievalInfo: AutoRetrievalInfo?,
        safetyNetToken: String?,
        playIntegrityToken: String?,
        captchaResponse: String?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?,
        locale: String?
    ) -> EventLoopFuture<SendVerificationCodeResponse>

    /// Sends an out-of-band (OOB) code for email sign-in, password reset, or email verification
    /// - Parameters:
    ///   - requestType: The type of out-of-band (OOB) code to send
    ///   - email: The account's email address to send the OOB code to
    ///   - captchaResp: The reCAPTCHA response for PASSWORD_RESET requests
    ///   - userIp: The IP address of the caller (required for PASSWORD_RESET)
    ///   - newEmail: The new email address for VERIFY_AND_CHANGE_EMAIL requests
    ///   - idToken: An ID token for the account
    ///   - continueUrl: The URL to continue after user clicks the email link
    ///   - iOSBundleId: iOS bundle ID that can handle the OOB code
    ///   - iOSAppStoreId: iOS App Store ID
    ///   - androidPackageName: Android package name that can handle the OOB code
    ///   - androidInstallApp: Whether to install Android app if not present
    ///   - androidMinimumVersion: Minimum required Android app version
    ///   - canHandleCodeInApp: Whether the OOB code can be handled in-app
    ///   - tenantId: Tenant ID of the Identity Platform tenant
    ///   - targetProjectId: Target Project ID
    ///   - dynamicLinkDomain: Firebase Dynamic Link domain
    ///   - returnOobLink: Whether to return the OOB link in response
    ///   - clientType: The client type
    ///   - recaptchaVersion: The reCAPTCHA version
    func sendOobCode(
        requestType: OobReqType,
        email: String?,
        captchaResp: String?,
        userIp: String?,
        newEmail: String?,
        idToken: String?,
        continueUrl: String?,
        iOSBundleId: String?,
        iOSAppStoreId: String?,
        androidPackageName: String?,
        androidInstallApp: Bool?,
        androidMinimumVersion: String?,
        canHandleCodeInApp: Bool?,
        tenantId: String?,
        targetProjectId: String?,
        dynamicLinkDomain: String?,
        returnOobLink: Bool?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?
    ) -> EventLoopFuture<SendOobCodeResponse>

    /// Creates an authorization URI for an Identity Provider or checks for existing accounts
    /// - Parameters:
    ///   - identifier: The email identifier to check for existing accounts
    ///   - continueUri: URL for IdP redirect
    ///   - providerId: The provider ID of the IdP
    ///   - oauthScope: Additional OAuth 2.0 scopes
    ///   - context: Contextual information for auth flow
    ///   - hostedDomain: G Suite hosted domain (Google provider only)
    ///   - sessionId: Session ID to prevent fixation attacks
    ///   - authFlowType: Authentication flow type (Google provider only)
    ///   - customParameter: Additional custom query parameters
    ///   - tenantId: Identity Platform tenant ID
    func createAuthUri(
        identifier: String?,
        continueUri: String?,
        providerId: String?,
        oauthScope: String?,
        context: String?,
        hostedDomain: String?,
        sessionId: String?,
        authFlowType: String?,
        customParameter: [String: String]?,
        tenantId: String?
    ) -> EventLoopFuture<CreateAuthUriResponse>

    /// Deletes a user's account
    /// - Parameters:
    ///   - localId: The ID of user account to delete (requires OAuth credentials)
    ///   - idToken: The Identity Platform ID token of the account to delete
    ///   - tenantId: The ID of the tenant that the account belongs to
    ///   - targetProjectId: The ID of the project which the account belongs to
    func deleteAccount(
        localId: String?,
        idToken: String?,
        tenantId: String?,
        targetProjectId: String?
    ) -> EventLoopFuture<DeleteAccountResponse>

    /// Issues a SAML response for a Relying Party
    /// - Parameters:
    ///   - rpId: Relying Party identifier (audience of issued SAMLResponse)
    ///   - idToken: The Identity Platform ID token
    ///   - samlAppEntityId: SAML app entity id from Google Admin Console
    func issueSamlResponse(
        rpId: String,
        idToken: String,
        samlAppEntityId: String?
    ) -> EventLoopFuture<IssueSamlResponseResponse>

    /// Gets account information for all matched accounts
    /// - Parameters:
    ///   - idToken: The Identity Platform ID token of the account to fetch
    ///   - localId: The IDs of accounts to fetch
    ///   - email: The email addresses of accounts to fetch
    ///   - phoneNumber: The phone numbers of accounts to fetch
    ///   - federatedUserId: The federated user identifiers of accounts to fetch
    ///   - tenantId: The ID of the tenant that the account belongs to
    ///   - targetProjectId: The ID of the Google Cloud project
    ///   - initialEmail: The initial email addresses of accounts to fetch
    func lookup(
        idToken: String?,
        localId: [String]?,
        email: [String]?,
        phoneNumber: [String]?,
        federatedUserId: [FederatedUserIdentifier]?,
        tenantId: String?,
        targetProjectId: String?,
        initialEmail: [String]?
    ) -> EventLoopFuture<LookupAccountResponse>

    /// Resets the password of an account
    /// - Parameters:
    ///   - oobCode: Out-of-band code from sendOobCode
    ///   - newPassword: The new password to set
    ///   - oldPassword: The current password (when not using OOB code)
    ///   - email: The account email (when not using OOB code)
    ///   - tenantId: The tenant ID of the Identity Platform tenant
    func resetPassword(
        oobCode: String?,
        newPassword: String?,
        oldPassword: String?,
        email: String?,
        tenantId: String?
    ) -> EventLoopFuture<ResetPasswordResponse>

    /// Signs in or signs up a user by exchanging a custom Auth token
    /// - Parameters:
    ///   - token: The custom Auth token asserted by the developer
    ///   - returnSecureToken: Should always be true
    ///   - tenantId: The ID of the Identity Platform tenant
    func signInWithCustomToken(
        token: String,
        returnSecureToken: Bool,
        tenantId: String?
    ) -> EventLoopFuture<SignInWithCustomTokenResponse>

    /// Signs in or signs up a user with a out-of-band code from an email link
    /// - Parameters:
    ///   - oobCode: The out-of-band code from the email link
    ///   - email: The email address the sign-in link was sent to
    ///   - idToken: A valid ID token for linking the email to an existing account
    ///   - tenantId: The ID of the Identity Platform tenant
    func signInWithEmailLink(
        oobCode: String,
        email: String,
        idToken: String?,
        tenantId: String?
    ) -> EventLoopFuture<SignInWithEmailLinkResponse>

    /// Signs in or signs up a user with iOS Game Center credentials
    /// - Parameters:
    ///   - playerId: The user's Game Center player ID (Deprecated by Apple)
    ///   - publicKeyUrl: The URL to fetch the Apple public key
    ///   - signature: The verification signature data generated by Apple
    ///   - salt: A random string used to generate the signature
    ///   - timestamp: The time when the signature was created by Apple
    ///   - idToken: A valid ID token for linking Game Center to an existing account
    ///   - displayName: The user's Game Center display name
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - teamPlayerId: The user's Game Center team player ID
    ///   - gamePlayerId: The user's Game Center game player ID
    ///   - bundleId: The iOS app's bundle identifier
    func signInWithGameCenter(
        playerId: String,
        publicKeyUrl: String,
        signature: String,
        salt: String,
        timestamp: String,
        idToken: String?,
        displayName: String?,
        tenantId: String?,
        teamPlayerId: String?,
        gamePlayerId: String?,
        bundleId: String
    ) -> EventLoopFuture<SignInWithGameCenterResponse>

    /// Signs in or signs up a user using credentials from an Identity Provider
    /// - Parameters:
    ///   - requestUri: The URL to which the IdP redirects the user back
    ///   - postBody: The POST body containing IdP credentials
    ///   - returnRefreshToken: Whether to return the OAuth refresh token
    ///   - sessionId: Session ID from createAuthUri
    ///   - idToken: A valid Identity Platform ID token for linking
    ///   - returnSecureToken: Should always be true
    ///   - returnIdpCredential: Whether to return OAuth credentials on errors
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - pendingToken: Opaque string from previous response
    func signInWithIdp(
        requestUri: String,
        postBody: String,
        returnRefreshToken: Bool?,
        sessionId: String?,
        idToken: String?,
        returnSecureToken: Bool?,
        returnIdpCredential: Bool?,
        tenantId: String?,
        pendingToken: String?
    ) -> EventLoopFuture<SignInWithIdpResponse>

    /// Signs in a user with email and password
    /// - Parameters:
    ///   - email: The email the user is signing in with
    ///   - password: The password the user provides
    ///   - captchaResponse: The reCAPTCHA token
    ///   - returnSecureToken: Should always be true
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - clientType: The client type (required for reCAPTCHA Enterprise)
    ///   - recaptchaVersion: The reCAPTCHA version
    func signInWithPassword(
        email: String,
        password: String,
        captchaResponse: String?,
        returnSecureToken: Bool?,
        tenantId: String?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?
    ) -> EventLoopFuture<SignInWithPasswordResponse>

    /// Signs in or signs up a user with a phone number
    /// - Parameters:
    ///   - sessionInfo: Encrypted session information from sendVerificationCode
    ///   - phoneNumber: The user's phone number to sign in with
    ///   - code: User-entered verification code from SMS
    ///   - temporaryProof: A proof of the phone number verification
    ///   - idToken: A valid ID token for linking accounts
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - locale: The language code for localizing the SMS text
    func signInWithPhoneNumber(
        sessionInfo: String?,
        phoneNumber: String?,
        code: String?,
        temporaryProof: String?,
        idToken: String?,
        tenantId: String?,
        locale: String?
    ) -> EventLoopFuture<SignInWithPhoneNumberResponse>

    /// Signs up a new user or upgrades an anonymous user
    /// - Parameters:
    ///   - email: The email to assign to the created user
    ///   - password: The password to assign to the created user
    ///   - displayName: The display name of the user
    ///   - captchaResponse: The reCAPTCHA token
    ///   - idToken: A valid ID token for linking credentials
    ///   - emailVerified: Whether the user's email is verified
    ///   - photoUrl: The profile photo url of the user
    ///   - disabled: Whether the user will be disabled
    ///   - localId: The ID of the user to create
    ///   - phoneNumber: The phone number of the user
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - targetProjectId: The project ID of the target project
    ///   - mfaInfo: The multi-factor authentication providers
    ///   - clientType: The client type (required for reCAPTCHA Enterprise)
    ///   - recaptchaVersion: The reCAPTCHA version
    func signUp(
        email: String?,
        password: String?,
        displayName: String?,
        captchaResponse: String?,
        idToken: String?,
        emailVerified: Bool?,
        photoUrl: String?,
        disabled: Bool?,
        localId: String?,
        phoneNumber: String?,
        tenantId: String?,
        targetProjectId: String?,
        mfaInfo: [MfaFactor]?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?
    ) -> EventLoopFuture<SignUpResponse>

    /// Updates account information for the specified user
    /// - Parameters:
    ///   - idToken: A valid Identity Platform ID token
    ///   - localId: The ID of the user
    ///   - displayName: The user's new display name
    ///   - email: The user's new email
    ///   - password: The user's new password
    ///   - provider: The Identity Providers to associate
    ///   - oobCode: The out-of-band code to apply
    ///   - emailVerified: Whether the user's email is verified
    ///   - upgradeToFederatedLogin: Whether to restrict to federated login
    ///   - captchaResponse: The reCAPTCHA response
    ///   - validSince: Minimum timestamp for valid tokens
    ///   - disableUser: Whether to disable the account
    ///   - photoUrl: The user's new photo URL
    ///   - deleteAttribute: The account's attributes to delete
    ///   - returnSecureToken: Whether to return tokens
    ///   - deleteProvider: The Identity Providers to unlink
    ///   - lastLoginAt: When the account last logged in
    ///   - createdAt: When the account was created
    ///   - phoneNumber: The phone number to update
    ///   - customAttributes: Custom attributes for the ID token
    ///   - tenantId: The tenant ID
    ///   - targetProjectId: The project ID
    ///   - mfa: The MFA information to set
    ///   - linkProviderUserInfo: The provider to link
    func update(
        idToken: String?,
        localId: String?,
        displayName: String?,
        email: String?,
        password: String?,
        provider: [String]?,
        oobCode: String?,
        emailVerified: Bool?,
        upgradeToFederatedLogin: Bool?,
        captchaResponse: String?,
        validSince: String?,
        disableUser: Bool?,
        photoUrl: String?,
        deleteAttribute: [UserAttributeName]?,
        returnSecureToken: Bool?,
        deleteProvider: [String]?,
        lastLoginAt: String?,
        createdAt: String?,
        phoneNumber: String?,
        customAttributes: String?,
        tenantId: String?,
        targetProjectId: String?,
        mfa: MfaInfo?,
        linkProviderUserInfo: ProviderUserInfo?
    ) -> EventLoopFuture<UpdateAccountResponse>

    /// Verifies an iOS client is a real iOS device
    /// - Parameters:
    ///   - appToken: A device token from APNs registration
    ///   - isSandbox: Whether the app token is in the iOS sandbox
    ///   - bundleId: The iOS app's bundle identifier
    func verifyIosClient(
        appToken: String,
        isSandbox: Bool,
        bundleId: String
    ) -> EventLoopFuture<VerifyIosClientResponse>
}

public extension AccountsAPI {
    /// Convenience method with default parameter values
    func sendVerificationCode(
        phoneNumber: String,
        iosReceipt: String? = nil,
        iosSecret: String? = nil,
        recaptchaToken: String? = nil,
        tenantId: String? = nil,
        autoRetrievalInfo: AutoRetrievalInfo? = nil,
        safetyNetToken: String? = nil,
        playIntegrityToken: String? = nil,
        captchaResponse: String? = nil,
        clientType: ClientType? = nil,
        recaptchaVersion: RecaptchaVersion? = nil,
        locale: String? = nil
    ) -> EventLoopFuture<SendVerificationCodeResponse> {
        return sendVerificationCode(
            phoneNumber: phoneNumber,
            iosReceipt: iosReceipt,
            iosSecret: iosSecret,
            recaptchaToken: recaptchaToken,
            tenantId: tenantId,
            autoRetrievalInfo: autoRetrievalInfo,
            safetyNetToken: safetyNetToken,
            playIntegrityToken: playIntegrityToken,
            captchaResponse: captchaResponse,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion,
            locale: locale
        )
    }

    /// Convenience method with default parameter values
    func sendOobCode(
        requestType: OobReqType,
        email: String? = nil,
        captchaResp: String? = nil,
        userIp: String? = nil,
        newEmail: String? = nil,
        idToken: String? = nil,
        continueUrl: String? = nil,
        iOSBundleId: String? = nil,
        iOSAppStoreId: String? = nil,
        androidPackageName: String? = nil,
        androidInstallApp: Bool? = nil,
        androidMinimumVersion: String? = nil,
        canHandleCodeInApp: Bool? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        dynamicLinkDomain: String? = nil,
        returnOobLink: Bool? = nil,
        clientType: ClientType? = nil,
        recaptchaVersion: RecaptchaVersion? = nil
    ) -> EventLoopFuture<SendOobCodeResponse> {
        return sendOobCode(
            requestType: requestType,
            email: email,
            captchaResp: captchaResp,
            userIp: userIp,
            newEmail: newEmail,
            idToken: idToken,
            continueUrl: continueUrl,
            iOSBundleId: iOSBundleId,
            iOSAppStoreId: iOSAppStoreId,
            androidPackageName: androidPackageName,
            androidInstallApp: androidInstallApp,
            androidMinimumVersion: androidMinimumVersion,
            canHandleCodeInApp: canHandleCodeInApp,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            dynamicLinkDomain: dynamicLinkDomain,
            returnOobLink: returnOobLink,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion
        )
    }

    /// Convenience method with default parameter values
    func createAuthUri(
        identifier: String? = nil,
        continueUri: String? = nil,
        providerId: String? = nil,
        oauthScope: String? = nil,
        context: String? = nil,
        hostedDomain: String? = nil,
        sessionId: String? = nil,
        authFlowType: String? = nil,
        customParameter: [String: String]? = nil,
        tenantId: String? = nil
    ) -> EventLoopFuture<CreateAuthUriResponse> {
        return createAuthUri(
            identifier: identifier,
            continueUri: continueUri,
            providerId: providerId,
            oauthScope: oauthScope,
            context: context,
            hostedDomain: hostedDomain,
            sessionId: sessionId,
            authFlowType: authFlowType,
            customParameter: customParameter,
            tenantId: tenantId
        )
    }

    /// Convenience method with default parameter values
    func deleteAccount(
        localId: String? = nil,
        idToken: String? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil
    ) -> EventLoopFuture<DeleteAccountResponse> {
        return deleteAccount(
            localId: localId,
            idToken: idToken,
            tenantId: tenantId,
            targetProjectId: targetProjectId
        )
    }

    /// Convenience method with default parameter values
    func issueSamlResponse(
        rpId: String,
        idToken: String,
        samlAppEntityId: String? = nil
    ) -> EventLoopFuture<IssueSamlResponseResponse> {
        return issueSamlResponse(
            rpId: rpId,
            idToken: idToken,
            samlAppEntityId: samlAppEntityId
        )
    }

    /// Convenience method with default parameter values
    func lookup(
        idToken: String? = nil,
        localId: [String]? = nil,
        email: [String]? = nil,
        phoneNumber: [String]? = nil,
        federatedUserId: [FederatedUserIdentifier]? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        initialEmail: [String]? = nil
    ) -> EventLoopFuture<LookupAccountResponse> {
        return lookup(
            idToken: idToken,
            localId: localId,
            email: email,
            phoneNumber: phoneNumber,
            federatedUserId: federatedUserId,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            initialEmail: initialEmail
        )
    }

    /// Convenience method with default parameter values
    func resetPassword(
        oobCode: String? = nil,
        newPassword: String? = nil,
        oldPassword: String? = nil,
        email: String? = nil,
        tenantId: String? = nil
    ) -> EventLoopFuture<ResetPasswordResponse> {
        return resetPassword(
            oobCode: oobCode,
            newPassword: newPassword,
            oldPassword: oldPassword,
            email: email,
            tenantId: tenantId
        )
    }

    /// Signs in or signs up a user by exchanging a custom Auth token
    /// - Parameters:
    ///   - token: The custom Auth token asserted by the developer
    ///   - returnSecureToken: Should always be true
    ///   - tenantId: The ID of the Identity Platform tenant
    func signInWithCustomToken(
        token: String,
        returnSecureToken: Bool,
        tenantId: String?
    ) -> EventLoopFuture<SignInWithCustomTokenResponse> {
        return signInWithCustomToken(
            token: token,
            returnSecureToken: returnSecureToken,
            tenantId: tenantId
        )
    }

    /// Signs in or signs up a user with a out-of-band code from an email link
    /// - Parameters:
    ///   - oobCode: The out-of-band code from the email link
    ///   - email: The email address the sign-in link was sent to
    ///   - idToken: A valid ID token for linking the email to an existing account
    ///   - tenantId: The ID of the Identity Platform tenant
    func signInWithEmailLink(
        oobCode: String,
        email: String,
        idToken: String? = nil,
        tenantId: String? = nil
    ) -> EventLoopFuture<SignInWithEmailLinkResponse> {
        return signInWithEmailLink(
            oobCode: oobCode,
            email: email,
            idToken: idToken,
            tenantId: tenantId
        )
    }

    /// Signs in or signs up a user with iOS Game Center credentials
    /// - Parameters:
    ///   - playerId: The user's Game Center player ID (Deprecated by Apple)
    ///   - publicKeyUrl: The URL to fetch the Apple public key
    ///   - signature: The verification signature data generated by Apple
    ///   - salt: A random string used to generate the signature
    ///   - timestamp: The time when the signature was created by Apple
    ///   - idToken: A valid ID token for linking Game Center to an existing account
    ///   - displayName: The user's Game Center display name
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - teamPlayerId: The user's Game Center team player ID
    ///   - gamePlayerId: The user's Game Center game player ID
    ///   - bundleId: The iOS app's bundle identifier
    func signInWithGameCenter(
        playerId: String,
        publicKeyUrl: String,
        signature: String,
        salt: String,
        timestamp: String,
        idToken: String? = nil,
        displayName: String? = nil,
        tenantId: String? = nil,
        teamPlayerId: String? = nil,
        gamePlayerId: String? = nil,
        bundleId: String
    ) -> EventLoopFuture<SignInWithGameCenterResponse> {
        return signInWithGameCenter(
            playerId: playerId,
            publicKeyUrl: publicKeyUrl,
            signature: signature,
            salt: salt,
            timestamp: timestamp,
            idToken: idToken,
            displayName: displayName,
            tenantId: tenantId,
            teamPlayerId: teamPlayerId,
            gamePlayerId: gamePlayerId,
            bundleId: bundleId
        )
    }

    /// Signs in or signs up a user using credentials from an Identity Provider
    /// - Parameters:
    ///   - requestUri: The URL to which the IdP redirects the user back
    ///   - postBody: The POST body containing IdP credentials
    ///   - returnRefreshToken: Whether to return the OAuth refresh token
    ///   - sessionId: Session ID from createAuthUri
    ///   - idToken: A valid Identity Platform ID token for linking
    ///   - returnSecureToken: Should always be true
    ///   - returnIdpCredential: Whether to return OAuth credentials on errors
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - pendingToken: Opaque string from previous response
    func signInWithIdp(
        requestUri: String,
        postBody: String,
        returnRefreshToken: Bool? = nil,
        sessionId: String? = nil,
        idToken: String? = nil,
        returnSecureToken: Bool? = true,
        returnIdpCredential: Bool? = nil,
        tenantId: String? = nil,
        pendingToken: String? = nil
    ) -> EventLoopFuture<SignInWithIdpResponse> {
        return signInWithIdp(
            requestUri: requestUri,
            postBody: postBody,
            returnRefreshToken: returnRefreshToken,
            sessionId: sessionId,
            idToken: idToken,
            returnSecureToken: returnSecureToken,
            returnIdpCredential: returnIdpCredential,
            tenantId: tenantId,
            pendingToken: pendingToken
        )
    }

    /// Signs in a user with email and password
    /// - Parameters:
    ///   - email: The email the user is signing in with
    ///   - password: The password the user provides
    ///   - captchaResponse: The reCAPTCHA token
    ///   - returnSecureToken: Should always be true
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - clientType: The client type (required for reCAPTCHA Enterprise)
    ///   - recaptchaVersion: The reCAPTCHA version
    func signInWithPassword(
        email: String,
        password: String,
        captchaResponse: String?,
        returnSecureToken: Bool?,
        tenantId: String?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?
    ) -> EventLoopFuture<SignInWithPasswordResponse> {
        return signInWithPassword(
            email: email,
            password: password,
            captchaResponse: captchaResponse,
            returnSecureToken: returnSecureToken,
            tenantId: tenantId,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion
        )
    }

    /// Signs in or signs up a user with a phone number
    /// - Parameters:
    ///   - sessionInfo: Encrypted session information from sendVerificationCode
    ///   - phoneNumber: The user's phone number to sign in with
    ///   - code: User-entered verification code from SMS
    ///   - temporaryProof: A proof of the phone number verification
    ///   - idToken: A valid ID token for linking accounts
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - locale: The language code for localizing the SMS text
    func signInWithPhoneNumber(
        sessionInfo: String? = nil,
        phoneNumber: String? = nil,
        code: String? = nil,
        temporaryProof: String? = nil,
        idToken: String? = nil,
        tenantId: String? = nil,
        locale: String? = nil
    ) -> EventLoopFuture<SignInWithPhoneNumberResponse> {
        return signInWithPhoneNumber(
            sessionInfo: sessionInfo,
            phoneNumber: phoneNumber,
            code: code,
            temporaryProof: temporaryProof,
            idToken: idToken,
            tenantId: tenantId,
            locale: locale
        )
    }

    /// Signs up a new user or upgrades an anonymous user
    /// - Parameters:
    ///   - email: The email to assign to the created user
    ///   - password: The password to assign to the created user
    ///   - displayName: The display name of the user
    ///   - captchaResponse: The reCAPTCHA token
    ///   - idToken: A valid ID token for linking credentials
    ///   - emailVerified: Whether the user's email is verified
    ///   - photoUrl: The profile photo url of the user
    ///   - disabled: Whether the user will be disabled
    ///   - localId: The ID of the user to create
    ///   - phoneNumber: The phone number of the user
    ///   - tenantId: The ID of the Identity Platform tenant
    ///   - targetProjectId: The project ID of the target project
    ///   - mfaInfo: The multi-factor authentication providers
    ///   - clientType: The client type (required for reCAPTCHA Enterprise)
    ///   - recaptchaVersion: The reCAPTCHA version
    func signUp(
        email: String? = nil,
        password: String? = nil,
        displayName: String? = nil,
        captchaResponse: String? = nil,
        idToken: String? = nil,
        emailVerified: Bool? = nil,
        photoUrl: String? = nil,
        disabled: Bool? = nil,
        localId: String? = nil,
        phoneNumber: String? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        mfaInfo: [MfaFactor]? = nil,
        clientType: ClientType? = nil,
        recaptchaVersion: RecaptchaVersion? = nil
    ) -> EventLoopFuture<SignUpResponse> {
        return signUp(
            email: email,
            password: password,
            displayName: displayName,
            captchaResponse: captchaResponse,
            idToken: idToken,
            emailVerified: emailVerified,
            photoUrl: photoUrl,
            disabled: disabled,
            localId: localId,
            phoneNumber: phoneNumber,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            mfaInfo: mfaInfo,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion
        )
    }

    /// Updates account information for the specified user
    /// - Parameters:
    ///   - idToken: A valid Identity Platform ID token
    ///   - localId: The ID of the user
    ///   - displayName: The user's new display name
    ///   - email: The user's new email
    ///   - password: The user's new password
    ///   - provider: The Identity Providers to associate
    ///   - oobCode: The out-of-band code to apply
    ///   - emailVerified: Whether the user's email is verified
    ///   - upgradeToFederatedLogin: Whether to restrict to federated login
    ///   - captchaResponse: The reCAPTCHA response
    ///   - validSince: Minimum timestamp for valid tokens
    ///   - disableUser: Whether to disable the account
    ///   - photoUrl: The user's new photo URL
    ///   - deleteAttribute: The account's attributes to delete
    ///   - returnSecureToken: Whether to return tokens
    ///   - deleteProvider: The Identity Providers to unlink
    ///   - lastLoginAt: When the account last logged in
    ///   - createdAt: When the account was created
    ///   - phoneNumber: The phone number to update
    ///   - customAttributes: Custom attributes for the ID token
    ///   - tenantId: The tenant ID
    ///   - targetProjectId: The project ID
    ///   - mfa: The MFA information to set
    ///   - linkProviderUserInfo: The provider to link
    func update(
        idToken: String? = nil,
        localId: String? = nil,
        displayName: String? = nil,
        email: String? = nil,
        password: String? = nil,
        provider: [String]? = nil,
        oobCode: String? = nil,
        emailVerified: Bool? = nil,
        upgradeToFederatedLogin: Bool? = nil,
        captchaResponse: String? = nil,
        validSince: String? = nil,
        disableUser: Bool? = nil,
        photoUrl: String? = nil,
        deleteAttribute: [UserAttributeName]? = nil,
        returnSecureToken: Bool? = nil,
        deleteProvider: [String]? = nil,
        lastLoginAt: String? = nil,
        createdAt: String? = nil,
        phoneNumber: String? = nil,
        customAttributes: String? = nil,
        tenantId: String? = nil,
        targetProjectId: String? = nil,
        mfa: MfaInfo? = nil,
        linkProviderUserInfo: ProviderUserInfo? = nil
    ) -> EventLoopFuture<UpdateAccountResponse> {
        return update(
            idToken: idToken,
            localId: localId,
            displayName: displayName,
            email: email,
            password: password,
            provider: provider,
            oobCode: oobCode,
            emailVerified: emailVerified,
            upgradeToFederatedLogin: upgradeToFederatedLogin,
            captchaResponse: captchaResponse,
            validSince: validSince,
            disableUser: disableUser,
            photoUrl: photoUrl,
            deleteAttribute: deleteAttribute,
            returnSecureToken: returnSecureToken,
            deleteProvider: deleteProvider,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            phoneNumber: phoneNumber,
            customAttributes: customAttributes,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            mfa: mfa,
            linkProviderUserInfo: linkProviderUserInfo
        )
    }

    /// Verifies an iOS client is a real iOS device
    /// - Parameters:
    ///   - appToken: A device token from APNs registration
    ///   - isSandbox: Whether the app token is in the iOS sandbox
    ///   - bundleId: The iOS app's bundle identifier
    func verifyIosClient(
        appToken: String,
        isSandbox: Bool,
        bundleId: String
    ) -> EventLoopFuture<VerifyIosClientResponse> {
        return verifyIosClient(
            appToken: appToken,
            isSandbox: isSandbox,
            bundleId: bundleId
        )
    }
}

public final class GoogleCloudIdentityToolkitAccountsAPI: AccountsAPI {
    let endpoint: String
    let request: GoogleCloudIdentityToolkitRequest
    private let encoder = JSONEncoder()
    
    init(request: GoogleCloudIdentityToolkitRequest, endpoint: String) {
        self.request = request
        self.endpoint = endpoint
    }

    private var apiKey: String {
        request.apiKey
    }
    
    public func sendVerificationCode(
        phoneNumber: String,
        iosReceipt: String?,
        iosSecret: String?,
        recaptchaToken: String?,
        tenantId: String?,
        autoRetrievalInfo: AutoRetrievalInfo?,
        safetyNetToken: String?,
        playIntegrityToken: String?,
        captchaResponse: String?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?,
        locale: String?
    ) -> EventLoopFuture<SendVerificationCodeResponse> {
        let sendVerificationRequest = SendVerificationCodeRequest(
            phoneNumber: phoneNumber,
            iosReceipt: iosReceipt,
            iosSecret: iosSecret,
            recaptchaToken: recaptchaToken,
            tenantId: tenantId,
            autoRetrievalInfo: autoRetrievalInfo,
            safetyNetToken: safetyNetToken,
            playIntegrityToken: playIntegrityToken,
            captchaResponse: captchaResponse,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion
        )
        
        var headers: HTTPHeaders = [:]
        if let locale = locale {
            headers.add(name: "X-Firebase-Locale", value: locale)
        }

        do {
            let body = try HTTPClient.Body.data(encoder.encode(sendVerificationRequest))
            return request.send(
                method: .POST,
                headers: headers,
                path: "\(endpoint)/v1/accounts:sendVerificationCode?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func sendOobCode(
        requestType: OobReqType,
        email: String?,
        captchaResp: String?,
        userIp: String?,
        newEmail: String?,
        idToken: String?,
        continueUrl: String?,
        iOSBundleId: String?,
        iOSAppStoreId: String?,
        androidPackageName: String?,
        androidInstallApp: Bool?,
        androidMinimumVersion: String?,
        canHandleCodeInApp: Bool?,
        tenantId: String?,
        targetProjectId: String?,
        dynamicLinkDomain: String?,
        returnOobLink: Bool?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?
    ) -> EventLoopFuture<SendOobCodeResponse> {
        let sendOobCodeRequest = SendOobCodeRequest(
            requestType: requestType,
            email: email,
            captchaResp: captchaResp,
            userIp: userIp,
            newEmail: newEmail,
            idToken: idToken,
            continueUrl: continueUrl,
            iOSBundleId: iOSBundleId,
            iOSAppStoreId: iOSAppStoreId,
            androidPackageName: androidPackageName,
            androidInstallApp: androidInstallApp,
            androidMinimumVersion: androidMinimumVersion,
            canHandleCodeInApp: canHandleCodeInApp,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            dynamicLinkDomain: dynamicLinkDomain,
            returnOobLink: returnOobLink,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(sendOobCodeRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:sendOobCode?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func createAuthUri(
        identifier: String?,
        continueUri: String?,
        providerId: String?,
        oauthScope: String?,
        context: String?,
        hostedDomain: String?,
        sessionId: String?,
        authFlowType: String?,
        customParameter: [String: String]?,
        tenantId: String?
    ) -> EventLoopFuture<CreateAuthUriResponse> {
        let createAuthUriRequest = CreateAuthUriRequest(
            identifier: identifier,
            continueUri: continueUri,
            providerId: providerId,
            oauthScope: oauthScope,
            context: context,
            hostedDomain: hostedDomain,
            sessionId: sessionId,
            authFlowType: authFlowType,
            customParameter: customParameter,
            tenantId: tenantId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(createAuthUriRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:createAuthUri?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func deleteAccount(
        localId: String?,
        idToken: String?,
        tenantId: String?,
        targetProjectId: String?
    ) -> EventLoopFuture<DeleteAccountResponse> {
        let deleteAccountRequest = DeleteAccountRequest(
            localId: localId,
            idToken: idToken,
            tenantId: tenantId,
            targetProjectId: targetProjectId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(deleteAccountRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:delete?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func issueSamlResponse(
        rpId: String,
        idToken: String,
        samlAppEntityId: String?
    ) -> EventLoopFuture<IssueSamlResponseResponse> {
        let issueSamlRequest = IssueSamlResponseRequest(
            rpId: rpId,
            idToken: idToken,
            samlAppEntityId: samlAppEntityId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(issueSamlRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:issueSamlResponse?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func lookup(
        idToken: String?,
        localId: [String]?,
        email: [String]?,
        phoneNumber: [String]?,
        federatedUserId: [FederatedUserIdentifier]?,
        tenantId: String?,
        targetProjectId: String?,
        initialEmail: [String]?
    ) -> EventLoopFuture<LookupAccountResponse> {
        let lookupRequest = LookupAccountRequest(
            idToken: idToken,
            localId: localId,
            email: email,
            phoneNumber: phoneNumber,
            federatedUserId: federatedUserId,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            initialEmail: initialEmail
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(lookupRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:lookup?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func resetPassword(
        oobCode: String?,
        newPassword: String?,
        oldPassword: String?,
        email: String?,
        tenantId: String?
    ) -> EventLoopFuture<ResetPasswordResponse> {
        let resetPasswordRequest = ResetPasswordRequest(
            oobCode: oobCode,
            newPassword: newPassword,
            oldPassword: oldPassword,
            email: email,
            tenantId: tenantId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(resetPasswordRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:resetPassword?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func signInWithCustomToken(
        token: String,
        returnSecureToken: Bool,
        tenantId: String?
    ) -> EventLoopFuture<SignInWithCustomTokenResponse> {
        let signInRequest = SignInWithCustomTokenRequest(
            token: token,
            returnSecureToken: returnSecureToken,
            tenantId: tenantId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(signInRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:signInWithCustomToken?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func signInWithEmailLink(
        oobCode: String,
        email: String,
        idToken: String?,
        tenantId: String?
    ) -> EventLoopFuture<SignInWithEmailLinkResponse> {
        let signInRequest = SignInWithEmailLinkRequest(
            oobCode: oobCode,
            email: email,
            idToken: idToken,
            tenantId: tenantId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(signInRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:signInWithEmailLink?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func signInWithGameCenter(
        playerId: String,
        publicKeyUrl: String,
        signature: String,
        salt: String,
        timestamp: String,
        idToken: String?,
        displayName: String?,
        tenantId: String?,
        teamPlayerId: String?,
        gamePlayerId: String?,
        bundleId: String
    ) -> EventLoopFuture<SignInWithGameCenterResponse> {
        let signInRequest = SignInWithGameCenterRequest(
            playerId: playerId,
            publicKeyUrl: publicKeyUrl,
            signature: signature,
            salt: salt,
            timestamp: timestamp,
            idToken: idToken,
            displayName: displayName,
            tenantId: tenantId,
            teamPlayerId: teamPlayerId,
            gamePlayerId: gamePlayerId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(signInRequest))
            var headers = HTTPHeaders()
            headers.add(name: "x-ios-bundle-identifier", value: bundleId)
            
            return request.send(
                method: .POST,
                headers: headers,
                path: "\(endpoint)/v1/accounts:signInWithGameCenter?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func signInWithIdp(
        requestUri: String,
        postBody: String,
        returnRefreshToken: Bool?,
        sessionId: String?,
        idToken: String?,
        returnSecureToken: Bool?,
        returnIdpCredential: Bool?,
        tenantId: String?,
        pendingToken: String?
    ) -> EventLoopFuture<SignInWithIdpResponse> {
        let signInRequest = SignInWithIdpRequest(
            requestUri: requestUri,
            postBody: postBody,
            returnRefreshToken: returnRefreshToken,
            sessionId: sessionId,
            idToken: idToken,
            returnSecureToken: returnSecureToken,
            returnIdpCredential: returnIdpCredential,
            tenantId: tenantId,
            pendingToken: pendingToken
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(signInRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:signInWithIdp?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func signInWithPassword(
        email: String,
        password: String,
        captchaResponse: String?,
        returnSecureToken: Bool?,
        tenantId: String?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?
    ) -> EventLoopFuture<SignInWithPasswordResponse> {
        let signInRequest = SignInWithPasswordRequest(
            email: email,
            password: password,
            captchaResponse: captchaResponse,
            returnSecureToken: returnSecureToken,
            tenantId: tenantId,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(signInRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:signInWithPassword?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func signInWithPhoneNumber(
        sessionInfo: String?,
        phoneNumber: String?,
        code: String?,
        temporaryProof: String?,
        idToken: String?,
        tenantId: String?,
        locale: String?
    ) -> EventLoopFuture<SignInWithPhoneNumberResponse> {
        let signInRequest = SignInWithPhoneNumberRequest(
            sessionInfo: sessionInfo,
            phoneNumber: phoneNumber,
            code: code,
            temporaryProof: temporaryProof,
            idToken: idToken,
            tenantId: tenantId
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(signInRequest))
            
            // Add locale header if provided
            var headers: HTTPHeaders = [:]
            if let locale = locale {
                headers.add(name: "X-Firebase-Locale", value: locale)
            }
            
            return request.send(
                method: .POST,
                headers: headers,
                path: "\(endpoint)/v1/accounts:signInWithPhoneNumber?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func signUp(
        email: String?,
        password: String?,
        displayName: String?,
        captchaResponse: String?,
        idToken: String?,
        emailVerified: Bool?,
        photoUrl: String?,
        disabled: Bool?,
        localId: String?,
        phoneNumber: String?,
        tenantId: String?,
        targetProjectId: String?,
        mfaInfo: [MfaFactor]?,
        clientType: ClientType?,
        recaptchaVersion: RecaptchaVersion?
    ) -> EventLoopFuture<SignUpResponse> {
        let signUpRequest = SignUpRequest(
            email: email,
            password: password,
            displayName: displayName,
            captchaResponse: captchaResponse,
            idToken: idToken,
            emailVerified: emailVerified,
            photoUrl: photoUrl,
            disabled: disabled,
            localId: localId,
            phoneNumber: phoneNumber,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            mfaInfo: mfaInfo,
            clientType: clientType,
            recaptchaVersion: recaptchaVersion
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(signUpRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:signUp?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func update(
        idToken: String?,
        localId: String?,
        displayName: String?,
        email: String?,
        password: String?,
        provider: [String]?,
        oobCode: String?,
        emailVerified: Bool?,
        upgradeToFederatedLogin: Bool?,
        captchaResponse: String?,
        validSince: String?,
        disableUser: Bool?,
        photoUrl: String?,
        deleteAttribute: [UserAttributeName]?,
        returnSecureToken: Bool?,
        deleteProvider: [String]?,
        lastLoginAt: String?,
        createdAt: String?,
        phoneNumber: String?,
        customAttributes: String?,
        tenantId: String?,
        targetProjectId: String?,
        mfa: MfaInfo?,
        linkProviderUserInfo: ProviderUserInfo?
    ) -> EventLoopFuture<UpdateAccountResponse> {
        let updateRequest = UpdateAccountRequest(
            idToken: idToken,
            localId: localId,
            displayName: displayName,
            email: email,
            password: password,
            provider: provider,
            oobCode: oobCode,
            emailVerified: emailVerified,
            upgradeToFederatedLogin: upgradeToFederatedLogin,
            captchaResponse: captchaResponse,
            validSince: validSince,
            disableUser: disableUser,
            photoUrl: photoUrl,
            deleteAttribute: deleteAttribute,
            returnSecureToken: returnSecureToken,
            deleteProvider: deleteProvider,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            phoneNumber: phoneNumber,
            customAttributes: customAttributes,
            tenantId: tenantId,
            targetProjectId: targetProjectId,
            mfa: mfa,
            linkProviderUserInfo: linkProviderUserInfo
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(updateRequest))
            return request.send(
                method: .POST,
                path: "\(endpoint)/v1/accounts:update?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }

    public func verifyIosClient(
        appToken: String,
        isSandbox: Bool,
        bundleId: String
    ) -> EventLoopFuture<VerifyIosClientResponse> {
        let verifyRequest = VerifyIosClientRequest(
            appToken: appToken,
            isSandbox: isSandbox
        )

        do {
            let body = try HTTPClient.Body.data(encoder.encode(verifyRequest))
            var headers = HTTPHeaders()
            headers.add(name: "x-ios-bundle-identifier", value: bundleId)
            
            return request.send(
                method: .POST,
                headers: headers,
                path: "\(endpoint)/v1/accounts:verifyIosClient?key=\(apiKey)",
                body: body
            )
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
} 
