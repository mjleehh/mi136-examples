const HtmlWebpackPlugin = require('html-webpack-plugin')
const CleanWebpackPlugin = require('clean-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const path = require('path')
const webpack = require('webpack')


const OUTPUT_DIR = 'dist'

module.exports = (env, argv) => {
    // determin wheither do display the time travelling elm debugger
    const elmArgs = argv.mode === 'production' ?
        'verbose=true&warn=false' :
        'verbose=true&warn=false&debug=true'


    return {entry: './src/index.js',
        output: {
            path: path.join(__dirname, OUTPUT_DIR),
            filename: 'bundle.js',
        },
        module: {
            rules: [
                {
                    test: /\.js?$/,
                    use: 'babel-loader',
                    exclude: /node_modules/
                },
                {
                    test: /\.scss$/,
                    use: [ 'style-loader', 'css-loader', 'sass-loader']
                },
                {
                    test:    /\.elm$/,
                    exclude: [/elm-stuff/, /node_modules/],
                    loader:  `elm-webpack-loader?${elmArgs}`,
                },
            ],
        },
        resolve: {
            extensions: ['.js']
        },
        plugins: [
            new CopyWebpackPlugin([{from: 'app.yaml'}]),
            new HtmlWebpackPlugin({template: path.join(__dirname, 'index.html')}),
            new CleanWebpackPlugin([OUTPUT_DIR]),
        ],
        devtool: 'source-map',
    }
}
