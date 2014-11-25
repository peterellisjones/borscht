fs = Npm.require('fs')
path = Npm.require('path')

fixtures = path.join(process.cwd(), 'assets', 'packages', 'local-test_borscht_manifest-loader', 'fixtures');
manifestPath = path.join(fixtures, 'manifest.yml')

describe 'ManifestLoader', ->
  describe 'constructor', ->
    context 'when passed a path', ->
      context 'when the file does not exist', ->
        it 'returns an error', (test) ->
          test.throws ->
            new ManifestLoader('/invalid/path/to/manifest')

      context 'when the file exists', ->
        it 'does not return an error', (test) ->
          test.instanceOf  (new ManifestLoader(manifestPath)), ManifestLoader

  loader = new ManifestLoader(manifestPath)
  properties = new Meteor.Collection('test-properties')
  reset = ->
    properties.remove({})

  describe '#load', ->
    context 'when a property exists', ->
      it 'updates the jobValue', (test) ->
        reset()

        properties.insert new Property(
          key: 'broker.name'
          job: 'broker-registrar'
          description: 'test'
        )

        loader.load(properties)

        prop = properties.findOne(key: 'broker.name', job: 'broker-registrar')
        test.equal prop.jobValue, 'redis'

      it 'updates the globalValue', (test) ->
        reset()

        properties.insert new Property(
          key: 'broker.golang'
          job: 'broker-registrar'
          description: 'test'
        )

        loader.load(properties)

        prop = properties.findOne(key: 'broker.golang', job: 'broker-registrar')
        test.equal prop.globalValue, true
