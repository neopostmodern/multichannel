Package.describe({
  name: "neopostmodern:gif-explode",
  summary: "",
  version: "0.1.0",
  git: "https://github.com/neopostmodern/meteor-gif-explode"
});

Package.onUse(function(api) {
  api.versionsFrom("1.0.1");
  api.use("coffeescript");
  api.use(["meteor", "ddp", "jquery"]);

  Npm.depends({
    "fibers": "2.0.0",
    "graceful-fs": "4.1.1",
    "rimraf": "2.2.6",
    "tmp": "0.0.33",
    "streamify": "0.3.0",
    "gifsicle": "3.0.4",
    "async": "2.6.0"
  });

  api.export("GifExplode");
  api.addFiles("server/gif-explode.coffee", "server");
});

Package.onTest(function (api) {
  api.use("tinytest");
  api.use("coffeescript");
  api.use("neopostmodern:gif-explode");

  api.addFiles("tests/server/index.coffee", "server");

}); 