gifExplode = Npm.require 'gif-explode'
fileSystem = Npm.require 'fs'
Fiber = Npm.require 'fibers'
GifExplode =
  Do: (filePath, callback) ->
    index = 0
    fileSystem.createReadStream filePath
      .pipe gifExplode (frame) ->
        index += 1
#        console.log "Resolving '.'", fileSystem.realpathSync('.')
        Fiber(->
          callback frame
        ).run()
#        frame.pipe fileSystem.createWriteStream "./gif-test-frame-#{ index }.gif"
    return