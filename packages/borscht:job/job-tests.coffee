describe 'Job', ->
  describe '#constructor', ->

    spec =
      name: 'fake-job'
      packages: ['ruby', 'go']
      badField: 'should not be here'


    job = new Job(spec)

    it 'has packages', (test) ->
      test.equal job.packages, spec.packages

    it 'has a name', (test) ->
      test.equal job.name, spec.name

    it 'does not have other fields', (test) ->
      test.isUndefined job.badField
