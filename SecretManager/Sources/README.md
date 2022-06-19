# Google Cloud Secret Manager

## Using the Secret Manager API

### Setting up SecretManagerConfiguration

To make GoogleCloudKit as flexible as possible to work with different API's and projects,
you can configure each API with their own configuration if the default `GoogleCloudCredentialsConfiguration` doesn't satisfy your needs.

For example the `GoogleCloudCredentialsConfiguration` can be configured with a `ProjectID`, but you might
want to use this specific API with a different project than other APIs. Additionally every API has their own scope and you might want to configure.
To use the Secret Manager API you can create a `GoogleCloudSecretManagerConfiguration` in one of 2 ways.

```swift
let credentialsConfiguration = GoogleCloudCredentialsConfiguration(project: "my-project-1",
                                                                   credentialsFile: "/path/to/service-account.json")

let secretManagerConfiguration = GoogleCloudSecretManagerConfiguration(scope: [.cloudPlatform],
                                                                serviceAccount: "default",
                                                                project: "my-project-2")
// OR
let secretManagerConfiguration = GoogleCloudSecretManagerConfig.default() 
// has full control access and uses default service account with no project specified.
```

### Now create a `GoogleCloudSecretManagerClient` with the configuration and an `HTTPClient`
```swift
let let client = HTTPClient(...)
let smc = try GoogleCloudSecretManagerClient(credentials: credentialsConfiguration,
                                       config: secretManagerConfiguration,
                                       httpClient: client,
                                       eventLoop: myEventLoop)

```
The order of priority for which configured projectID the SecretManagerClient will use is as follows:
1. `$GOOGLE_PROJECT_ID` environment variable.
1. `$PROJECT_ID` environment variable.
2. The Service Accounts projectID (Service account configured via the credentials path in the credentials configuration).
3. `GoogleCloudSecretManagerConfiguration`'s `project` property.
4. `GoogleCloudCredentialsConfiguration`'s `project` property.

Initializing the client will throw an error if no projectID is set anywhere.

### Accessing a secret version

```swift
func accessSecretVersion() {
    let secretManager = try GoogleCloudSecretManagerClient(credentials: credentialsConfiguration,
                                           config: secretManagerConfiguration,
                                           httpClient: client,
                                           eventLoop: myEventLoop)

    secretManager.secrets.access("my-secret-name", version: "latest").map { response in
        print(response.payload.decodedData!) // Prints base64-decoded value of secret
    }
}
```
### What's implemented

#### Secret Versions API
* [x] access
