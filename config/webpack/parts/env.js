'use strict';

const paths = require('./paths');

process.env.PUBLIC_URL = paths.appPublic;

console.log(process.env.PUBLIC_URL);
