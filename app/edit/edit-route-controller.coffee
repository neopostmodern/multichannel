@EditRouteController = RouteController.extend(
  template: 'edit'
  layoutTemplate: 'default_layout'
  
  waitOn: -> [
    Meteor.subscribe 'mc.projects'
    Meteor.subscribe 'mc.gifs'
    Meteor.subscribe 'mc.currentUser'
  ]

  data: ->
    if @ready()
      user = Meteor.user()
      projectId = @params._id


      if not user?
        share.RequestUserLogIn()
        return error: "Please log in"

      if user.projects?.indexOf(projectId) is -1
        return error: "Not yours, sorry"

      return project: Projects.findOne projectId
)

EditRouteController.events(
  'change #mc-edit-project-name': (event, template) ->
    newName = template.find('#mc-edit-project-name').value
    Meteor.apply(
      'mc.edit.changeProjectName'
      [ @data().project._id, newName ]
      (error, result) ->
        if error?
          console.dir error
          return
    )
  'change .mc-edit-frame-name': (event, template, data) ->
    newName = event.currentTarget.value
    frameIndex = data.index

    Meteor.apply(
      'mc.edit.changeFrameName'
      [ @data().project._id, frameIndex, newName ]
      (error, result) ->
        if error?
          console.dir error
          return
    )
  'click .mc-edit-speak': (event, template, data) ->
    noSpeechSynthesisWarning = ->
      # todo: pass warning to UI
      alert("Your browser doesn't seem support speech synthesis.")

    if not window.speechSynthesis?
      noSpeechSynthesisWarning()
      return

    voice = window.speechSynthesis.getVoices().filter((v) => v.lang == "en-US")[0]
    if not voice?
      # if no en-US take any English
      window.speechSynthesis.getVoices().filter((v) => v.lang.startsWith("en"))[0]
    if not voice?
      noSpeechSynthesisWarning()
      console.warn("No voices for Speech Synthesis found.")
      return

    utterance = new SpeechSynthesisUtterance(data.text)
    utterance.voice = voice
    window.speechSynthesis.speak(utterance)
)

Router.route 'edit',
  path: '/edit/:_id'
  controller: 'EditRouteController'