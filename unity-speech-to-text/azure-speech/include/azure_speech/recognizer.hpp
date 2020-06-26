#include <iostream>
#include <boost/format.hpp>
#include <MicrosoftCognitiveServicesSpeech/speechapi_cxx.h>

namespace azure_speech {
    class Recognizer {
        using Logger = std::function<void (const char *)>;
        using Callback = std::function<void (const char *, const char *)>;

        std::shared_ptr<Microsoft::CognitiveServices::Speech::Translation::TranslationRecognizer> recognizer;
        Logger logger;

    public:
        Recognizer(const char * key, const char * region, Logger logger_) : logger(logger_) {
            using namespace Microsoft::CognitiveServices::Speech;

            auto config = Translation::SpeechTranslationConfig::FromSubscription(key, region);
            config->SetSpeechRecognitionLanguage("ja-JP");
            config->AddTargetLanguage("en");
            this->recognizer = Translation::TranslationRecognizer::FromConfig(config);
        }

        void recognize(Callback callback) {
            using namespace Microsoft::CognitiveServices::Speech;

            this->logger("Say something...");

            auto result = recognizer->RecognizeOnceAsync().get();

            if (result->Reason == ResultReason::TranslatedSpeech) {
                this->logger((boost::format("recognized: %1%") % result->Text).str().c_str());

                for (const auto & v: result->Translations) {
                    this->logger((boost::format("translated: %1% -> %2%") % v.first % v.second).str().c_str());
                    callback(result->Text.c_str(), v.second.c_str());
                }
            }
            else if (result->Reason == ResultReason::NoMatch) {
                this->logger("NOMATCH: Speech could not be recognized.");
            }
            else if (result->Reason == ResultReason::Canceled) {
                auto cancellation = CancellationDetails::FromResult(result);
                this->logger((boost::format("CANCELED: Reason=%1%") % (int)cancellation->Reason).str().c_str());

                if (cancellation->Reason == CancellationReason::Error) {
                    this->logger((boost::format("CANCELED: ErrorCode=%1%") % (int)cancellation->ErrorCode).str().c_str());
                    this->logger((boost::format("CANCELED: ErrorDetails=%1%") % cancellation->ErrorDetails).str().c_str());
                    this->logger("CANCELED: Did you update the subscription info?");
                }
            }
        }
    };
}
