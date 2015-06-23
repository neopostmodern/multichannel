if Meteor.isClient
  loginWith = (loginFunction) ->
    (event, template) ->
      event.preventDefault()

      #      todo: indicate processing in UI

      loginFunction (error) ->
        if error?
          console.dir error #todo: proper error handling (to UI)
        else
          template.$('#login-modal').closeModal()
          Materialize.toast "Welcome #{ Meteor.user().profile.name }!", 2000


  Template.login.events(
    'click #mc-login-meteor': loginWith Meteor.loginWithMeteorDeveloperAccount
    'click #mc-login-twitter': loginWith Meteor.loginWithTwitter
    'click #mc-login-facebook': loginWith Meteor.loginWithFacebook
    'click #mc-login-google': loginWith Meteor.loginWithGoogle
  )