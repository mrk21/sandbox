#include <azure_speech/recognizer.hpp>
#include <iostream>
#include <thread>
#include <functional>
#include <csignal>

namespace {
    azure_speech::Recognizer * recognizer = nullptr;
}

int main() {
    ::recognizer = new azure_speech::Recognizer(
        (const char *)std::getenv("AZURE_SBSCRIPTION_KEY"),
        (const char *)std::getenv("AZURE_REGION"),
        [](auto v){ std::cout << v << std::endl; },
        [](auto v1, auto v2){ std::cout << v1 << " -> " << v2 << std::endl; }
    );
    std::thread t([] { ::recognizer->start(); });
    std::signal(SIGINT, [](int){
        std::cout << std::endl;
        ::recognizer->stop();
    });
    t.join();
    delete ::recognizer;
    ::recognizer = nullptr;
    return 0;
}
