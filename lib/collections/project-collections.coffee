@Projects = new Meteor.Collection 'projects'

if Meteor.isServer
  # todo: think about subscribing to a single project
  Meteor.publish 'mc.projects', -> Projects.find {}