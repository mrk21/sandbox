const typescriptIsTransformer = require('typescript-is/lib/transform-inline/transformer').default;

module.exports = {
  mode: 'development',
  entry: './index.ts',
  module: {
    rules: [
      {
        test: /\.ts$/,
        exclude: /node_modules/,
        loader: require.resolve('ts-loader'),
        options: {
          context: __dirname,
          configFile: 'tsconfig.webpack.json',
          getCustomTransformers: program => ({
              before: [typescriptIsTransformer(program)]
          })
        }
      },
    ],
  },
  resolve: {
    extensions: [
      '.ts', '.js',
    ],
  },
};
