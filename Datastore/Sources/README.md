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
                                                                   credentialsFile: "/path/to/service-account.json")

let clouddatastoreConfiguration = GoogleCloudDatastoreConfiguration(scope: [.datastore],
                                                                serviceAccount: "default",
                                                                project: "my-project-2")
// OR
let datastoreConfiguration = GoogleCloudDatastoreConfig.default() 
// has full control access and uses default service account with no project specified.
```

### Now create a `GoogleCloudDatastoreClient` with the configuration and an `HTTPClient`
```swift
let client = HTTPClient(...)
let datastore = try GoogleCloudDatastoreClient(credentials: credentialsConfiguration,
                                       config: datastoreConfiguration,
                                       httpClient: client,
                                       eventLoop: myEventLoop)

```
The order of priority for which configured projectID the DatastoreClient will use is as follows:
1. `$GOOGLE_PROJECT_ID` environment variable.
1. `$PROJECT_ID` environment variable.
2. The Service Accounts projectID (Service account configured via the credentials path in the credentials configuration).
3. `GoogleCloudDatastoreConfiguration`'s `project` property.
4. `GoogleCloudCredentialsConfiguration`'s `project` property.

Initializing the client will throw an error if no projectID is set anywhere.

## Managing Entities

### Add a new entity

```swift
let pathElement = PathElement(.none, kind: "MyEntity")
let partitionId = PartitionId(projectId: "my-project")
let key = Key(partitionId: partitionId, path: [pathElement])
                                       
let properties: [String: Value] = ["myKey": Value(.string("myValue"))]
let entity = Entity(key: key, properties: properties)

datastore.project.insert(entity).map { response in
    print(response.indexUpdates) // prints 1
}
```

### Look up an entity

```swift
let pathElement = PathElement(.name("element-id"), kind: "MyEntity")
let partitionId = PartitionId(projectId: "my-project")
let key = Key(partitionId: partitionId, path: [pathElement])

datastore.project.lookup(keys: [key]).map { response in
    print(response.found.count) // prints 1 if entity exists
}
```

## Queries

### Run query

```swift
let filter = PropertyFilter(
    property: "myProperty",
    stringValue: "myValue"
)

let query = Query(
    filter: .property(filter),
    kind: [KindExpression("MyEntity")]
)

let partitionId = PartitionId(projectId: "my-project")
                
let response = try await datastore.project.runQuery(
    datastoreQuery: .query(query),
    partitionId: partitionId
).get()

// prints results
print(response.batch.entityResults)
```

### Run query with GQL
```swift
// This query is equivalent to the one in the previous example but uses GQL                                        
let query = GqlQuery(
    allowLiterals: true,
    namedBindings: nil,
    positionalBindings: nil,
    queryString: "SELECT * FROM MyEntity WHERE myProperty = \"myValue\""
)

let partitionId = PartitionId(projectId: "my-project")

let response = try await req.gcDatastore.project.runQuery(
    partitionId: partitionId,
    datastoreQuery: .gqlQuery(query)
).get()

// prints results
print(response.batch?.entityResults)
```

## Aggregation Queries

### Run aggregation query

```swift
let filter = PropertyFilter(
    property: "myProperty",
    stringValue: "myValue"
)

let query = Query(
    filter: .property(filter),
    kind: [KindExpression("MyEntity")]
)

let partitionId = PartitionId(projectId: "my-project")
                
let response = try await datastore.project.runAggregationQuery(
    query: query,
    aggregations: [.count()],
    partitionId: partitionId
).get()

// prints count
print(response.batch.aggregationResults.first.aggregateProperties.values.first.integerValue)
```

### Run aggregation query with GQL

```swift    
// This query is equivalent to the one in the previous example but uses GQL                                        
let gqlQuery = GqlQuery(
    allowLiterals: true,
    queryString: "AGGREGATE COUNT(*) OVER ( SELECT * FROM MyEntity WHERE myProperty = \"myValue\" )"
)

let partitionId = PartitionId(projectId: "my-project")

let response = try await datastore.project.runAggregationQuery(
    gqlQuery: gqlQuery,
    partitionId: partitionId
).get()
```

There are other APIs available which are well [documented](https://cloud.google.com/datastore/docs/reference/data/rest).

## What's implemented

### Data API
* [x] projects
* [ ] projects.operations

### Admin API
* [ ] projects
* [ ] projects.indexes
* [ ] projects.operations
