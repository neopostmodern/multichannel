if Meteor.isClient
  Template.upload.onRendered ->
    if not Meteor.userId()?
      share.RequestUserLogIn()