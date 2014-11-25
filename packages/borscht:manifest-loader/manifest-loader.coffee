fs = Npm.require('fs')
path = Npm.require('path')
yaml = Npm.require('js-yaml')

class ManifestLoader
  constructor: (@manifestPath) ->
    if @manifestPath?
      unless fs.existsSync(@manifestPath)
        throw new Error("Invalid manifest path")

    @raw = yaml.load(fs.readFileSync(@manifestPath, 'utf8'))

  load: (collection) ->
    collection.find().forEach (prop) =>
      globalValue = @_getGlobalProperty(prop.key)
      if globalValue?
        collection.update prop._id, { $set: { globalValue: globalValue }}

      jobValue = @_getJobProperty(prop.job, prop.key)
      if jobValue?
        collection.update prop._id, { $set: { jobValue: jobValue }}

  _getGlobalProperty: (key) ->
    @_recurseHash(key, @raw.properties)

  _getJobProperty: (jobName, key) ->
    job = @_getJob(jobName)
    return null unless job?

    @_recurseHash(key, job.properties)

  _recurseHash: (key, hash) ->
    keyParts = key.split('.') # [broker, name]
    return null unless hash?

    prop = hash
    for part in keyParts
      return null unless prop[part]?
      prop = prop[part]

    prop

  _getJob: (name) ->
    for job in @raw.jobs
      if job.name == name
        return job
    null
