if Meteor.isClient
  Template.home.onRendered ->
    @$('ul.tabs').tabs()

  Template.home.events(
    'click li.tab a': (event, template) ->
      currentLocation = window.location.href.split('#')[0]
      Router.go(currentLocation + event.currentTarget.hash)
  )