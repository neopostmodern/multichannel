// copied from https://raw.githubusercontent.com/hughsk/gif-explode/master/index.js

var spawn = require('child_process').spawn
var gifsicle = require('gifsicle')
var streamify = require('streamify')
var fs = require('graceful-fs')
var path = require('path')

export default function explodeGif(targetFolder, frameCreated) {
  let stream = streamify()

  let ps = spawn(gifsicle, [
    '--unoptimize'
    , '--explode'
  ], {
    cwd: targetFolder
    , env: {}
  })

  stream.resolve(ps.stdin)
  ps.once('exit', function(code) {
    fs.readdir(targetFolder, handleFiles)
  })

  function handleFiles(err, files) {
    if (err) {
      return stream.emit('error', err);
    }

    if (!files.length) return stream.emit('error', new Error(
      'No frames could be extracted from the supplied GIF. ' +
      'This could be because of a processing error, ' +
      'such as piping in a non-GIF buffer'
    ))

    files.forEach((fileName, index) => {
      let filePath = path.resolve(targetFolder, fileName);
      let renamedFilePath = path.resolve(targetFolder, Meteor.uuid() + '.gif')
      fs.rename(filePath, renamedFilePath, (error) => {
        if (error) {
          console.error(error);
        } else {
          frameCreated(renamedFilePath, index);
        }
      });
    })
  }

  return stream
}
