fs = Npm.require('fs')
path = Npm.require('path')
jobsCollection = new Meteor.Collection('testJobsCollection')
propertiesCollection = new Meteor.Collection('testPropertiesCollection')

fixtures = path.join(process.cwd(), 'assets', 'packages', 'local-test_borscht_release-loader', 'fixtures');
fakeRelease = path.join(fixtures, 'fake-release')

fakeManifestLoader =
  load: -> return

reset = ->
  jobsCollection.remove({})
  propertiesCollection.remove({})


describe 'ReleaseLoader', ->
  describe '#constructor', ->
    context 'when the release directory does not exist', ->
      it 'returns an error', (test) ->
        test.throws ->
          new ReleaseLoader('/fake/path/that/does/not/exist', fakeManifestLoader)

    context 'when the release directory does exist', ->
      it 'returns a release loader', (test) ->
        test.isTrue(fs.existsSync(fakeRelease))

        loader = new ReleaseLoader(fakeRelease, fakeManifestLoader)
        test.instanceOf(loader, ReleaseLoader)

    context 'when a ManifestLoader is not provided', ->
      it 'throws an error', (test) ->
        test.throws ->
          loader = new ReleaseLoader(fakeRelease)


  describe '#jobs', ->
    it 'returns jobs from the release directory', (test) ->
      loader = new ReleaseLoader(fakeRelease, fakeManifestLoader)

      firstJob = loader.jobs()[0]
      test.equal(firstJob.name, 'fake-job')
      test.equal(firstJob.packages, ['ruby', 'go'])

  describe '#load', ->
    it 'loads all jobs into a Jobs collection', (test) ->
      reset()

      loader = new ReleaseLoader(fakeRelease, fakeManifestLoader)
      loader.load(jobsCollection, propertiesCollection)

      firstJob = jobsCollection.findOne()
      test.equal(firstJob.name, 'fake-job')
      test.equal(firstJob.packages, ['ruby', 'go'])

    context 'when a job with the same name already exists', ->
      it 'overwrites it', (test) ->
        reset()
        jobsCollection.insert(name: 'fake-job', packages: ['old package'])

        loader = new ReleaseLoader(fakeRelease, fakeManifestLoader)
        loader.load(jobsCollection, propertiesCollection)

        test.equal jobsCollection.findOne().packages, ['ruby', 'go']
        test.equal jobsCollection.find(name: 'fake-job').count(), 1

    it 'loads all properties into a properties collection', (test) ->
      reset()

      loader = new ReleaseLoader(fakeRelease, fakeManifestLoader)
      loader.load(jobsCollection, propertiesCollection)

      property = propertiesCollection.findOne()
      test.equal property.key, 'cf.api_url'
      test.equal property.job, 'fake-job'
      test.equal property.description, 'Full URL of Cloud Foundry API'

    it 'loads property values from the manifest', (test) ->
      loaded = false
      fakeManifestLoader.load = (collection) ->
        loaded = (collection == propertiesCollection)

      loader = new ReleaseLoader(fakeRelease, fakeManifestLoader)
      loader.load(jobsCollection, propertiesCollection)

      test.isTrue loaded

    context 'when a property with the same job and key already exists', ->
      it 'overwrites it', (test) ->
        reset()
        propertiesCollection.insert
          key: 'cf.api_url'
          job: 'fake-job'
          description: 'OLD DESCRIPTION'

        loader = new ReleaseLoader(fakeRelease, fakeManifestLoader)
        loader.load(jobsCollection, propertiesCollection)

        property = propertiesCollection.findOne()
        test.equal propertiesCollection.findOne().description, 'Full URL of Cloud Foundry API'
        test.equal propertiesCollection.find(key: 'cf.api_url', job: 'fake-job').count(), 1
