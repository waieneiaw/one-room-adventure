'use strict';

// Lib
const path = require('path');
const webpack = require('webpack');

// Plugins
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const Dotenv = require('dotenv-webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const WorkboxWebpackPlugin = require('workbox-webpack-plugin');
const WebpackPwaManifest = require('webpack-pwa-manifest');
const CopyPlugin = require('copy-webpack-plugin');

// Parts
const env = require('./parts/env')
const paths = require('./parts/paths')
const vars = require('./parts/vars')

// ----------------------------------------------------------------------------
// Constants
// ----------------------------------------------------------------------------

// env
const environment = process.env.NODE_ENV; // 'production' or 'development'
const isProduction = environment === 'production';
const isDevelopment = !isProduction;

// dev-server
const devPort = 3000;

const optimization = isProduction
  ? {
    minimize: isProduction,
    splitChunks: {
      cacheGroups: {
        defaultVendors: {
          test: /[\\/]node_modules[\\/]/,
          // name: 'vendors',
          name: false,
          chunks: 'all',
        },
      },
    },
    minimizer: [
      new TerserPlugin({
        cache: true,
        parallel: true,
        terserOptions: {
          parse: {
            ecma: 8,
          },
          compress: {
            drop_console: isProduction,
            ecma: 5,
            warnings: false,
            comparisons: false,
            inline: 2,
          },
          mangle: {
            safari10: true,
          },
          output: {
            ecma: 5,
            comments: false,
            ascii_only: true,
          },
        },
      }),
      new OptimizeCSSAssetsPlugin({}),
    ],
  }
  : {};

module.exports = {
  mode: environment,
  devtool: isDevelopment && 'inline-source-map',
  entry: './src/index.ts',
  output: {
    // path: OUTPUT_PATH,
    path: paths.appBuild,
    // filename: '[name].js',
    filename: isProduction
      ? 'static/js/[name].[hash:8].js'
      : isDevelopment && 'static/js/bundle.js',
    // TODO: remove this when upgrading to webpack 5
    futureEmitAssets: true,
    // There are also additional JS chunk files if you use code splitting.
    chunkFilename: isProduction
      ? 'static/js/[name].[hash:8].chunk.js'
      : isDevelopment && 'static/js/[name].chunk.js',
    libraryTarget: 'this',
    pathinfo: isProduction,
  },
  optimization,
  resolve: {
    alias: {
      '@@': paths.appPath,
      '@': paths.appSrc,
    },
    extensions: ['.ts', '.tsx', '.js', '.json'],
    modules: [
      __dirname,
      'node_modules'
    ],
  },
  devServer: {
    contentBase: paths.appBuild,
    hot: true,
    open: true,
    publicPath: '/',
    writeToDisk: true,
    stats: 'errors-only',
    host: '0.0.0.0',
    port: devPort,
    historyApiFallback: {
      rewrites: [
        { from: /.*/, to: '/' },
      ]
    },
  },
  module: {
    rules: [
      {
        // elm
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          { loader: 'elm-hot-webpack-loader' },
          {
            loader: 'elm-webpack-loader',
            options: {
              verbose: (isProduction) ? true : false,
              cwd: paths.appPath,
              optimize: (isProduction) ? true : false,
              debug: (isDevelopment) ? true : false,
            }
          }
        ]
      },
      {
        // eslint
        test: /\.(js|mjs|jsx|ts|tsx)$/,
        enforce: 'pre',
        exclude: /node_modules/,
        use: [
          {
            loader: 'eslint-loader',
          },
        ],
      },
      {
        // css, sass
        test: /\.(scss|sass|css)$/i,
        use: [
          {
            loader: isDevelopment ? 'style-loader' : MiniCssExtractPlugin.loader,
          },
          {
            loader: 'css-loader',
            options: {
              url: false,
              sourceMap: isDevelopment,
              importLoaders: 2
            }
          },
          {
            loader: 'postcss-loader',
            options: {
              sourceMap: isDevelopment,
              plugins: [
                require('autoprefixer')({
                  grid: true
                })
              ]
            }
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: isDevelopment,
            }
          }
        ],
      },
      {
        // file-loader
        test: /\.(gif|png|jpe?g|svg)$/i,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: './static/images/[name].[ext]'
            }
          }
        ],
      },
      {
        // babel, ts-loader
        test: /\.(js|mjs|jsx|ts|tsx)$/,
        exclude: /node_modules/,
        use: [
          // {
          //   loader: 'babel-loader?cacheDirectory',
          // },
          {
            loader: 'ts-loader',
            options: {
              configFile: paths.tsConfig,
              transpileOnly: isDevelopment,
              experimentalWatchApi: isDevelopment,
            },
          }
        ]
      },
      {
        test: /env.js$/,
        use: [
          {
            loader: 'val-loader',
          }
        ]
      },
      {
        test: /\.js$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'babel-loader',
        options: {
          cacheDirectory: true,
        }
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin(),
    new CopyPlugin({
      patterns: [
        { from: paths.dirName.public, to: '.' },
      ]
    }),
    // new Dotenv({
    //   path: paths.dotEnv,
    //   systemvars: true,
    // }),
    new webpack.HotModuleReplacementPlugin(),
    new HtmlWebpackPlugin({
      publicPath: paths.appPublic,
      filename: 'index.html',
      template: path.resolve(paths.appPublic, 'index.html'),
      hash: true,
    }),
    new MiniCssExtractPlugin({
      publicPath: paths.appPublic,
      filename: 'static/css/[name].[hash:8].css',
      chunkFilename: 'static/css/[name].[hash:8].chunk.css',
    }),
    new WebpackPwaManifest({
      short_name: vars.appShortName,
      name: vars.appName,
      display: 'standalone',
      start_url: 'index.html',
      background_color: vars.appBgColor,
      theme_color: vars.appThemeColor,
      icons: [{
        src: path.resolve(paths.appPublic, 'favicon.ico'),
        sizes: [96, 128, 192, 256, 384, 512],
      }]
    }),
    new WorkboxWebpackPlugin.GenerateSW({
      cacheId: vars.cacheId,
      swDest: path.resolve(paths.appBuild, 'sw.js'),
      clientsClaim: true,
      skipWaiting: true,
      maximumFileSizeToCacheInBytes: 20000000,
    }),
  ],
};
