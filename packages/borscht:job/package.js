Package.describe({
  name: 'borscht:job',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('coffeescript');
  api.addFiles('job.coffee');

  api.export('Job');
  api.export('Jobs');
});

Package.onTest(function(api) {
  api.use('peterellisjones:describe');
  api.use('coffeescript');
  api.use('borscht:job');
  api.addFiles('job-tests.coffee');
});
