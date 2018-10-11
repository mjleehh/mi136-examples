const HtmlWebpackPlugin = require('html-webpack-plugin')
const CleanWebpackPlugin = require('clean-webpack-plugin')
const webpack = require('webpack')


module.exports = (env, argv) => {
    const elmArgs = argv.mode === 'production' ?
        'verbose=true&warn=false' :
        'verbose=true&warn=false&debug=true'


    return {entry: './src/index.js',
        output: {
            path: __dirname + '/js',
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
            new HtmlWebpackPlugin({template: __dirname + '/index.html'}),
            new CleanWebpackPlugin(['www']),
        ],
        devtool: 'source-map',
    }
}
