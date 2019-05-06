const path = require("path");
const withTypescript = require('@zeit/next-typescript');

module.exports = withTypescript({
  webpack(config, options) {
    config.resolve.alias = {
      ...config.resolve.alias,
      "~": path.resolve('.'),
      "@": path.resolve('.'),
    };
    return config;
  }
});
