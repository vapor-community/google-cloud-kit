import Core

/// A message that can hold any of the supported value types and associated metadata.
public struct Value: GoogleCloudModel {
    
    public enum TypedValue {
        case array(ArrayValue)
        case blob(String)
        case boolean(Bool)
        case double(Double)
        case entity(Entity)
        case geoPoint(LatLng)
        case integer(String)
        case key(Key)
        case null(String)
        case string(String)
        case timestamp(String)
    }
    
    /// An array value. Cannot contain another array value. A Value instance that sets field arrayValue must not set fields meaning or excludeFromIndexes.
    public let arrayValue: ArrayValue?
    /// A blob value. May have at most 1,000,000 bytes. When excludeFromIndexes is false, may have at most 1500 bytes. In JSON requests, must be base64-encoded.
    public let blobValue: String?
    /// A boolean value.
    public let booleanValue: Bool?
    /// A double value.
    public let doubleValue: Double?
    /// An entity value.
    /// - May have no key.
    /// - May have a key with an incomplete key path.
    /// - May have a reserved/read-only key.
    public let entityValue: Entity?
    /// If the value should be excluded from all indexes including those defined explicitly.
    public let excludeFromIndexes: Bool?
    /// A geo point value representing a point on the surface of Earth.
    public let geoPointValue: LatLng?
    /// An integer value.
    public let integerValue: String?
    /// A key value.
    public let keyValue: Key?
    /// The meaning field should only be populated for backwards compatibility.
    public let meaning: Int?
    /// A null value.
    public let nullValue: String?
    /// A UTF-8 encoded string value. When excludeFromIndexes is false (it is indexed) , may have at most 1500 bytes. Otherwise, may be set to at least 1,000,000 bytes.
    public let stringValue: String?
    /// A timestamp value. When stored in the Datastore, precise only to microseconds; any additional precision is rounded down.
    /// A timestamp in RFC3339 UTC "Zulu" format, accurate to nanoseconds. Example: "2014-10-02T15:01:23.045123456Z".
    public let timestampValue: String?
    
    public init(_ typedValue: TypedValue, excludeFromIndexes: Bool? = nil, meaning: Int? = nil) {
        switch typedValue {
        case .array(let value):
            self.init(arrayValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .blob(let value):
            self.init(blobValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .boolean(let value):
            self.init(booleanValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .double(let value):
            self.init(doubleValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .entity(let value):
            self.init(entityValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .geoPoint(let value):
            self.init(geoPointValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .integer(let value):
            self.init(integerValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .key(let value):
            self.init(keyValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .null(let value):
            self.init(nullValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .string(let value):
            self.init(stringValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        case .timestamp(let value):
            self.init(timestampValue: value, excludeFromIndexes: excludeFromIndexes, meaning: meaning); return
        }
    }
    
    init(arrayValue: ArrayValue? = nil,
         blobValue: String? = nil,
         booleanValue: Bool? = nil,
         doubleValue: Double? = nil,
         entityValue: Entity? = nil,
         geoPointValue: LatLng? = nil,
         integerValue: String? = nil,
         keyValue: Key? = nil,
         nullValue: String? = nil,
         stringValue: String? = nil,
         timestampValue: String? = nil,
         excludeFromIndexes: Bool? = nil,
         meaning: Int? = nil) {
        self.arrayValue = arrayValue
        self.blobValue = blobValue
        self.booleanValue = booleanValue
        self.doubleValue = doubleValue
        self.entityValue = entityValue
        self.excludeFromIndexes = excludeFromIndexes
        self.geoPointValue = geoPointValue
        self.integerValue = integerValue
        self.keyValue = keyValue
        self.meaning = meaning
        self.nullValue = nullValue
        self.stringValue = stringValue
        self.timestampValue = timestampValue
    }
}
