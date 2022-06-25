//
//  IAMPolicy.swift
//  GoogleCloudKit
//
//  Created by Andrew Edwards on 4/20/18.
//

import Core

public struct IAMPolicy: Codable {
    /// The kind of item this is. For policies, this is always storage#policy. This field is ignored on input.
    public var kind: String?
    /// The ID of the resource to which this policy belongs.
    public var resourceId: String?
    /// An association between a role, which comes with a set of permissions, and members who may assume that role.
    public var bindings: [Binding]?
    /// HTTP 1.1 Entity tag for the policy.
    public var etag: String?
    
    public init(kind: String? = nil,
                resourceId: String? = nil,
                bindings: [Binding]? = nil,
                etag: String? = nil) {
        self.kind = kind
        self.resourceId = resourceId
        self.bindings = bindings
        self.etag = etag
    }
}

public struct Binding: Codable {
    /// The role to which members belong.
    public var role: String?
    /// A collection of identifiers for members who may assume the provided role.
    public var members: [String]?
    /// Any value
    public var condition: String?
    
    public init(role: String? = nil,
                members: [String]? = nil,
                condition: String? = nil) {
        self.role = role
        self.members = members
        self.condition = condition
    }
}

public struct Permission: Codable {
    /// The kind of item this is.
    public var kind: String?
    /// The permissions held by the caller. 
    public var permissions: [String]?
}
