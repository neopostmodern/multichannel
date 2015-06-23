Meteor.methods
  'mc.deleteProject': (projectId) ->
    removeFrames = ->
      gifIds = project.frames.map (frame) -> frame.gif
      Gifs.remove _id: $in: gifIds,
      (error) ->
        if error?
          throw new Meteor.Error "Delete failed: " + error
        else
          removeProject()

    removeProject = ->
      Projects.remove _id: projectId,
        (error) ->
          if error?
            throw new Meteor.Error "Delete failed: " + error

    if not @userId?
      throw new Meteor.Error 401, "Please log in to delete a multichannel"

    project = Projects.findOne projectId

    if @userId isnt project.userId
      throw new Meteor.Error 403, "You can't delete other people's multichannels"

    Gifs.remove _id: project.originalGif,
      (error) ->
        if error?
          throw new Meteor.Error "Delete failed: " + error
        else
          removeFrames()




