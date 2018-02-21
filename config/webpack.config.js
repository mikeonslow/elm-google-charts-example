const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
module.exports = {
  entry: "./index/index.js",

  output: {
    path: __dirname + "./../dist",
    filename: "js/app.js"
  },

  devServer: {
    contentBase: __dirname + "./../index",
    compress: true,
    port: 3000,
    proxy: {
      "/api": {
        target: "http://localhost:3001",
        secure: false
      }
    }
  },

  resolve: {
    extensions: [".js", ".elm", ".css"]
  },

  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        use: {
          loader: "raw-loader"
        }
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: "elm-webpack-loader"
        }
      },
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"]
      },
      {
        test: /\.(eot|woff|woff2|svg|tff|ttf|otf|png)(.*)$/,
        loader: "file-loader"
      },
      {
        test: /\.scss$/,
        use: [
          {
            loader: "style-loader" // creates style nodes from JS strings
          },
          {
            loader: "css-loader" // translates CSS into CommonJS
          },
          {
            loader: "sass-loader" // compiles Sass to CSS
          }
        ]
      }
    ]
  },
  plugins: [
    new UglifyJsPlugin({
      uglifyOptions: { mangle: true }
    })
  ]
};
