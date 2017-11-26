import Fiber from 'fibers'
import explodeGif from './imports/gif-explode-npm'

GifExplode =
  Do: (fileStream, targetFolder, callback) ->
    index = 0
    fileStream
      .pipe explodeGif targetFolder, (frame) ->
        index += 1
        # http://stackoverflow.com/a/18541825/2525299
        Fiber(->
          callback frame
        ).run()
    return
