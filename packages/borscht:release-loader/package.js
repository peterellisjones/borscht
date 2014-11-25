Package.describe({
  name: 'borscht:release-loader',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('coffeescript');

  api.use('borscht:job');
  api.use('borscht:property');
  api.use('borscht:manifest-loader');

  api.addFiles('release-loader.coffee', 'server');
  api.export('ReleaseLoader');
});

Package.onTest(function(api) {
  var path = Npm.require('path');

  api.use('peterellisjones:describe');
  api.use('coffeescript');
  api.use('tinytest');
  api.use('borscht:release-loader');

  api.addFiles(path.join('fixtures', 'fake-release', 'jobs', 'fake-job', 'spec'));

  api.addFiles('release-loader-tests.coffee', 'server');
});

Npm.depends({'js-yaml': '0.2.1'});
