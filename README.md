# AK5SampleRateFail
Project demonstrating AK5 failing to set sample rate

1) Start AudioEngine
2) Ensure playback works
3) stop engine
4) Set Settings.sampleRate to 48000
5) start engine

Engine start fails

Anecdotal evidence I've noticed (mostly in context of auv3):

 - if host sampleRate changes, and you do nothing to AK, sampler plays out of tune
 - if host sampleRate changes, and you do nothing to AK, receiving notes from host sequencer drops notes (i believe this is because if host sampleRate is 48000 and bufferSize is 256, ak sampleRate still is 44100 and bufferSize becomes 235... notice how 44100/48000 ~= 235/256)
 - if you try to set ak/Settings.sampleRate, engine will no longer start
 - if using an auv3 for audio processing (like an effect), the same bufferSize mismatch occurs and causes all sorts of audio glitches (256 vs 235 frames per buffer)
