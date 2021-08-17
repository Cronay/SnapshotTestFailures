```
xcodebuild clean build test -project SnapshotTestFailures.xcodeproj -scheme "SnapshotTestFailures" CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 12,OS=14.5" ONLY_ACTIVE_ARCH=YES
```

In this project I explored how to implement a image comparison algorithm with tolerance.
It's supposed to be used for snapshot testing since those are not completely reliable when run on different Macs, because of small variances in GPU renderings.
