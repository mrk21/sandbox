#include <string>
#include <native_plugin/generator.hpp>

#ifdef _WIN32
#define UNITYCALLCONV __stdcall
#define UNITYEXPORT __declspec(dllexport)
#else
#define UNITYCALLCONV
#define UNITYEXPORT
#endif

extern "C" {
    UNITYEXPORT int UNITYCALLCONV get_number() {
        return 777;
    }

    UNITYEXPORT const char * UNITYCALLCONV get_string() {
        std::string s = "fuga";
        char * result = static_cast<char *>(std::malloc(sizeof(char) * s.size()));
        s.copy(result, s.size());
        return result;
    }

    UNITYEXPORT void UNITYCALLCONV call_callback(void (*callback)(const char *)) {
        callback("hoge");
    }

    // for Generator
    UNITYEXPORT native_plugin::Generator * UNITYCALLCONV Generator_new(void (*callback)(const char *), void (*logger)(const char *)) {
        return new native_plugin::Generator(callback, logger);
    }

    UNITYEXPORT void UNITYCALLCONV Generator_start(native_plugin::Generator * generator) {
        generator->start();
    }

    UNITYEXPORT void UNITYCALLCONV Generator_stop(native_plugin::Generator * generator) {
        generator->stop();
    }

    UNITYEXPORT void UNITYCALLCONV Generator_delete(native_plugin::Generator * generator) {
        delete generator;
    }
}
