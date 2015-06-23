GifStorage = new FS.Store.GridFS("gifs")

@Gifs =  new FS.Collection("gifs", {
  stores: [ GifStorage ]
# todo: filtering doesn't seem to work with streams
#  filter:
#    maxSize: 2 * 1024 * 1024 # 2MB
#    allow:
#      contentTypes: ['image/gif']
#    onInvalid: (message) ->
#      if Meteor.isClient
#        Materialize.toast message, 4000, "red"
#      else
#        console.log message
})

Gifs.allow(
  insert: (userId, fileObject) -> userId?
  download: (userId, fileObject) -> true
)

if Meteor.isServer
  # todo: think about subscribing to a single project
  Meteor.publish 'mc.gifs', -> Gifs.find {}