if Meteor.isClient
  share.CalculateReelHeight = (mayReload) ->
    reelHeight = $('.mc-show-reel').height() / 2

    if reelHeight is 0 # hack: chrome fix if no images are displayed
      if mayReload
        window.location.reload()
      else
        Meteor.setTimeout(
          -> share.CalculateReelHeight(true)
        , 2000)

    Router.current().state.set 'reelHeight', reelHeight

  Template.show.onRendered share.CalculateReelHeight

  $(window).resize share.CalculateReelHeight