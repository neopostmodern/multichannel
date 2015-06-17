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
    "gif-explode": "0.0.1",
    "fibers": "1.0.5"
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