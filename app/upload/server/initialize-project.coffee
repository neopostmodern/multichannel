Meteor.methods
  'multichannel.initialize-project': (options) ->
    # todo: reformat code to make more readable

    if not @userId?
      throw new Meteor.Error 401, "Please log in to create a multichannel"

    gif = Gifs.findOne options.fileId

    @unblock()

    Projects.insert(
      name: gif.name()
      originalGif: gif._id
      frames: []
      userId: @userId
      likes: 0
    , (error, projectId) =>
      # todo: error handling
      if error?
        console.dir error
        return

      Meteor.users.update _id: @userId,
        $push:
          projects: projectId

        # todo: error handling

      frameIndex = 0

      GifExplode.Do gif.createReadStream('gifs'), (frame) ->
        _frameIndex = frameIndex
        frameIndex += 1
        fsFrame = new FS.File()
        fsFrame.attachData(frame, { type: 'image/gif' })
        fsFrame.name(Meteor.uuid() + ".gif")
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
