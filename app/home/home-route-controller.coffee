@HomeRouteController = RouteController.extend(
  template: 'home'
  layoutTemplate: 'default_layout'

  waitOn: -> [
    Meteor.subscribe 'mc.projects'
    Meteor.subscribe 'mc.gifs'
    Meteor.subscribe 'mc.currentUser'
  ]

  data: ->
    filter = @params.hash # todo: make reactive

    if filter not in ['your', 'likes', 'all']
      filter = 'trending'

    if not Meteor.userId()? and filter in ['your', 'likes']
      projects = []
    else
      query = switch filter
        when HomeRouteController.FILTERS.ALL then {}
        when HomeRouteController.FILTERS.TRENDING then {}
        when HomeRouteController.FILTERS.LIKES then _id: $in: Meteor.user().likes
        when HomeRouteController.FILTERS.YOUR then _id: $in: Meteor.user().projects

      projects = Projects.find query

    return {
      projects: projects
    }
)

HomeRouteController.FILTERS =
  ALL: 'all'
  TRENDING: 'trending'
  YOUR: 'your'
  LIKES: 'likes'

HomeRouteController.events(
  'click .mc-home-like': (event, template, data) ->
    user = Meteor.user()
    projectId = data._id

    if user?
      hasUserLikedProject = user.likes.indexOf(projectId) isnt -1

      if hasUserLikedProject
        Meteor.call('mc.unlike', projectId, (error, result) ->
          if error?
            console.dir error
            Materialize.toast error, 4000, "red"
            return
        )
      else
        Meteor.call('mc.like', projectId, (error, result) ->
          if error?
            Materialize.toast error, 4000, "red"
            return
        )
    else
      share.RequestUserLogIn()

  'click .mc-home-delete': (event, template, data) ->
    Meteor.call 'mc.deleteProject', data._id,
      (error, result) ->
        if error?
          Materialize.toast error, 4000, "red"
        else
          Materialize.toast "Successfully deleted '#{ data.name }'", 2000
)

HomeRouteController.helpers(
  userHasLiked: (projectId) ->
    user = Meteor.user()
    if not user?
      return false

    return user.likes.indexOf(projectId) isnt -1

  userOwnsProject: (projectId) ->
    user = Meteor.user()
    if not user?
      return false

    return user.projects.indexOf(projectId) isnt -1 # todo: make project.userId based?

)

Router.route 'home',
  path: '/'
  controller: 'HomeRouteController'