import Core
import Foundation

public struct SignInWithGameCenterResponse: GoogleCloudModel {
    /// The ID of the authenticated user
    public let localId: String
    /// The user's Game Center player ID
    public let playerId: String
    /// An Identity Platform ID token for the authenticated user
    public let idToken: String
    /// An Identity Platform refresh token for the authenticated user
    public let refreshToken: String
    /// The number of seconds until the ID token expires
    public let expiresIn: String
    /// Whether the logged in user was created by this request
    public let isNewUser: Bool
    /// Display name of the authenticated user
    public let displayName: String?
    /// The user's Game Center team player ID
    public let teamPlayerId: String?
    /// The user's Game Center game player ID
    public let gamePlayerId: String?
} 