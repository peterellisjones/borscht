fs = Npm.require('fs')
path = Npm.require('path')
yaml = Npm.require('js-yaml')

class ReleaseLoader
  constructor: (@releasePath, @manifestLoader) ->
    unless fs.existsSync(@releasePath)
      throw new Error("Invalid release path")

    unless @manifestLoader?
      throw new Error('manifestLoader not set')

  jobs: ->
    jobsPath = path.join(@releasePath, 'jobs')
    jobs = []

    for jobDir in fs.readdirSync(jobsPath)
      specPath = path.join(jobsPath, jobDir, 'spec')
      if fs.existsSync(specPath)
        spec = null
        try
          spec = yaml.load(fs.readFileSync(specPath, 'utf8'))
        catch err
          console.log "Error parsing spec file: #{specPath}"
        if spec?
          job = new Job(spec)
          jobs.push(job)

    jobs

  properties: ->
    jobsPath = path.join(@releasePath, 'jobs')
    properties = []
    for jobDir in fs.readdirSync(jobsPath)
      specPath = path.join(jobsPath, jobDir, 'spec')

      if fs.existsSync(specPath)
        try
          spec = yaml.load(fs.readFileSync(specPath, 'utf8'))
        catch err
          console.log "Error parsing spec file: #{specPath}"
        if spec?
          for key, value of spec.properties
            property = new Property(
              key: key
              description: value.description or ''
              default: value.default
              job: spec.name
            )

            properties.push property

    properties

  load: (jobsCollection, propertiesCollection) ->
    jobs = @jobs()
    for job in jobs

      jobsCollection.upsert({name: job.name}, job)

    properties = @properties()
    for property in properties
      propertiesCollection.upsert({key: property.key}, property)

    @manifestLoader.load(propertiesCollection)
