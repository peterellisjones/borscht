Package.describe({
  name: 'borscht:manifest-loader',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('coffeescript');
  api.addFiles('manifest-loader.coffee', 'server');

  api.export('ManifestLoader', 'server');
});

Package.onTest(function(api) {
  var path = Npm.require('path');

  api.use('peterellisjones:describe');
  api.use('coffeescript');
  api.use('borscht:property', 'server');
  api.use('borscht:manifest-loader', 'server');
  api.addFiles(path.join('fixtures', 'manifest.yml'), 'server');
  api.addFiles('manifest-loader-tests.coffee', 'server');
});

Npm.depends({'js-yaml': '0.2.1'});
