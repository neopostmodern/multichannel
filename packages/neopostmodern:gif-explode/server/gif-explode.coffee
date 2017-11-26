# import gifExplode from './gif-explode-package'
Fiber = Npm.require 'fibers'
GifExplode =
  Do: (fileStream, callback) ->
    index = 0
    fileStream
      .pipe createStream (frame) ->
        index += 1
        # http://stackoverflow.com/a/18541825/2525299
        Fiber(->
          callback frame
        ).run()
    return
