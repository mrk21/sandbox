# C++ Azure Speech to Text

## Dependencies

* Apple Clang: >= 10.0
* direnv
* MicrosoftCognitiveServicesSpeech SDK

## Setup

```sh
# 1. Edit environment variables
cp .envrc.local.sample .envrc.local
vi .envrc.local
direnv allow .

# 2. Install MicrosoftCognitiveServicesSpeech SDK
wget -O vendor/MicrosoftCognitiveServicesSpeech.framework.zip https://aka.ms/csspeech/macosbinary
mkdir -p vendor/MicrosoftCognitiveServicesSpeech
tar xvf vendor/MicrosoftCognitiveServicesSpeech.framework.zip -C vendor/MicrosoftCognitiveServicesSpeech
rm -rf vendor/MicrosoftCognitiveServicesSpeech.framework.zip

# 3. Build
mkdir build
cd build
cmake ..
make
src/main
```

## Refer to

- [クイック スタート:音声を複数の言語に翻訳する - Speech サービス - Azure Cognitive Services | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cognitive-services/speech-service/quickstarts/translate-speech-to-text-multiple-languages?tabs=dotnet%2Cwindowsinstall&pivots=programming-language-cpp)
- [Microsoft::CognitiveServices::Speech | Microsoft Docs](https://docs.microsoft.com/ja-jp/cpp/cognitive-services/speech/)
- [cognitive-services-speech-sdk/quickstart/cpp/macos/from-microphone at master · Azure-Samples/cognitive-services-speech-sdk](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/quickstart/cpp/macos/from-microphone)
