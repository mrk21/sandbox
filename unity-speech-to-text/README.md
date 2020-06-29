# Unity speech to text

## Dependencies

* Unity 2019.4.0f1
* NuGet
* direnv

### NuGet packages

* Google.Cloud.Speech.V1
* Microsoft.CognitiveServices.Speech
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

# 4. Move dll to Assets/Plugins
mkdir -p Assets/Plugins/x86 Assets/Plugins/x86_64
find packages -type f -regex '.*/lib/netstandard2.0/.*' | xargs -J% cp -rf % Assets/Plugins
find packages -type f -regex '.*/runtimes/\(win-x86\|osx-x86\)/native/.*' | xargs -J% cp -rf % Assets/Plugins/x86
find packages -type f -regex '.*/runtimes/\(win-x64\|osx-x64\)/native/.*' | xargs -J% cp -rf % Assets/Plugins/x86_64
find packages -type f -regex '.*/runtimes/\(win\|osx\)/native/.*\.x86\..*' | xargs -J% cp -rf % Assets/Plugins/x86
find packages -type f -regex '.*/runtimes/\(win\|osx\)/native/.*\.x64\..*' | xargs -J% cp -rf % Assets/Plugins/x86_64
for f in $(find Assets/Plugins/x86/*.x86.*); do; mv -f $f Assets/Plugins/x86/$(echo $f | sed 's/\.x86//' | xargs basename); done
for f in $(find Assets/Plugins/x86_64/*.x64.*); do; mv -f $f Assets/Plugins/x86_64/$(echo $f | sed 's/\.x64//' | xargs basename); done

# 5. Put credentials
cp /path/to/gcp_credentials.json Assets/StreamingAssets/credentials.json

# 6. Generate test audio file
say -v Kyoko "日本語の音声認識、できるかな" -o Assets/StreamingAssets/test.flac

# 7. Build native plugin
```

## Refer to

- [Using GCP NuGet Packages with Unity - Jon Foust - Medium](https://medium.com/@jonfoust/using-gcp-nuget-packages-with-unity-8dbd29c42cc4)
- [Unityの特殊フォルダと各々の役割（追記版） - テラシュールブログ](http://tsubakit1.hateblo.jp/entry/20131028/1382965930)
- [nuget.exe CLI を使用して NuGet パッケージを管理する | Microsoft Docs](https://docs.microsoft.com/ja-jp/nuget/consume-packages/install-use-packages-nuget-cli)
- [bolorundurowb/dotenv.net: A library to read .env files in a .NET Core environment](https://github.com/bolorundurowb/dotenv.net)
- [NuGet パッケージの複数バージョン対応 | Microsoft Docs](https://docs.microsoft.com/ja-jp/nuget/create-packages/supporting-multiple-target-frameworks)
