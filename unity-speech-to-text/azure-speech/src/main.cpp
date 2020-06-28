#include <azure_speech/recognizer.hpp>
#include <iostream>
#include <thread>
#include <functional>
#include <csignal>

azure_speech::Recognizer * recognizer = nullptr;
bool is_stopping = false;

int main() {
    ::recognizer = new azure_speech::Recognizer(
        (const char *)std::getenv("AZURE_SBSCRIPTION_KEY"),
        (const char *)std::getenv("AZURE_REGION"),
        [](auto v){ std::cout << v << std::endl; },
        [](auto v1, auto v2){ std::cout << v1 << " -> " << v2 << std::endl; }
    );
    std::thread t([] { ::recognizer->start(); });
    std::signal(SIGINT, [](int){
        if (::is_stopping) return;
        ::is_stopping = true;
        std::cout << std::endl;
        ::recognizer->stop();
        delete ::recognizer;
        ::recognizer = nullptr;
        std::exit(0);
    });
    t.join();
    return 0;
}
