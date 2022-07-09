# Media Tools

A package that provide some functions to handle with media file

## Getting started
### Depend on it
```dart
dependencies:
  media_tools: ^latest
```

## Functions
- cut (audio, video), concat (audio, video), getDuration (audio, video), convert video -> audio

### Usage
I use the `ffmpeg_kit_flutter_full` package which requires a higher Android SDK version.
So please modify your `build.gradle` (app) file as follows to avoid errors.

```
defaultConfig {
  ...
  minSdkVersion 24
  ...
}
```

`AudioTools.cutAudio(...)` return audio file path after cutting
```dart
import 'package:media_tools/src/audio_tools.dart';
...
var startPoint = 15.0; // the start time you want
var endPoint = 45.0; // end time
var pathToFile = 'path/to/audio-file.mp3'; //path to your file
var result = await AudioTools.cutAudio(pathToFile, startPoint, endPoint);
...
```