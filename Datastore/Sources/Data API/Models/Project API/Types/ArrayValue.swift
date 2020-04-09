import Core
import Foundation

/// An array value.
public struct ArrayValue: GoogleCloudModel {
    
    /// Values in the array. The order of this array may not be preserved if it contains a mix of indexed and unindexed values.
    public let values: [Value]
    
    public init(values: [Value]) {
        self.values = values
    }
}
