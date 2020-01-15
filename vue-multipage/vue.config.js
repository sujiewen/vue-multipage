// const BundleAnalyzerPlugin = require('webpack-bundle-analyzer')
//   .BundleAnalyzerPlugin
//
// const IS_PROD = ['production', 'prod'].includes(process.env.NODE_ENV)

let path = require('path')
let glob = require('glob')

// 配置pages多页面获取当前文件夹下的html和js
function getEntry (globPath) {
  let entries = {}
  let basename; let tmp; let pathname

  glob.sync(globPath).forEach(function (entry) {
    basename = path.basename(entry, path.extname(entry))
    // console.log(entry)
    tmp = entry.split('/').splice(-3)
    pathname = basename // 正确输出js和html的路径

    // console.log(pathname)
    entries[pathname] = {
      entry: 'src/' + tmp[0] + '/' + tmp[1] + '/main.js',
      template: 'src/' + tmp[0] + '/' + tmp[1] + '/' + tmp[2],
      title: tmp[2],
      filename: tmp[2]
    }
  })
  return entries
}

let pages = getEntry('./src/pages/**?/*.html')

// 配置end
module.exports = {
  publicPath: './',
  lintOnSave: false, // 禁用eslint
  productionSourceMap: false,
  pages: pages,
  devServer: {
    index: 'page1.html', // 默认启动serve 打开index页面
    open: true,
    host: '0.0.0.0',
    port: 8080,
    https: false,
    hotOnly: false
  }
}
