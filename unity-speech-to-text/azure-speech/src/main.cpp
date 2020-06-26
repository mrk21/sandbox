#include <iostream>
#include <azure_speech/recognizer.hpp>

int main() {
    azure_speech::Recognizer recognizer(
        (const char *)std::getenv("AZURE_SBSCRIPTION_KEY"),
        (const char *)std::getenv("AZURE_REGION"),
        [](auto v){ std::cout << v << std::endl; }
    );
    while (true) recognizer.recognize([](auto v1, auto v2){ std::cout << v1 << " -> " << v2 << std::endl; });
    return 0;
}
