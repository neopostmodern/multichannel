Meteor.methods
  'multichannel.initialize-project': (options) ->
    gif = Gifs.findOne options.fileId

    @unblock()

    Projects.insert(
      name: gif.name()
      originalGif: gif._id
      frames: []
    , (error, projectId) ->
      # todo: error handling
      if error?
        console.dir error
        return

      frameIndex = 0

      GifExplode.Do gif.createReadStream('gifs').path, (frame) ->
        _frameIndex = frameIndex
        frameIndex += 1
        fsFrame = new FS.File()
        fsFrame.attachData(frame, { type: 'image/gif' })
        Gifs.insert(
          fsFrame
        , (error, frameObject) ->
          # todo: error handling
          if error?
            console.dir error
            return

          Projects.update(_id: projectId,
            $push:
              frames:
                $each: [
                  gif: frameObject._id
                  index: _frameIndex
                ]
                $sort: index: 1
          , (error) ->
            # todo: error handling
            if error?
              console.dir error
              return
          )
        )
    )
