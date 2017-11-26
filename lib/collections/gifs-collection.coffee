import { FilesCollection } from 'meteor/ostrio:files'

@Gifs =  new FilesCollection({
  collectionName: "gifs"
  allowClientCode: false
  storagePath: Meteor.settings.storage?.gifs
  onBeforeUpload: (file) ->
    if file.size >= 1024 * 1024 * 5 # 5MB
      "Only files smaller than 5MB, sorry."
    else if not /gif/i.test(file.extension)
      "Only GIFs, obviously."
    else
      true
})

#Gifs.allow(
#  insert: (userId, fileObject) -> userId?
#  download: (userId, fileObject) -> true
#)

if Meteor.isServer
  Gifs.denyClient()

  # todo: think about subscribing to a single project
  Meteor.publish 'mc.gifs', -> Gifs.find().cursor