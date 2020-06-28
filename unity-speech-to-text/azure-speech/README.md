# C++ Azure Speech to Text Native Plugin

## Dependencies

* Apple Clang: >= 10.0
* direnv
* MicrosoftCognitiveServicesSpeech SDK

## Setup

### Mac

```sh
# 1. Install MicrosoftCognitiveServicesSpeech SDK
wget -O vendor/MicrosoftCognitiveServicesSpeech.framework.zip https://aka.ms/csspeech/macosbinary
mkdir -p vendor/MicrosoftCognitiveServicesSpeech
tar xvf vendor/MicrosoftCognitiveServicesSpeech.framework.zip -C vendor/MicrosoftCognitiveServicesSpeech
rm -rf vendor/MicrosoftCognitiveServicesSpeech.framework.zip

# 2. Build and Install
mkdir build
cd build
cmake .. -G Xcode
cmake --build .
cmake --install .
```

## Refer to

- [クイック スタート:音声を複数の言語に翻訳する - Speech サービス - Azure Cognitive Services | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cognitive-services/speech-service/quickstarts/translate-speech-to-text-multiple-languages?tabs=dotnet%2Cwindowsinstall&pivots=programming-language-cpp)
- [Microsoft::CognitiveServices::Speech | Microsoft Docs](https://docs.microsoft.com/ja-jp/cpp/cognitive-services/speech/)
- [cognitive-services-speech-sdk/quickstart/cpp/macos/from-microphone at master · Azure-Samples/cognitive-services-speech-sdk](https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/quickstart/cpp/macos/from-microphone)
