module.exports = {
  extends: [
    'stylelint-config-standard',
    './node_modules/prettier-stylelint/config.js'
  ],
  ignoreFiles: [
    '**/node_modules/**',
    'src/styles/**'
  ],
  plugins: ['stylelint-order'],
  rules: {
    'declaration-empty-line-before': 'never',
    'indentation': 2,
    'no-missing-end-of-source-newline': null,
    'string-quotes': 'single',
    'order/properties-alphabetical-order': true,
    'selector-type-no-unknown': null,
    'at-rule-no-unknown': [true,
      { 'ignoreAtRules': ['include', 'mixin', 'each', 'function', 'return'] }],
  },
};
