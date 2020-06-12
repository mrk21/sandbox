# C# GCP Speech

## Dependencies

* Visual Studio

### NuGet packages

* Google.Cloud.Speech.V1

## Setup

```sh
# 1. Install NuGet
brew install nuget

# 2. Install `Google.Cloud.Speech.V1` NuGet package on Visual Studio

# 3. Set `GOOGLE_APPLICATION_CREDENTIALS` environment variable on Visual Studio to your credential file path

# 4. Create test file
say -v Kyoko  "日本語の解析、できるかな" -o test.flac
```

## Refer to

- [Speech-to-Text クライアント ライブラリ  |  Cloud Speech-to-Text ドキュメント](https://cloud.google.com/speech-to-text/docs/libraries?hl=ja#client-libraries-install-csharp)
