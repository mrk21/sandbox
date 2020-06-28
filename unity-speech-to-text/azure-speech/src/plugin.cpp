#include <azure_speech/recognizer.hpp>

#ifdef _WIN32
#define UNITYCALLCONV __stdcall
#define UNITYEXPORT __declspec(dllexport)
#else
#define UNITYCALLCONV
#define UNITYEXPORT
#endif

extern "C" {
    UNITYEXPORT azure_speech::Recognizer * UNITYCALLCONV Recognizer_new(
        const char * key,
        const char * region,
        void (*logger)(const char *),
        void (*callback)(const char *, const char *)
    ) {
        return new azure_speech::Recognizer(key, region, logger, callback);
    }

    UNITYEXPORT void UNITYCALLCONV Recognizer_start(azure_speech::Recognizer * recognizer) {
        recognizer->start();
    }

    UNITYEXPORT void UNITYCALLCONV Recognizer_stop(azure_speech::Recognizer * recognizer) {
        recognizer->stop();
    }

    UNITYEXPORT void UNITYCALLCONV Recognizer_delete(azure_speech::Recognizer * recognizer) {
        delete recognizer;
    }
}
