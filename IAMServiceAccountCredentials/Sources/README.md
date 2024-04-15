# Google Cloud IAM Service Account Credentials

## Using the IAM Service Account Credentials API

### Setting up IAMServiceAccountCredentialsConfiguration

To make GoogleCloudKit as flexible as possible to work with different API's and projects,
you can configure each API with their own configuration if the default `GoogleCloudCredentialsConfiguration` doesn't satisfy your needs.

For example the `GoogleCloudCredentialsConfiguration` can be configured with a `ProjectID`, but you might
want to use this specific API with a different project than other APIs. Additionally every API has their own scope and you might want to configure.
To use the IAM Service Account Credentials API you can create a `GoogleCloudIAMServiceAccountCredentialsConfiguration` in one of 2 ways.

```swift
let credentialsConfiguration = GoogleCloudCredentialsConfiguration(project: "my-project-1",
                                                                   credentialsFile: "/path/to/service-account.json")

let iamServiceAccountCredentialsConfiguration = IAMServiceAccountCredentialsConfiguration(scope: [.cloudPlatform],
                                                                serviceAccount: "default",
                                                                project: "my-project-2")
// OR
let iamServiceAccountCredentialsConfiguration = IAMServiceAccountCredentialsConfiguration.default() 
// has full control access and uses default service account with no project specified.
```

### Now create an `IAMServiceAccountCredentialsClient` with the configuration and an `HTTPClient`
```swift
let let client = HTTPClient(...)
let smc = try IAMServiceAccountCredentialsClient(credentials: credentialsConfiguration,
                                       config: iamServiceAccountCredentialsConfiguration,
                                       httpClient: client,
                                       eventLoop: myEventLoop)

```
The order of priority for which configured projectID the IAMServiceAccountCredentialsClient will use is as follows:
1. `$GOOGLE_PROJECT_ID` environment variable.
1. `$PROJECT_ID` environment variable.
2. The Service Accounts projectID (Service account configured via the credentials path in the credentials configuration).
3. `IAMServiceAccountCredentialsConfiguration`'s `project` property.
4. `GoogleCloudCredentialsConfiguration`'s `project` property.

Initializing the client will throw an error if no projectID is set anywhere.

### Signing a JWT

```swift
func signJWT() {
    let client = try IAMServiceAccountCredentialsClient(credentials: credentialsConfiguration,
                                           config: IAMServiceAccountCredentialsConfiguration,
                                           httpClient: client,
                                           eventLoop: myEventLoop)
                                           
    let payload: JWTPayload = MyPayload(name: "key", value: "value")

    client.api.signJWT(payload, serviceAccount: "my-service-account@my-domain.com").map { response in
        print(response.signedJwt) // Prints JWT signed with the given service account's credentials 
    }
}
```
### What's implemented

#### IAM Service Account Credentials API
* [x] signJWT
