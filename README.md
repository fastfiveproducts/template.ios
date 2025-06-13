# template
the Fast Five Products LLC iOS application template App
(https://github.com/fastfiveproducts/template.ios)

##  Clone project
- cd to your root Programs folder or directory
- clone project from GitHub via your preferred method

##  Dependencies
- requires an implementation of Firebase Data Connect
- in particular the the the FastFive Products LLC Firebase template (https://github.com/fastfiveproducts/template.firebase)
- after cloning, add your GoogleService-info.plist file to "Cloud Services" folder group

##  Run on an iOS Siumulator via Xcode on a Mac
- “Open a project or file” and open the Xcode project file
- choose your simulator device
- build and run via "Product -> Run"

##  Run on your iOS Device via Xcode on a Mac
- “Open a project or file” and open the Xcode project file
- when choosing your device, click "Manage Run Destinations" and add your device
- choose your device
- build and run via "Product -> Run"

##  Run on your iOS Device via Test Flight
- install TestFlight on your device: if you don't already have it:
        download the TestFlight app from the App Store (https://apps.apple.com/us/app/testflight/id899247664)
- you (or someone) needs to use Xcode to Archive the App, upload it to App Store Connect,
        and make the build available via Test Flight
- your Apple Id must be invited and/or added to the appropriate test group
- look for the invitation email from Apple and accept it; the app should then appear in TestFlight
- install app from within Test Flight; the app will then appear on your device like any other app

##  TODO
- see issues in GitHub (https://github.com/fastfiveproducts/template.ios/issues)
