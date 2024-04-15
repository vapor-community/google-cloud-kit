# GoogleCloudKit

![Swift](http://img.shields.io/badge/swift-5.2-brightgreen.svg)
![NIO](http://img.shields.io/badge/NIO-2.0-brightgreen.svg)

## This project aims to bring over as many [Google Cloud Platform APIs](https://cloud.google.com/products/) as possible to server side swift projects built on top of Swift NIO.

### Because the products and API's are so vast this will start slowly and over time add more API's as time goes on.

## Quickstart

### Before you begin note that this package only supports using Service accounts to authenticate to the various Google Cloud Platform APIs using OAuth2.

1. Select or create a Cloud Platform project.

[Go to the projects page](https://console.cloud.google.com/project)

2. Enable billing for your project.

[Enable billing]( https://support.google.com/cloud/answer/6293499#enable-billing)

3. Enable the Google Cloud Storage API.

[Enable the API](https://console.cloud.google.com/flows/enableapi?apiid=storage-api.googleapis.com)

4. [Set up authentication with a service account](https://cloud.google.com/docs/authentication/getting-started) so you can access the
API from your local workstation.

### To begin using GogleCloudKit in your project you'll need to setup the initial configuration.

In your `Package.swift` file, add the following

```swift
.package(url: "https://github.com/vapor-community/google-cloud-kit.git", from: "1.0.0-alpha.1")
```
Now setup the configuration.

```swift
 import GoogleCloudKit
 
 let credentialsConfig = GoogleCloudCredentialsConfiguration(project: "myprojectid-12345", credentialsFile: "/path/to/service-account.json")
```

Optionally, you can register an empty `GoogleCloudCredentialsConfiguration()` and configure the following environment variables:

```shell
export GOOGLE_PROJECT_ID=myprojectid-12345
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/service-account.json
```

Additionally, you can copy and paste the contents of your Service Account JSON file as the value for the  `GOOGLE_APPLICATION_CREDENTIALS` environment variable:

```shell
export GOOGLE_APPLICATION_CREDENTIALS=[Valid Pasted JSON]
```

### Currently the following API's are implemented and you can follow the setup guides for each specific API to integrate with your project.
* [x] Cloud Storage [Setup guide](https://github.com/vapor-community/GoogleCloudKit/tree/master/Storage/Sources/README.md)
* [x] Datastore [Setup guide](https://github.com/vapor-community/GoogleCloudKit/tree/master/Datastore/Sources/README.md)
* [x] SecretManager [Setup Guide](https://github.com/vapor-community/google-cloud-kit/tree/master/SecretManager/Sources/README.md)
* [x] Translation [Setup Guide](https://github.com/vapor-community/google-cloud-kit/tree/master/Translation/Sources/README.md)
* [x] IAM Service Account Credentials [Setup Guide](https://github.com/vapor-community/google-cloud-kit/tree/master/IAMServiceAccountCredentials/Sources/README.md)
