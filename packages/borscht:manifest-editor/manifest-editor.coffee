filter = new ReactiveVar(null)

jobsWithNoFilter = ->
  jobsWithFilter('')

jobsWithFilter = (f) ->
  jobs = []
  Jobs.find().forEach (job) ->
    job.formFields = []

    properties = []
    job.empty = (Properties.find(job: job.name).count() == 0)

    Properties.find(job: job.name, { sort: [['key', 'asc']] }).forEach (prop) ->
      val = "#{prop.value() or ''}"
      if f == '' or job.name.indexOf(f) != -1 or prop.key.indexOf(f) != -1 or val.indexOf(f) != -1
        properties.push(prop)

    job.show = (f == '' or properties.length > 0)

    properties.map (prop) ->
      badges = []
      if prop.jobValue?
        badges.push
          type: 'success'
          name: 'job'
      else if prop.globalValue?
        badges.push
          type: 'warning'
          name: 'global'
      else if prop.default?
        badges.push
          type: 'default'
          name: 'default'

      job.formFields.push
        labelParts: prop.key.split('.')
        id: prop._id
        value: prop.humanReadableValue()
        description: prop.description
        badges: badges

    if job.show
      jobs.push job

  jobs


Template.manifestEditor.helpers
  jobs: ->
    f = filter.get()
    return jobsWithNoFilter() if f in [null, undefined, '']


    jobsWithFilter(f)


Template.manifestEditor.events
  'change form.search input, keyup form.search input': (e) ->
    value = $(e.currentTarget).val()
    filter.set(value)
