#if Meteor.isClient
##  Template.upload.onRendered ->
##    $('#upload').on 'dragover', (event) ->
##      event.preventDefault()
#
#  Template.upload.events(
##    # this seems to be REALLY important to make the area a drop target:
##    # https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Drag_operations#droptargets
##    'dragover #upload': (event) ->
##      event.preventDefault()
#
#    'dragenter #upload': (event) ->
#      # @state.set 'status', 'hover'
#      console.log 'dragenter'
#
#    'dragleave #upload': (event) ->
##      @state.set 'status', 'default'
#      console.log 'dragleave'
#  )