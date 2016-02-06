Package.describe({
  name: "neopostmodern:tts",
  summary: "",
  version: "0.1.0"
//  git: "https://github.com/neopostmodern/meteor-tts"
});

Package.onUse(function(api) {
  api.versionsFrom("1.0.1");
  api.use("coffeescript");
  api.use(["meteor"]);

  api.export("TTS");
  api.addFiles("client/tts.coffee", "client");
});