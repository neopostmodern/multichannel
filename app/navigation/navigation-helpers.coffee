if Meteor.isClient
  Template.navigation.helpers(
    isActiveRoute: (routeName) -> Router.current().route.getName() is routeName
    routes: -> share.RoutesInMenu
  )