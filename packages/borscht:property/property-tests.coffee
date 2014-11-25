describe 'Property', ->
  it 'is invalid without a key', (test) ->
    test.throws ->
      new Property(description: 'blaah', job: 'node')

  it 'is invalid without a description', (test) ->
    test.throws ->
      new Property(key: 'cf.api_url', job: 'node')

  it 'is invalid without a job', (test) ->
    test.throws ->
      new Property(key: 'cf.api_url', description: 'blaah')

  it 'is valid with a key', (test) ->
    property = new Property(key: 'cf.api_url', description: 'blaah', job: 'node')
    test.instanceOf property, Property

  context 'when passed a default value', ->
    it 'has a default', (test) ->
      property = new Property(key: 'cf.api_url', job: 'node', description: 'blaah', default: 'foo')
      test.equal property.default, 'foo'

  describe '#value', ->
    options =
      key: 'cf.api_url'
      description: 'blaah'
      job: 'node'

    context 'when no value is set', ->
      it 'is null', (test) ->
        property = new Property(options)
        test.isNull property.value()

    context 'when a default value is set', ->
      it 'is the default', (test) ->
        property = new Property(options)
        property.default = 'foo'
        test.equal property.value(), 'foo'

    context 'when a default value and a global value are set', ->
      it 'is the global value', (test) ->
        property = new Property(options)
        property.default = 'foo'
        property.globalValue = 'bar'
        test.equal property.value(), 'bar'

    context 'when a default, job, and global value are set', ->
      it 'is the job value', (test) ->
        property = new Property(options)
        property.default = 'foo'
        property.globalValue = 'bar'
        property.jobValue = 'baz'
        test.equal property.value(), 'baz'
