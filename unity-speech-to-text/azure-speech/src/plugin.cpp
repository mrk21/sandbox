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
        void (*logger)(const char *)
    ) {
        return new azure_speech::Recognizer(key, region, logger);
    }

    UNITYEXPORT void UNITYCALLCONV Recognizer_recognize(azure_speech::Recognizer * recognizer, void (*callback)(const char *, const char *)) {
        recognizer->recognize(callback);
    }

    UNITYEXPORT void UNITYCALLCONV Recognizer_delete(azure_speech::Recognizer * recognizer) {
        delete recognizer;
    }
}
