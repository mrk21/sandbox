#include <iostream>
#include <cstdlib>
#include <MicrosoftCognitiveServicesSpeech/speechapi_cxx.h>

void recognizeSpeech() {
    using namespace Microsoft::CognitiveServices::Speech;

    const auto key = std::getenv("AZURE_SBSCRIPTION_KEY");
    const auto region = std::getenv("AZURE_REGION");

    auto config = Translation::SpeechTranslationConfig::FromSubscription(key, region);
    config->SetSpeechRecognitionLanguage("ja-JP");
    config->AddTargetLanguage("en");

    auto recognizer = Translation::TranslationRecognizer::FromConfig(config);

    std::cout << "Say something..." << std::endl;

    auto result = recognizer->RecognizeOnceAsync().get();

    if (result->Reason == ResultReason::TranslatedSpeech) {
        std::cout << "recognized: " << result->Text << std::endl;
        for (const auto & v: result->Translations) {
            std::cout << "translated: " << v.first << " -> " << v.second << std::endl;
        }
    }
    else if (result->Reason == ResultReason::NoMatch) {
        std::cout << "NOMATCH: Speech could not be recognized." << std::endl;
    }
    else if (result->Reason == ResultReason::Canceled) {
        auto cancellation = CancellationDetails::FromResult(result);
        std::cout << "CANCELED: Reason=" << (int)cancellation->Reason << std::endl;

        if (cancellation->Reason == CancellationReason::Error) {
            std::cout << "CANCELED: ErrorCode= " << (int)cancellation->ErrorCode << std::endl;
            std::cout << "CANCELED: ErrorDetails=" << cancellation->ErrorDetails << std::endl;
            std::cout << "CANCELED: Did you update the subscription info?" << std::endl;
        }
    }
}

int main() {
    while (true) recognizeSpeech();
    return 0;
}
