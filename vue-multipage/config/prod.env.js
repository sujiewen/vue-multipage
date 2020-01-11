'use strict'

let buildtype = process.argv.slice(2)[0]
console.log('buildtype='+buildtype);

let obj = {
  NODE_ENV: '"production"'
}

switch (buildtype) {
  case 'pro': //正式环境
    process.env.srconfig = 'pro'
    process.env.websrconfig = 'app'
    obj.srconfig = '"pro"'
    obj.websrconfig = '"app"'
    break;
  case 'proWeb': //正式环境
    process.env.srconfig = 'pro'
    process.env.websrconfig = 'web'
    obj.srconfig = '"pro"'
    obj.websrconfig = '"web"'
    break;
  case 'beta': //外网测试
    process.env.srconfig = 'beta'
    process.env.websrconfig = 'app'
    obj.srconfig = '"beta"'
    obj.websrconfig = '"app"'
    break;
  case 'betaWeb': //外网测试
    process.env.srconfig = 'beta'
    process.env.websrconfig = 'web'
    obj.srconfig = '"beta"'
    obj.websrconfig = '"web"'
    break;
  case 'dev': //内网测试
    process.env.srconfig = 'dev'
    process.env.websrconfig = 'app'
    obj.srconfig = '"dev"'
    obj.websrconfig = '"app"'
    break;
  case 'devWeb': //内网测试
    process.env.srconfig = 'dev'
    process.env.websrconfig = 'web'
    obj.srconfig = '"dev"'
    obj.websrconfig = '"web"'
    break;
}

module.exports = obj;
