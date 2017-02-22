# Cordova Skeleton

An opinionated skeleton for Cordova apps.


## App Dependencies

Dependency management is handled by Bower; to install dependencies:

    bower install


## Compiling App Assets

Use Grunt to compile the app's assets. Install Grunt locally to the project as follows, you should have `grunt-cli` installed globally:

    npm install

Start the Grunt watcher simply by issuing:

    grunt


## Compiling for Devices

The app should always be compiled using the bundled `build.sh` script. This script will ensure that the app is built correctly and cleanly.

    build.sh <platform> <environment> <version>

- Platform can be one of: `ios` or `android`
- Environment can be one of: `prod`, `stage` or `dev`
- A version number is required if building for: `prod` or `stage`


## Installing on Devices

### iOS

To install on an iOS devices, perform the following:


1. Open the Xcode project (located at `dist/platforms/ios/*.xcodeproj`)
2. Use Xcode to deploy to a local device

To distribute to testers, perform the following:

1. Open the Xcode project (located at `dist/platforms/ios/*.xcodeproj`)
2. Archive the project
3. Submit to Apple
4. In iTunes connect send invite to testers


### Android

To install on Android devices, perform the following:

1. Connect device, ensure it is USB debugging mode.
2. Use the Android SDK to compile the device onto the device.

To distribute to testers, perform the following:

1. Distribute the APK which is available at `dist/platforms/android/build/outputs/apk/` to users


## Distributing

### iOS

1. If necessary, create a new release using `git flow`
2. Compile the app `./build ios <environment> <version>`
3. Open up Xcode
4. Set the build number appropriately for the version
5. Create an Archive
6. Validate and upload to the App Store
7. Submit for TestFlight/review


### Android

Ensure that you have copied `build.json.default` to `build.json` and set the passwords.

1. If necessary, create a new release using `git flow`
2. If necessary, bump the version code in config.xml
3. Compile the app `./build ios <environment> <version>`
4. Upload `dist/platforms/android/build/outputs/apk/android-release.apk` to Google Play


### App Signing

#### Android

To sign the app you need to generate a keystore and update it's details in `build.json`:

    keytool -genkey -v -keystore KEYSTORENAME.keystore -alias KEYSTORENAME -keyalg RSA -keysize 2048 -validity 10000


#### iOS

You'll need to use the GUID for the provisioning profile in build.json, which can be found at:

    ~/Library/MobileDevice/Provisioning\ Profiles/



