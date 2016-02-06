UI.registerHelper 'imgsrc', (image) ->
  imageObject = image
  if (typeof image is 'string') or image instanceof String
    imageObject = Gifs.findOne image

  return imageObject.url()

UI.registerHelper 'materialHelper', (text) ->
  if text? and text.length? then " active " else ""

UI.registerHelper 'noSpeechSynthesis', () ->
  not TTS.isSupported()