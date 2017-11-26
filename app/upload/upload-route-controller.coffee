@UploadRouteController = RouteController.extend(
  template: 'upload'
  layoutTemplate: 'default_layout'

  # hack: what are these subscriptions, really?
  waitOn: -> [
    Meteor.subscribe 'mc.projects'
    Meteor.subscribe 'mc.gifs'
  ]
)

UploadRouteController.events(
  # this seems to be REALLY important to make the area a drop target:
  # https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Drag_operations#droptargets
  'dragover #upload': (event) ->
    event.preventDefault()

  'dragenter #upload': (event) ->
    @state.set 'status', 'hover'

  'dragleave #upload': (event) ->
    @state.set 'status', 'default'

  'drop #upload': (event, template) ->
    event.stopPropagation()
    event.preventDefault()

    @state.set 'status', 'processing'

    dataTransfer = event.dataTransfer ? event.originalEvent.dataTransfer

    file = dataTransfer.files[0]

    if dataTransfer.files.length > 1
      Materialize.toast "Only uploading '#{ file.name }'", 4000, "red"

    if file.type isnt "image/gif"
      Materialize.toast "That wasn't a .GIF", 4000, "red"
      @state.set 'status', 'default'
      return

    state = @state

    Gifs.insert(
      file: file
      streams: 'dynamic'
      chunkSize: 'dynamic'
    , false)
      .on 'end', (error, fileObj) ->
        # Inserted new doc with ID fileObj._id

        if error?
          Materialize.toast error, 4000, "red"
          state.set 'status', 'default'
          return

        Meteor.call 'multichannel.initialize-project', { fileId: fileObj._id }, (error, result) ->
          if error?
            Materialize.toast error, 4000, "red"
            state.set 'status', 'default'
            return

          Materialize.toast "Successfully created project", 2000
          Router.go 'home'
      .start()
)

UploadRouteController.helpers(
  isStatus: (status) ->
    storedStatus = @state.get 'status'
    if status is 'default' and not storedStatus?
      return true
    return status is storedStatus
)

Router.route 'upload',
  path: 'upload'
  controller: 'UploadRouteController'