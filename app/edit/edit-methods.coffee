Meteor.methods(
  'mc.edit.changeProjectName': (projectId, newName) ->
    user = Meteor.user()
    if not user?
      throw new Meteor.Error 401, "Log in to edit this multichannel"

    if user.projects.indexOf(projectId) is -1
      throw new Meteor.Error 403, "You can't edit this multichannel (It's not yours)"

    Projects.update(_id: projectId,
      $set:
        name: newName
    )
  'mc.edit.changeFrameName': (projectId, frameIndex, newName) ->
    user = Meteor.user()
    if not user?
      throw new Meteor.Error 401, "Log in to edit this multichannel"

    if user.projects.indexOf(projectId) is -1
      throw new Meteor.Error 403, "You can't edit this multichannel (It's not yours)"

    updateFrameNameQuery = {}
    updateFrameNameQuery["frames.#{ frameIndex }.text"] = newName

    Projects.update(_id: projectId,
      $set: updateFrameNameQuery
    )
)