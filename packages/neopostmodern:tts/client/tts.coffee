VOICE_RSS_KEY = "3becbf8460584fd5959554a73ed38790"

# todo: support other locales

TTS =
  isSupported: -> window.speechSynthesis? and window.speechSynthesis.getVoices().length > 0
  speak: (text) ->
    voice = window.speechSynthesis.getVoices().filter((v) -> v.lang.toLowerCase() == "en-us")[0]
    if not voice?
      # if no en-US take any English
      voice = window.speechSynthesis.getVoices().filter((v) -> v.lang.startsWith("en"))[0]
    if not voice?
      # or otherwise let's try anything
      voice = window.speechSynthesis.getVoices()[0]
      return

    utterance = new SpeechSynthesisUtterance(text)
    utterance.voice = voice
    window.speechSynthesis.speak(utterance)

# https://github.com/AnthonyAstige/tts/blob/master/tts.js
#    uu.pitch = 1;
#    uu.rate = 0.8;
#    uu.voiceURI = 'native';
#    uu.volume = 1;
#    window.speechSynthesis.cancel();

  generateFallbackAudioUrl: (text) ->
    "https://api.voicerss.org/" +
      "?src=" + text.replace(new RegExp(" ", 'g'), '+') +
      "&key=" + VOICE_RSS_KEY +
      "&hl=" + "en-us"
