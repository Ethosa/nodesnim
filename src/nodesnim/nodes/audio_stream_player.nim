# author: Ethosa
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
  nodepattern(AudioStreamPlayerObj)
  variable.pausemode = PAUSE
  variable.paused = false
  variable.volume = 64

proc AudioStreamPlayer*(variable: var AudioStreamPlayerObj): AudioStreamPlayerPtr {.inline.} =
  AudioStreamPlayer("AudioStreamPlayer", variable)


method pause*(self: AudioStreamPlayerPtr) {.base.} =
  if playing(self.stream.channel) > -1:
    pause(self.stream.channel)

method play*(self: AudioStreamPlayerPtr) {.base.} =
  discard playChannel(
    self.stream.channel, self.stream.chunk,
    if self.stream.loop: -1 else: 1
  )

method resume*(self: AudioStreamPlayerPtr) {.base.} =
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
