Package.describe({
  name: 'borscht:manifest-editor',
  summary: ' /* Fill me in! */ ',
  version: '1.0.0',
  git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');

  api.use('coffeescript');
  api.use('reactive-var', 'client');
  api.use('templating', 'client');

  api.addFiles('manifest-editor.html', 'client');
  api.addFiles('manifest-editor.coffee', 'client');
});
