#ifndef _INCLUDED_NATIVE_PLUGIN_HPP_
#define _INCLUDED_NATIVE_PLUGIN_HPP_

#include <functional>

namespace native_plugin {
    class Generator {
        std::function<void (const char *)> callback;
        std::function<void (const char *)> logger;
        bool is_running;
        bool is_stopped;

    public:
        Generator(void (*callback_)(const char *), void (*logger_)(const char *));
        ~Generator();
        void start();
        void stop();

    private:
        void log(const std::string & v) const;
    };
}

#endif
