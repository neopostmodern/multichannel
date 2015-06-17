UI.registerHelper 'imgsrc', (image) ->
  imageObject = image
  if (typeof image is 'string') or image instanceof String
    imageObject = Gifs.findOne image

  return imageObject.url()