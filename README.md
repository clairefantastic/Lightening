# Lightening
<p align= "center">
<img src="https://user-images.githubusercontent.com/77667003/170659274-618dd740-97de-477c-961b-94c14a4fad58.png" width="160" height="160">
</p>

<p align= "center">
<a href="https://apps.apple.com/us/app/lightening/id1619737686"><img src="https://user-images.githubusercontent.com/77667003/170689371-cf5b869d-5748-4683-b336-96010464b568.png" width="120" height="40" border="0"></a>
</p>

## About

Lightening is a sound-based app that aims to make the world more accessible. We connect the visually impaired and volunteers by live video calls and audio-sharing.

May the sounds be with you. Lighten your burden, and lighten your life.

## Features

For the **Visually Impaired**:
* Get visual assistance via live video calls.
* Enjoy audios shared by volunteers.

<p align= "center">
<img src="https://user-images.githubusercontent.com/77667003/170680799-403fc13a-9c97-485b-b093-ddc15c49f7a0.png" width="700" height="400">
</p>

For **Volunteers**:
* Provide assistance when receiving video calls.
* Upload audio files by directly recording or selecting files with personalized content to share precious sounds around.

<p align= "center">
<img src="https://user-images.githubusercontent.com/77667003/170684248-e3e213cf-bc51-49a0-829f-0e5e0d52f207.png" width="700" height="400">
</p>

* Discover audios by means of browsing a vinyl wall, searching with keywords, finding by location, and using random picks system.
* See descriptions and freely comments on audios.

<p align= "center">
<img src="https://user-images.githubusercontent.com/77667003/170684537-69013a6f-c56b-417f-8ef3-f39c1e9dbe82.png" width="700" height="400">
</p>

## Techniques

* Increased code reusability and maintainability by adopting **MVC** structure.
* Realized low latency live video calls via combining a **self-designed pair-up system** and **WebRTC**.
* Utilized **AVPlayer**, **AVAudioPlayer**, and **AVAudioRecorder** to play audios and record sounds.
* Added annotations with **MapKit** and enable users to discover audios by location.
* Managed data source through **Firebase Firestore** and **Storage** without server backup.
* Focused on **User-centered design** by implementing two distinct user flows with a simplified interface for the visually impaired and a versatile interface for volunteers.
* Successfully ensured every element in the visually impaired interface can be read by **VoiceOver** and improved friendliness by grouping accessibility content.
* Built user interfaces with **programmatically** and **xib**.
* Implemented sign-in flow with **Sign in with Apple** and **Firebase Authentication**.
* Created **animations** when playing audios and in lobby page to improve user experience.
* Add notifications to remind users of revisiting Lightening every day using **User Notifications**.


## Libraries

* <a href="https://firebase.google.com/"> Firebase</a>
* <a href="https://webrtc.org/"> WebRTC</a>
* <a href="https://lottiefiles.com/"> Lottie</a>
* <a href="https://github.com/hackiftekhar/IQKeyboardManager"> IQKeyboardManagerSwift</a>
* <a href="https://github.com/onevcat/Kingfisher"> Kingfisher</a>
* <a href="https://github.com/JonasGessner/JGProgressHUD"> JGProgressHUD</a>
* <a href="https://github.com/realm/SwiftLint"> SwiftLint</a>

## Requirement

* Xcode 13.0
* Swift 5
* iOS 13

## Version

1.0

## Release Notes

| Version  | Date | Notes |
| ------------- |:-------------:|:-------------:|
| 1.0      | 2022.05.12     | Released on App Store |

## Author

* Yun-Ting Chiou | clairefantastic7@gmail.com

## License 
Copyright 2022 Yun-Ting Chiou

License under MIT license. 
See
[License](https://github.com/clairefantastic/Lightening/blob/develop/LICENSE) for detail.
