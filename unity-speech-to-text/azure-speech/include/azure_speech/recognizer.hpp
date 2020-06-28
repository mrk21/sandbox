#ifndef _AZURE_SPEECH_RECOGNIZER_HPP_
#define _AZURE_SPEECH_RECOGNIZER_HPP_

#include <MicrosoftCognitiveServicesSpeech/speechapi_cxx.h>

namespace azure_speech {
    class Recognizer {
        using Logger = std::function<void (const char *)>;
        using Callback = std::function<void (const char *, const char *)>;

        std::shared_ptr<Microsoft::CognitiveServices::Speech::Translation::TranslationRecognizer> recognizer;
        Logger logger;
        Callback callback;
        bool is_running;

    public:
        Recognizer(const char * key, const char * region, Logger logger_, Callback callback_);
        ~Recognizer();
        void start();
        void stop();

    private:
        void log(const std::string & v) const;
    };
}

#endif
