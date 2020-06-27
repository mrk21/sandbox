#include <native_plugin/generator.hpp>
#include <iostream>
#include <thread>
#include <functional>
#include <csignal>

native_plugin::Generator * generator = nullptr;

int main() {
    ::generator = new native_plugin::Generator(
        [](auto v){ std::cout << v << std::endl; },
        [](auto v){ std::cout << v << std::endl; }
    );
    std::thread t([] { ::generator->start(); });
    std::signal(SIGINT, [](int _){
        std::cout << std::endl;
        ::generator->stop();
        delete ::generator;
        ::generator = nullptr;
        std::exit(0);
    });
    t.join();
    return 0;
}
