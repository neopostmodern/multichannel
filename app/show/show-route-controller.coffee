MAX_REEL_COUNT = 10
INITIAL_REEL_COUNT = 4

INTERVAL = 50

SPEED_MIN = 0.001 / INTERVAL
SPEED_MAX = 0.5 / INTERVAL
SPEED_MED = (SPEED_MIN + SPEED_MAX) / 2
SPEED_INC = (SPEED_MAX - SPEED_MIN) / MAX_REEL_COUNT

Reels = ({index: iterator, position: 0} for iterator in [0...INITIAL_REEL_COUNT])

share.UnifiedFullscreen =
  RequestFor: (element) ->
    if element.requestFullscreen
      element.requestFullscreen()
    else if element.msRequestFullscreen
      element.msRequestFullscreen()
    else if element.mozRequestFullScreen
      element.mozRequestFullScreen()
    else if element.webkitRequestFullscreen
      element.webkitRequestFullscreen()
    else
      alert "Browser doesn't support fullscreen"
  Exit: ->
    if document.exitFullscreen
      document.exitFullscreen()
    else if document.msExitFullscreen
      document.msExitFullscreen()
    else if document.mozCancelFullScreen
      document.mozCancelFullScreen()
    else if document.webkitExitFullscreen
      document.webkitExitFullscreen()
  AddEventListener: (fn) ->
    $(document).on('webkitfullscreenchange mozfullscreenchange fullscreenchange MSFullscreenChange', fn);



@ShowRouteController = RouteController.extend(
  template: 'show'
  action: ->
    @state.set 'isAnimatedGifVisible', true
    @state.set 'isDescriptionVisible', true
    @state.set 'isAudioEnabled', true
    @state.set 'isPlaying', true

    @state.set 'reelCount', INITIAL_REEL_COUNT

    Tracker.autorun =>
      newReelCount = @state.get 'reelCount'
      if Reels.length < newReelCount
        Reels.push(position: Reels[Reels.length - 1].position) # insert new with position of last
      if Reels.length > newReelCount
        Reels.pop()

      Meteor.setTimeout share.CalculateReelHeight, 50 # hack: wait for dom propagation

    Meteor.setInterval(=>
      if @state.get 'isPlaying'
        @state.set 'tick', not @state.get 'tick'
    , INTERVAL)

    share.UnifiedFullscreen.AddEventListener =>
      @state.set 'isFullscreen', not @state.get 'isFullscreen'

    @render()

  waitOn: -> [
    Meteor.subscribe 'mc.projects'
    Meteor.subscribe 'mc.gifs'
  ]
  data: ->
    project = Projects.findOne @params._id

    if project? # implicitly wait for project to load...
      project.frames.reverse() # todo: is this safe to do? it operates in place!
      document.title = "Multichannel: #{ project.name }"

    return {
      project: project
    }
)

_stateToggle = (stateName) ->
  (event, template, data) ->
    currentState = @state.get stateName
    @state.set stateName, not currentState

ShowRouteController.events(
  'click #mc-show-toggle-animated-gif-visible': _stateToggle 'isAnimatedGifVisible'
  'click #mc-show-toggle-description-visible': _stateToggle 'isDescriptionVisible'
  'click #mc-show-toggle-playing': _stateToggle 'isPlaying'
  'click #mc-show-toggle-audio-enabled': _stateToggle 'isAudioEnabled'

  'click #mc-show-toggle-fullscreen': (event, template, data) ->
    isCurrentlyFullscreen = @state.get 'isFullscreen'
    if not isCurrentlyFullscreen
      share.UnifiedFullscreen.RequestFor(document.getElementById 'mc-show')
    else
      share.UnifiedFullscreen.Exit()

    #_stateToggle 'isAudioEnabled'

  'click #mc-show-remove-channel': (event, template, data) ->
    if Reels.length <= 1
      return

    @state.set 'reelCount', Reels.length - 1
  'click #mc-show-add-channel': (event, template, data) ->
    if Reels.length >= MAX_REEL_COUNT
      return

    @state.set 'reelCount', Reels.length + 1

  'mouseover .mc-show-frame-wrapper': (event, template, data) ->
    if data.text? and data.text.length > 0
      if @state.get 'isAudioEnabled'
        document.getElementById "mc-show-audio-#{ data.gif }"
          .play()
)

ShowRouteController.helpers(
  isAnimatedGifVisible: -> @state.get 'isAnimatedGifVisible'
  isDescriptionVisible: -> @state.get 'isDescriptionVisible'
  isPlaying: -> @state.get 'isPlaying'
  isAudioEnabled: -> @state.get 'isAudioEnabled'
  isFullscreen: -> @state.get 'isFullscreen'

  reels: -> _.range @state.get('reelCount')
  isMaximumReels: -> Reels.length >= MAX_REEL_COUNT
  isMinimumReels: -> Reels.length <= 1

  dynamicOffset: (index) ->
    adjustedSpeed = (_index, reelCount) ->
      SPEED_MED - (_index - (reelCount - 1) / 2) * SPEED_INC

    @state.get 'tick' # todo: weird way to update this I guess

    reel = Reels[index]
    reel.position = (reel.position + adjustedSpeed(index, Reels.length)) % 1

#    if index is 0
#      console.log(
#        reel.position.toFixed(2),
#        (2 - reel.position).toFixed(2),
#        @state.get('reelHeight')?.toFixed(2),
#        (2 * @state.get('reelHeight') - window.innerHeight).toFixed(2), # confirmed as perfect bottom align
##        ((2 - reel.position) * @state.get('reelHeight')).toFixed(2),
#        ((2 - reel.position) * @state.get('reelHeight') - window.innerHeight).toFixed(2),
#        (@state.get('reelHeight') - window.innerHeight).toFixed(2)
#      )

    return (2 - reel.position) * @state.get('reelHeight') - window.innerHeight

  isNotEmpty: (text) ->
    text? and text.length > 0
  mc_show_textToSpeechSrc: (text) ->
    "http://tts-api.com/tts.mp3?q=" + text.replace(new RegExp(" ", 'g'), '+')
)

Router.route 'show',
  path: '/show/:_id'
  controller: 'ShowRouteController'