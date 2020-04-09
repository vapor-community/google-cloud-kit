# Google Cloud Datastore

## Using the Datastore API

### Setting up DatastoreConfiguration

To make GoogleCloudKit as flexible as possible to work with different API's and projects,
you can configure each API with their own configuration if the default `GoogleCloudCredentialsConfiguration` doesn't satisfy your needs.

For example the `GoogleCloudCredentialsConfiguration` can be configured with a `ProjectID`, but you might
want to use this specific API with a different project than other APIs. Additionally every API has their own scope and you might want to configure.
To use the Datastore API you can create a `GoogleCloudDatastoreConfiguration` in one of 2 ways.

```swift
let credentialsConfiguration = GoogleCloudCredentialsConfiguration(project: "my-project-1",
                                                                   credentialsFile: "~/path/to/service-account.json")

let clouddatastoreConfiguration = GoogleCloudDatastoreConfiguration(scope: [.fullControl, .cloudPlatformReadOnly],
                                                                serviceAccount: "default",
                                                                project: "my-project-2")
// OR
let datastoreConfiguration = GoogleCloudDatastoreConfig.default() 
// has full control access and uses default service account with no project specified.
```

### Now create a `GoogleCloudDatastoreClient` with the configuration and an `HTTPClient`
```swift
let let client = HTTPClient(...)
let gcs = try GoogleCloudDatastoreClient(credentials: credentialsConfiguration,
                                       config: datastoreConfiguration,
                                       httpClient: client,
                                       eventLoop: myEventLoop)

```
The order of priority for which configured projectID the DatastoreClient will use is as follows:
1. `$PROJECT_ID` environment variable.
2. The Service Accounts projectID (Service account configured via the credentials path in the credentials configuration).
3. `GoogleCloudDatastoreConfiguration`'s `project` property.
4. `GoogleCloudCredentialsConfiguration`'s `project` property.

Initializing the client will throw an error if no projectID is set anywhere.

### Adding a new entity

```swift
func createEntity() {
    let datastore = try GoogleCloudDatastoreClient(credentials: credentialsConfiguration,
                                           config: datastoreConfiguration,
                                           httpClient: client,
                                           eventLoop: myEventLoop)
   
   let pathElement = PathElement(.none, kind: "MyEntity")
   let partitionId = PartitionId(projectId: "my-project")
   let key = Key(partitionId: partitionId, path: [pathElement])
                                           
   let properties: [String: Value] = ["myKey": Value(.string("myValue"))]
   let entity = Entity(key: key, properties: properties)
   let insert = CommitRequest.Mutation(.insert(entity))

    datastore.project.commit(mode: .transactional, mutations: [insert], transactionId: "myTransactionId").map { response in
        print(response.indexUpdates) // prints 1
    }
}
```

### Looking up an entity

```swift
func lookupObject(name: String) {
    let datastore = try GoogleCloudDatastoreClient(credentials: credentialsConfiguration,
                                           config: datastoreConfiguration,
                                           httpClient: client,
                                           eventLoop: myEventLoop)

    let pathElement = PathElement(.name(name), kind: "MyEntity")
    let partitionId = PartitionId(projectId: "my-project")
    let key = Key(partitionId: partitionId, path: [pathElement])

    datastore.project.lookup(keys: [key]).map { response in
        print(response.found.count) // prints 1 if entity exists
    }
}
```

There are other API's available which are well [documented](https://cloud.google.com/datastore/docs/reference/data/rest).
This is just a basic example of creating then looking up an entity.

### What's implemented

#### Data API
* [x] projects
* [ ] projects.operations

#### Admin API
* [ ] projects
* [ ] projects.indexes
* [ ] projects.operations
