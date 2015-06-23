Meteor.methods
  'mc.like': (projectId) ->
    userId = Meteor.userId()
    if not userId?
      throw new Meteor.Error 401, "Log in to like a multichannel"

    user = Meteor.users.findOne userId
    if user.likes.indexOf(projectId) isnt -1
      throw new Meteor.Error 404, "You already liked this multichannel"

    # todo: make transaction based
    Meteor.users.update _id: userId,
      $push:
        likes: projectId
      (error, result) ->
        if error?
          throw new Meteor.Error 500, error

        Projects.update _id: projectId,
          $inc:
            likes: 1
          (error, result) ->
            if error?
              throw new Meteor.Error 500, error




  'mc.unlike': (projectId) ->
    userId = Meteor.userId()
    if not userId?
      throw new Meteor.Error 401, "Log in to unlike a multichannel"

    user = Meteor.users.findOne userId
    if user.likes.indexOf(projectId) is -1
      throw new Meteor.Error 404, "You haven't liked this multichannel"

    # todo: make transaction based
    Meteor.users.update _id: userId,
      $pull:
        likes: projectId
      (error, result) ->
        if error?
          throw new Meteor.Error 500, error

        Projects.update _id: projectId,
          $inc:
            likes: -1
          (error, result) ->
            if error?
              throw new Meteor.Error 500, error
