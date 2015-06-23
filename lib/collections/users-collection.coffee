Meteor.users.deny(
  update: -> true # fix possibility to modify 'profile'
)

if Meteor.isServer
  Meteor.publish 'mc.currentUser', ->
    Meteor.users.find _id: @userId,
      fields:
        projects: 1
        likes: 1
        profile: 1

  Accounts.onCreateUser (options, user) ->
    user.profile = options.profile # todo: add schema checks
    user.likes = []
    user.projects = []
    return user