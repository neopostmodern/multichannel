@EditRouteController = RouteController.extend(
  template: 'edit'
  layoutTemplate: 'default_layout'
  data: ->
    project: Projects.findOne @params._id
)

Router.route 'edit',
  path: '/edit/:_id'
  controller: 'EditRouteController'