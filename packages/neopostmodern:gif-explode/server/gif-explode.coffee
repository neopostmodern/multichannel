gifExplode = Npm.require 'gif-explode'
fileSystem = Npm.require 'fs'
Fiber = Npm.require 'fibers'
GifExplode =
  Do: (fileStream, callback) ->
    index = 0
    fileStream
      .pipe gifExplode (frame) ->
        index += 1
        # http://stackoverflow.com/a/18541825/2525299
        Fiber(->
          callback frame
        ).run()
    return
