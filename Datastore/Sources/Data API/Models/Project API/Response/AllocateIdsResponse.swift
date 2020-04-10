import Core

public struct AllocateIdsResponse: GoogleCloudModel {
    /// The keys specified in the request (in the same order), each with its key path completed with a newly allocated ID.
    public let keys: [Key]
}
