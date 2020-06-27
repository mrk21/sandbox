#include <native_plugin/generator.hpp>
#include <string>
#include <thread>
#include <chrono>
#include <random>
#include <iostream>

namespace native_plugin {
    Generator::Generator(
        void (*callback_)(const char *),
        void (*logger_)(const char *)
    ) :
        callback(callback_),
        logger(logger_),
        is_running(false),
        is_stopped(true)
    {}

    Generator::~Generator() {
        this->stop();
    }

    void Generator::start() {
        std::random_device seed_gen;
        std::mt19937 engine_value(seed_gen());
        std::mt19937 engine_interval(seed_gen());
        std::uniform_int_distribution<> dist_value(1, 100);
        std::uniform_int_distribution<> dist_interval(100, 1000);
        auto rand_value = [&]{ return dist_value(engine_value); };
        auto rand_interval = [&]{ return dist_interval(engine_interval); };

        this->is_running = true;
        this->is_stopped = false;
        this->log("start");

        while (this->is_running) {
            auto v = std::to_string(rand_value());
            this->callback(v.c_str());
            std::this_thread::sleep_for(std::chrono::milliseconds(rand_interval()));
        }

        this->is_running = false;
        this->is_stopped = true;
    }

    void Generator::stop() {
        this->is_running = false;
        while (!this->is_stopped) {
            this->log("stopping...");
            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
        this->log("stopped");
    }

    void Generator::log(const std::string & v) const {
        this->logger(("LOG: " + v).c_str());
    }
}
