# Unity speech to text

## Dependencies

* Unity 2019.4.0f1
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

# 4. Move dll to Assets/Plugins
mkdir -p Assets/Plugins/x86 Assets/Plugins/x86_64
find packages -name '*.dll' -or -name '*.dylib' | xargs -J% cp -rf % Assets/Plugins
for f in $(find Assets/Plugins/*.x86.*); do; mv -f $f Assets/Plugins/x86/$(echo $f | sed 's/.x86//' | xargs basename); done
for f in $(find Assets/Plugins/*.x64.*); do; mv -f $f Assets/Plugins/x86_64/$(echo $f | sed 's/.x64//' | xargs basename); done

# 5. Put credentials
cp /path/to/gcp_credentials.json credentials.json

# 6. Generate test audio file
say -v Kyoko "日本語の音声認識、できるかな" -o test.flac
```

## Refer to

- [Using GCP NuGet Packages with Unity - Jon Foust - Medium](https://medium.com/@jonfoust/using-gcp-nuget-packages-with-unity-8dbd29c42cc4)
