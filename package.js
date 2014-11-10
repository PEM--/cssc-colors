Package.describe({
  summary: 'Colors plugin for CSSC',
  version: '1.0.3',
  name: 'pierreeric:cssc-colors',
  git: 'https://github.com/PEM--/cssc-colors.git'
});

Package.onUse(function(api) {
  api.use(['coffeescript@1.0.0', 'pierreeric:cssc@1.0.0']);
  api.addFiles('cssc-colors.coffee', 'client');
  api.imply('pierreeric:cssc');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('pierreeric:cssc-colors');
  api.addFiles('cssc-colors-tests.js');
});
