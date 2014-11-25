Package.describe({
  name: 'borscht:property',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('coffeescript');

  api.addFiles('property.coffee');
  api.export('Property');
  api.export('Properties');
});

Package.onTest(function(api) {
  api.use('peterellisjones:describe');
  api.use('coffeescript');
  api.use('borscht:property');
  api.addFiles('property-tests.coffee');
});
