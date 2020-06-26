#include <cstdlib>
#include <cstring>

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
        const char *str = "test";
        char* retStr = (char*)std::malloc(strlen(str) + 1);
        strcpy(retStr, str);
        retStr[strlen(str)] = '\0';
        return retStr;
    }

    UNITYEXPORT void UNITYCALLCONV call_callback(void (*callback)(const char *)) {
        callback("hoge");
    }
}
