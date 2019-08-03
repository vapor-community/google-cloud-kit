# Google Cloud Storage

## Using the Storage API

### Setting up StorageConfig

To make the GoogleCloudProvider as flexible as possible to work with different API's and projects,
you can configure each API with their own configuration if the default `GoogleCloudProviderConfig` doesn't satisfy your needs.

For example the `GoogleCloudProviderConfig` can be configured with a `ProjectID`, but you might
want to use this API with a different project. Additionally every API has their own scope and you might want to configure it.
You must register a `GoogleCloudStorageConfig` in one of 2 ways.

In `configure.swift`
```swift
let cloudStorageConfig = GoogleCloudStorageConfig(scope: [StorageScope.fullControl], serviceAccount: "default", project: "myproject-000000")
services.register(cloudStorageConfig)
// OR
services.register(GoogleCloudStorageConfig.default())
```
The priority of which projectID to use is as follows:
`$PROJECT_ID` environment variable
Service Account projectID
`GoogleCloudStorageConfig`'s `.project` (the config for this API)
`GoogleCloudProviderConfig`'s `.project`
and will throw an error if no projectID is set. 

### Creating a storage bucket

```swift
func create(_ req: Request) throws -> Future<GoogleStorageBucket> {
    let cloudStorage = try req.make(GoogleCloudStorageClient.self)

    return try cloudStorage.buckets.create(name: "vapor-cloud-storage-demo")
}
```

```json
// Results in the following response
{
    "updated": "2018-05-27T20:21:19Z",
    "selfLink": "https://www.googleapis.com/storage/v1/b/vapor-cloud-storage-demo",
    "projectNumber": "0000000011",
    "id": "vapor-cloud-storage-demo",
    "location": "US",
    "storageClass": "STANDARD",
    "metageneration": "1",
    "kind": "storage#bucket",
    "timeCreated": "2018-05-27T20:21:19Z",
    "name": "vapor-cloud-storage-demo",
    "etag": "CAE="
}
```

### Uploading an object to cloud storage

```swift
func upload(_ req: Request) throws -> Future<GoogleStorageObject> {
    let cloudStorage = try req.make(GoogleCloudStorageClient.self)

    return try cloudStorage.object.createSimpleUpload(bucket: "vapor-cloud-storage-demo",
                                                      data: Data(imagedata),
                                                      name: "hello",
                                                      mediaType: .jpeg)
}
```

There are other API's available which are well [documented](https://cloud.google.com/storage/docs/json_api/v1/).
This is just a basic example of creating a bucket and uploading an object.

### What's implemented

* [x] BucketAccessControls
* [x] Buckets
* [x] Channels
* [x] DefaultObjectAccessControls
* [x] Notifications
* [x] ObjectAccessControls
* [x] Simple Object upload
* [ ] Multipart Object upload
* [ ] Resumable Object upload
