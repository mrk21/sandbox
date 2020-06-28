#include <azure_speech/recognizer.hpp>
#include <boost/format.hpp>

namespace azure_speech {
    using namespace Microsoft::CognitiveServices::Speech;

    Recognizer::Recognizer(
        const char * key,
        const char * region,
        Logger logger_,
        Callback callback_
    ) :
        logger(logger_),
        callback(callback_),
        is_running(false)
    {
        this->log(key);
        this->log(region);
        auto config = Translation::SpeechTranslationConfig::FromSubscription(key, region);
        config->SetSpeechRecognitionLanguage("ja-JP");
        config->AddTargetLanguage("en");
        this->recognizer = Translation::TranslationRecognizer::FromConfig(config);
    }

    Recognizer::~Recognizer() {
        this->stop();
    }

    // @see [Speech SDK で音声認識モードを選択する - Azure Cognitive Services | Microsoft Docs](https://docs.microsoft.com/ja-jp/azure/cognitive-services/speech-service/how-to-choose-recognition-mode?pivots=programming-language-cpp)
    // @see [class AsyncRecognizer | Microsoft Docs](https://docs.microsoft.com/ja-jp/cpp/cognitive-services/speech/asyncrecognizer)
    // @see https://github.com/hougii/MySampleCode/blob/3564a3f903894840d431680881736ee698ed78bb/Study/cognitive-services-speech-sdk/samples/cpp/windows/console/samples/translation_samples.cpp#L145
    void Recognizer::start() {
        this->log("start");
        this->is_running = true;

        this->recognizer->Recognizing.Connect([this](const auto & e) {
            auto result = e.Result;
            this->log((boost::format("recognizing: %1%") % result->Text).str());

            for (const auto & v: result->Translations) {
                this->log((boost::format("translating: %1% -> %2%") % v.first % v.second).str());
                this->callback(result->Text.c_str(), v.second.c_str());
            }
        });

        this->recognizer->Recognized.Connect([this] (const auto & e) {
            auto result = e.Result;

            switch (result->Reason) {
                case ResultReason::TranslatedSpeech: {
                    this->log((boost::format("recognized: %1%") % result->Text).str());

                    for (const auto & v: result->Translations) {
                        this->log((boost::format("translated: %1% -> %2%") % v.first % v.second).str());
                        this->callback(result->Text.c_str(), v.second.c_str());
                    }
                    break;
                }
                case ResultReason::NoMatch: {
                    this->log("NOMATCH: Speech could not be recognized.");
                    break;
                }
                default:
                    /* ignore */
                    break;
            }
        });

        this->recognizer->Canceled.Connect([this](const auto & e) {
            auto result = e.Result;
            auto cancellation = CancellationDetails::FromResult(result);
            this->log((boost::format("CANCELED: Reason=%1%") % (int)cancellation->Reason).str());

            if (cancellation->Reason == CancellationReason::Error) {
                this->log((boost::format("CANCELED: ErrorCode=%1%") % (int)cancellation->ErrorCode).str());
                this->log((boost::format("CANCELED: ErrorDetails=%1%") % cancellation->ErrorDetails).str());
                this->log("CANCELED: Did you update the subscription info?");
            }
        });

        this->recognizer->StartContinuousRecognitionAsync().wait();
        while (this->is_running) std::this_thread::sleep_for(std::chrono::milliseconds(100));

        try { this->recognizer->StopContinuousRecognitionAsync().wait(); }
        catch (const std::bad_weak_ptr & e) { /* ignore */ }
        this->log("stopped");
    }

    void Recognizer::stop() {
        if (!this->is_running) return;
        this->log("stopping...");
        this->is_running = false;
    }

    void Recognizer::log(const std::string & v) const {
        this->logger(("LOG: " + v).c_str());
    }
}
