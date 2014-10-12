Package.describe({
  summary: 'Colors plugin for CSSC',
  version: '0.1.0',
  git: 'https://github.com/PEM--/cssc-colors.git'
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');
  api.use('pierreeric:cssc');
  api.addFiles('cssc-colors.coffee');
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('pierreeric:cssc-colors');
  api.addFiles('cssc-colors-tests.js');
});
