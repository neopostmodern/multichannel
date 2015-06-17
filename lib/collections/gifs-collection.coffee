@Gifs =  new FS.Collection("gifs", {
  stores: [ new FS.Store.FileSystem("gifs", {  }) ] # hack: no idea where this is stored
})