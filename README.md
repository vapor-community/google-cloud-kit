# GoogleCloudProvider

![Swift](http://img.shields.io/badge/swift-4.1-brightgreen.svg)
![Vapor](http://img.shields.io/badge/vapor-3.0-brightgreen.svg)

## This project aims to bring over as many [Google Cloud Platform APIs](https://cloud.google.com/products/) as possible to Vapor projects.

### Because the products and API's are so vast this will start slowly and over time add more API's as time goes on.

## Quickstart

### Before you begin note that this package only supports using Service accounts to authenticate to the various Google Cloud Platform APIs using OAuth2.

1. Select or create a Cloud Platform project.

[Go to the projects page][projects]

2. Enable billing for your project.

[Enable billing][billing]

3. Enable the Google Cloud Storage API.

[Enable the API][enable_api]

4. [Set up authentication with a service account][auth] so you can access the
API from your local workstation.

[projects]: https://console.cloud.google.com/project
[billing]: https://support.google.com/cloud/answer/6293499#enable-billing
[enable_api]: https://console.cloud.google.com/flows/enableapi?apiid=storage-api.googleapis.com
[auth]: https://cloud.google.com/docs/authentication/getting-started

### To begin using GogleCloudProvider in your project you'll need to setup the initial configuration

In your `Package.swift` file, add the following

```swift
.package(url: "https://github.com/vapor-community/google-cloud-provider.git", from: "0.1.0")
```

And In `Configure.swift` or wherever you setup your configuration in Vapor

```swift
 import GoogleCloud
 
 let cloudConfig = GoogleCloudProviderConfig(project: "myprojectid-12345", credentialFile: "path to your service account json")
 services.register(cloudConfig)
 try services.register(GoogleCloudProvider())
```

Optionally, you can register an empty `GoogleCloudProviderConfig()` and configure the following environment variables:

```shell
export PROJECT_ID=myprojectid-12345
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/service-account.json
```

Additionally, you can copy and paste the contents of your Service Account JSON file as the value for the  `GOOGLE_APPLICATION_CREDENTIALS` environment variable:

```shell
export GOOGLE_APPLICATION_CREDENTIALS=[Valid Pasted JSON]
```

### Currently the following API's are implemented and you can follow the setup guides for each specific API to integrate with your Vapor project.
* [x] Cloud Storage [Setup guide](https://github.com/Andrewangeta/GoogleCloudProvider/tree/master/Sources/GoogleCloud/Storage/README.md)
