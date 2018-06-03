const path = require('path');
const glob = require('glob');

module.exports = {
  mode: 'development',
  entry: glob.sync('./src/*.js').reduce(function(memo, file) {
    memo[path.basename(file, '.js')] = file;
    return memo;
  }, {}),
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        loader: 'babel-loader',
        options: {
          presets: ['es2015'],
        },
      }
    ],
  },
};
