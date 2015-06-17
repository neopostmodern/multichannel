@UploadRouteController = RouteController.extend(
  template: 'upload'
  layoutTemplate: 'default_layout'
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

    Gifs.insert file, (error, fileObj) ->
      # Inserted new doc with ID fileObj._id, and kicked off the data upload using HTTP

      if error?
        Materialize.toast error, 4000, "red"
        return

      uploadTracker = Tracker.autorun ->
        reactiveFileObj = Gifs.findOne fileObj._id

        if reactiveFileObj.isUploaded()
          uploadTracker.stop()

          Meteor.call 'multichannel.initialize-project', { fileId: fileObj._id }, (error, result) ->
            if error?
              Materialize.toast error, 4000, "red"
              state.set 'status', 'default'
              return

            Materialize.toast "Successfully created project", 2000
            Router.go 'home'
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