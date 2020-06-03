# author: Ethosa
## AudioStreamPlayer used for playing audio.
## 
## AudioStream is responsible for audio. You can play multiple audio recordings at once.
import
  node,
  ../thirdparty/sdl2/mixer,
  ../core/enums,
  ../core/audio_stream


type
  AudioStreamPlayerObj* {.final.} = object of NodeObj
    paused*: bool
    volume*: cint
    stream*: AudioStreamRef
  AudioStreamPlayerPtr* = ptr AudioStreamPlayerObj


proc AudioStreamPlayer*(name: string, variable: var AudioStreamPlayerObj): AudioStreamPlayerPtr =
  ## Creates a new AudioStreamPlayer pointer.
  ##
  ## Arguments:
  ## - `name` is a node name.
  ## - `variable` is an AudioStreamPlayerObj variable
  runnableExamples:
    var
      audio_obj: AudioStreamPlayerObj
      audio = AudioStreamPlayer("AudioStreamPlayer", audio_obj)
  nodepattern(AudioStreamPlayerObj)
  variable.pausemode = PAUSE
  variable.paused = false
  variable.volume = 64
  variable.kind = AUDIO_STREAM_PLAYER_NODE

proc AudioStreamPlayer*(variable: var AudioStreamPlayerObj): AudioStreamPlayerPtr {.inline.} =
  ## Creates a new AudioStreamPlayer pointer width default name "AudioStreamPlayer".
  ##
  ## Arguments:
  ## - `variable` is an AudioStreamPlayerObj variable
  runnableExamples:
    var
      audio_obj:  AudioStreamPlayerObj
      audio =  AudioStreamPlayer(audio_obj)
  AudioStreamPlayer("AudioStreamPlayer", variable)


method duplicate*(self: AudioStreamPlayerPtr, obj: var AudioStreamPlayerObj): AudioStreamPlayerPtr {.base.} =
  ## Duplicates AudioStreamPlayer object and create a new AudioStreamPlayer pointer.
  obj = self[]
  obj.addr

method pause*(self: AudioStreamPlayerPtr) {.base.} =
  ## Pauses stream.
  if playing(self.stream.channel) > -1:
    pause(self.stream.channel)

method play*(self: AudioStreamPlayerPtr) {.base.} =
  ## Play stream.
  discard playChannel(
    self.stream.channel, self.stream.chunk,
    if self.stream.loop: -1 else: 1
  )

method resume*(self: AudioStreamPlayerPtr) {.base.} =
  ## Resume stream.
  if paused(self.stream.channel) > -1:
    resume(self.stream.channel)

method setVolume*(self: AudioStreamPlayerPtr, value: cint) {.base.} =
  ## Changes stream volume.
  ##
  ## Arguments:
  ## - `volume` is a number in range `0..128`.
  if value > 128:
    self.volume = 128
  elif value < 0:
    self.volume = 0
  else:
    self.volume = value
  discard volume(self.stream.channel, self.volume)
