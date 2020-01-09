'use strict'

// 引入nodejs路径模块
const path = require('path')
// 引入config目录下的index.js配置文件
const config = require('../config')
// 引入extract-text-webpack-plugin插件，用来将css提取到单独的css文件中
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const packageConfig = require('../package.json')
//exports其实就是一个对象，用来导出方法的，最终还是使用module.exports，此处导出assetsPath
exports.assetsPath = function (_path) {
  //如果是生产环境assetsSubDirectory就是'static'，否则还是'static'，哈哈哈
  const assetsSubDirectory = process.env.NODE_ENV === 'production'
    ? config.build.assetsSubDirectory
    : config.dev.assetsSubDirectory

  // path.join和path.posix.join的区别就是，前者返回的是完整的路径，后者返回的是完整路径的相对根路径
  // 也就是说path.join的路径是/a/a/b/xiangmu/b，那么path.posix.join就是b
  return path.posix.join(assetsSubDirectory, _path)
}

// 下面是导出cssLoaders的相关配置
exports.cssLoaders = function (options) {
  //// options如果不为null或者undefined，0，""等等就原样，否则就是{}。在js里面,||运算符，A||B，A如果为真，直接返回A。如果为假，直接返回B（不会判断B是什么类型）
  options = options || {}

  // cssLoader的基本配置
  const cssLoader = {
    loader: 'css-loader',
    options: {
      // options是用来传递参数给loader的
      // minimize表示压缩，如果是生产环境就压缩css代码
      // minimize: process.env.NODE_ENV === 'production',
      // 是否开启cssmap，默认是false
      sourceMap: options.sourceMap
    }
  }

  const postcssLoader = {
    loader: 'postcss-loader',
    options: {
      sourceMap: options.sourceMap
    }
  }

  // generate loader string to be used with extract text plugin
  function generateLoaders (loader, loaderOptions) {
    // 将上面的基础cssLoader配置放在一个数组里面
    const loaders = options.usePostCSS ? [cssLoader, postcssLoader] : [cssLoader]

    // 如果该函数传递了单独的loader就加到这个loaders数组里面，这个loader可能是less,sass之类的
    if (loader) {
      loaders.push({
        loader: loader + '-loader',
        options: Object.assign({}, loaderOptions, {
          sourceMap: options.sourceMap
        })
      })
    }

    // Extract CSS when that option is specified
    // (which is the case during production build)
    if (options.extract) {
      return ExtractTextPlugin.extract({
        use: loaders,
        fallback: 'vue-style-loader'
      })
    } else {
      return ['vue-style-loader'].concat(loaders)
    }
  }

  // https://vue-loader.vuejs.org/en/configurations/extract-css.html
  return {
    css: generateLoaders(),                     // css对应 vue-style-loader 和 css-loader
    postcss: generateLoaders(),                 // postcss对应 vue-style-loader 和 css-loader
    less: generateLoaders('less'),       // less对应 vue-style-loader 和 less-loader
    sass: generateLoaders('sass', { indentedSyntax: true }),  // sass对应 vue-style-loader 和 sass-loader
    scss: generateLoaders('sass'),       // scss对应 vue-style-loader 和 sass-loader
    stylus: generateLoaders('stylus'),   // stylus对应 vue-style-loader 和 stylus-loader
    styl: generateLoaders('stylus')      // styl对应 vue-style-loader 和 styl-loader
  }
}

// Generate loaders for standalone style files (outside of .vue)
// 下面这个主要处理import这种方式导入的文件类型的打包，上面的exports.cssLoaders是为这一步服务的
exports.styleLoaders = function (options) {
  const output = []
  // 下面就是生成的各种css文件的loader对象
  const loaders = exports.cssLoaders(options)
  // 把每一种文件的laoder都提取出来
  for (const extension in loaders) {
    const loader = loaders[extension]
    output.push({
      test: new RegExp('\\.' + extension + '$'),
      use: loader
    })
  }

  return output
}

exports.createNotifierCallback = () => {
  const notifier = require('node-notifier')

  return (severity, errors) => {
    if (severity !== 'error') return

    const error = errors[0]
    const filename = error.file && error.file.split('!').pop()

    notifier.notify({
      title: packageConfig.name,
      message: severity + ': ' + error.name,
      subtitle: filename || '',
      icon: path.join(__dirname, 'logo.png')
    })
  }
}
