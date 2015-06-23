if Meteor.isClient
  share.CalculateReelHeight = ->
    reelHeight = $('.mc-show-reel').height() / 2

    if reelHeight is 0
      window.location.reload() # hack: chrome fix if no images are displayed

    Router.current().state.set 'reelHeight', reelHeight

  Template.show.onRendered share.CalculateReelHeight

  $(window).resize share.CalculateReelHeight