# Google Cloud Translation

## Using the Translation API

### Setting up TranslationConfiguration

To make GoogleCloudKit as flexible as possible to work with different API's and projects,
you can configure each API with their own configuration if the default `GoogleCloudCredentialsConfiguration` doesn't satisfy your needs.

For example the `GoogleCloudCredentialsConfiguration` can be configured with a `ProjectID`, but you might
want to use this specific API with a different project than other APIs. Additionally every API has their own scope and you might want to configure.
To use the Translation API you can create a `GoogleCloudTranslationConfiguration` in one of 2 ways.

```swift
let credentialsConfiguration = GoogleCloudCredentialsConfiguration(project: "my-project-1",
                                                                   credentialsFile: "/path/to/service-account.json")

let translationConfiguration = GoogleCloudTranslationConfiguration(scope: [.cloudPlatform],
                                                                serviceAccount: "default",
                                                                project: "my-project-2")
// OR
let translationConfiguration = GoogleCloudTranslationConfiguration() 
// has full control access and uses default service account with no project specified.
```

### Now create a `GoogleCloudTranslationClient` with the configuration and an `HTTPClient`
```swift
let let client = HTTPClient(...)
let gct = try GoogleCloudTranslationClient(credentials: credentialsConfiguration,
                                           config: translationConfiguration,
                                           httpClient: client,
                                           eventLoop: myEventLoop)

```
The order of priority for which configured projectID the TranslationClient will use is as follows:
1. `$GOOGLE_PROJECT_ID` environment variable.
1. `$PROJECT_ID` environment variable.
2. The Service Accounts projectID (Service account configured via the credentials path in the credentials configuration).
3. `GoogleCloudTranslationConfiguration`'s `project` property.
4. `GoogleCloudCredentialsConfiguration`'s `project` property.

Initializing the client will throw an error if no projectID is set anywhere.

### Translating text

```swift
func translateText() {
	let gct = try GoogleCloudTranslationClient(credentials: credentialsConfiguration,
	                                           config: translationConfiguration,
	                                           httpClient: client,
	                                           eventLoop: myEventLoop)
	                                           
	let sampleText = "Hello world"
	let translation = gct.translation.translate(text: sampleText, source: "en", target: "es")

    translation.map { response in
        print(response.data.translations.first!.translatedText) // Prints spanish translation
    }
}

func translateTextDetectingSourceLanguage() {
	let gct = try GoogleCloudTranslationClient(credentials: credentialsConfiguration,
	                                           config: translationConfiguration,
	                                           httpClient: client,
	                                           eventLoop: myEventLoop)
	                                           
	let sampleText = "Hello world"
	let translation = gct.translation.translate(text: sampleText, target: "es")

    translation.map { response in
        print(response.data.translations.first!.translatedText) // Prints spanish translation
    }
}
```
### What's implemented

#### Translation API
* [x] translate plain text
* [x] detect source language
