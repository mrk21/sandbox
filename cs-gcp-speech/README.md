# C# GCP Speech

## Dependencies

* Visual Studio 2017
* direnv

### NuGet packages

* Google.Cloud.Speech.V1
* dotenv.net

## Setup

```sh
# 1. Edit environment variables
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .

# 2. Install NuGet
brew install nuget

# 3. Install NuGet packages
nuget install -OutputDirectory packages

# 4. Put credentials
cp /path/to/gcp_credentials.json credentials.json

# 5. Generate test audio file
say -v Kyoko "日本語の音声認識、できるかな" -o test.flac
```

## Refer to

- [Speech-to-Text クライアント ライブラリ  |  Cloud Speech-to-Text ドキュメント](https://cloud.google.com/speech-to-text/docs/libraries?hl=ja#client-libraries-install-csharp)
- [nuget.exe CLI を使用して NuGet パッケージを管理する | Microsoft Docs](https://docs.microsoft.com/ja-jp/nuget/consume-packages/install-use-packages-nuget-cli)
- [bolorundurowb/dotenv.net: A library to read .env files in a .NET Core environment](https://github.com/bolorundurowb/dotenv.net)
