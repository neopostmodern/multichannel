@HomeRouteController = RouteController.extend(
  template: 'home'
  layoutTemplate: 'default_layout'
  data: ->
    projects: Projects.find()
)

Router.route 'home',
  path: '/'
  controller: 'HomeRouteController'