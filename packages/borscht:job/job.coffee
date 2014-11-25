Jobs = new Meteor.Collection 'jobs', transform: (job) ->
  new Job(job)

class Job
  constructor: (spec) ->
    @name = spec.name
    @packages = spec.packages
