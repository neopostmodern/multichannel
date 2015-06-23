if Meteor.isClient
  Template.navigation.helpers(
    isActiveRoute: (routeName) -> Router.current().route.getName() is routeName
    routes: -> share.RoutesInMenu
  )

  Template.navigation.events(
    'click #mc-login-logout': (event, template) ->
      event.preventDefault()
      Meteor.logout() # todo: error handling?
  )

  Template.navigation.onRendered ->
    $('.modal-trigger').leanModal()

  Template.login_button.onRendered ->
    $(".dropdown-button").dropdown()

  share.RequestUserLogIn = ->
    console.log 'userlogin requested'
    $('#login-modal').openModal()
