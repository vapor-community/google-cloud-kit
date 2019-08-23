# Google Cloud Storage

## Using the Storage API

### Setting up StorageConfiguration

To make GoogleCloudKit as flexible as possible to work with different API's and projects,
you can configure each API with their own configuration if the default `GoogleCloudCredentialsConfiguration` doesn't satisfy your needs.

For example the `GoogleCloudCredentialsConfiguration` can be configured with a `ProjectID`, but you might
want to use this specific API with a different project than other APIs. Additionally every API has their own scope and you might want to configure.
To use the CloudStorage API you can create a `GoogleCloudStorageConfiguration` in one of 2 ways.

```swift
let credentialsConfiguration = GoogleCloudCredentialsConfiguration(project: "my-project-1",
                                                                   credentialsFile: "~/path/to/service-account.json")

let cloudStorageConfiguration = GoogleCloudStorageConfiguration(scope: [.fullControl, .cloudPlatformReadOnly],
                                                                serviceAccount: "default",
                                                                project: "my-project-2")
// OR
let cloudStorageConfiguration = GoogleCloudStorageConfig.default() 
// has full control access and uses default service account with no project specified.
```

### Now create a `GoogleCloudStorageClient` with the configuration.
```swift
let gcs = try GoogleCloudStorageClient(configuration: credentialsConfiguration,
                                       storageConfiguration: cloudStorageConfiguration,
                                       eventLoop: myEventLoop)

```
The order of priority for which configured projectID the StorageClient will use is as follows:
1. `$PROJECT_ID` environment variable.
2. The Service Accounts projectID (Service account configured via the credentials path in the credentials configuration).
3. `GoogleCloudStorageConfiguration`'s `project` property.
4. `GoogleCloudCredentialsConfiguration`'s `project` property.

Initializing the client will throw an error if no projectID is set anywhere.

### Creating a storage bucket

```swift
func createBucket() {
    let gcs = try GoogleCloudStorageClient(configuration: credentialsConfiguration,
                                           storageConfiguration: cloudStorageConfiguration,
                                           eventLoop: myEventLoop)

    gcs.buckets.insert(name: "nio-cloud-storage-demo").flatMap { newBucket in
        print(newBucket.selfLink) // prints "https://www.googleapis.com/storage/v1/b/nio-cloud-storage-demo"
    }
}
```

### Uploading an object to cloud storage

```swift
func uploadImage(data: Data) {
    let gcs = try GoogleCloudStorageClient(configuration: credentialsConfiguration,
                                           storageConfiguration: cloudStorageConfiguration)

    gcs.object.createSimpleUpload(bucket: "nio-cloud-storage-demo",
                                  data: data,
                                  name: "SwiftBird",
                                  contentType: "image/jpeg").flatMap { uploadedObject in
        print(uploadedObject.mediaLink) // prints the download link for the image.
    }
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
