logger = new Logger("boot")

Meteor.startup ->
  releasePath = process.env.RELEASE_PATH
  throw new Error("RELEASE_PATH not set") unless releasePath?

  manifestPath = process.env.MANIFEST_PATH
  throw new Error("MANIFEST_PATH not set") unless manifestPath?

  logger.info("loading release: #{releasePath}")
  manifestLoader = new ManifestLoader(manifestPath)
  releaseLoader = new ReleaseLoader(releasePath, manifestLoader)

  Jobs.remove({})
  Properties.remove({})
  releaseLoader.load(Jobs, Properties)
