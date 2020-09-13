'use strict';

const path = require('path');

const dirName = {
  public: 'public',
}

// Paths
const appDir = (relativePath) => path.resolve(process.env.PWD, relativePath);

module.exports = {
  dirName: dirName,
  appRoot: appDir('.'),
  appPath: appDir('.'),
  appBuild: appDir('build'),
  appSrc: appDir('src'),
  appPublic: appDir(dirName.public),
  tsConfig: appDir('tsconfig.json'),
  dotEnv: appDir('.env'),
}
