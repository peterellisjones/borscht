Properties = new Meteor.Collection 'properties', transform: (property) ->
  new Property(property)

class Property
  constructor: (options) ->
    @key = options.key
    unless @key?
      throw new Error("key not found")

    @description = options.description
    unless @description?
      throw new Error("description not found")

    @job = options.job
    unless @job?
      throw new Error("job not found")

    @default = options.default if options.default?
    @jobValue = options.jobValue if options.jobValue?
    @globalValue = options.globalValue if options.globalValue?


  value: ->
    return @jobValue if @jobValue?
    return @globalValue if @globalValue?
    return @default if @default?
    null

  humanReadableValue: ->
    value = @value()
    if (typeof value) == 'string'
      return value

    if value in [null, true, false]
      return value

    JSON.stringify(value)
