import Core
import Foundation

/// An object representing a latitude/longitude pair. This is expressed as a pair of doubles representing degrees latitude and degrees longitude. Unless specified otherwise, this must conform to the WGS84 standard. Values must be within normalized ranges.
public struct LatLng: GoogleCloudModel {
    
    /// The latitude in degrees. It must be in the range [-90.0, +90.0].
    public let latitude: Double
    /// The longitude in degrees. It must be in the range [-180.0, +180.0].
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
