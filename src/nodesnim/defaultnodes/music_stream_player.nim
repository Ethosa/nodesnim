# author: Ethosa
import sdl2/mixer
import node
{.used.}


discard mixer.openAudio(22050, MIX_DEFAULT_FORMAT, 2, 4096)


type
  MusicStreamPlayerObj* = object of NodeObj
    loop*: bool
    stream*: ptr Music
  MusicStreamPlayerPtr* = ptr MusicStreamPlayerObj


proc MusicStreamPlayer*(name: string = "MusicStreamPlayer", variable: var MusicStreamPlayerObj): MusicStreamPlayerPtr =
  nodepattern(MusicStreamPlayerObj)
  variable.loop = false

proc MusicStreamPlayer*(variable: var MusicStreamPlayerObj): MusicStreamPlayerPtr {.inline.} =
  MusicStreamPlayer("Node", variable)

method is_playing*(audio: MusicStreamPlayerPtr): bool {.base.} =
  ## Returns true, if music is playing.
  if playingMusic() == 1: true else: false

method is_paused*(audio: MusicStreamPlayerPtr): bool {.base.} =
  ## Returns true, if music is paused.
  if pausedMusic() == 1: true else: false


method load*(audio: MusicStreamPlayerPtr, file: cstring): void {.base.} =
  ## Loads audio from file
  ## OGG, WAV, MP3, etc.
  audio.stream = loadMUS(file)

method play*(audio: MusicStreamPlayerPtr, position: cdouble = 0.0): void {.base.} =
  ## Plays stream from position.
  discard audio.stream.playMusic(if audio.loop: 1 else: 0)
  discard setMusicPosition(position)

method pause*(audio: MusicStreamPlayerPtr): void {.base.} =
  ## Pauses music.
  pauseMusic()

method resume*(audio: MusicStreamPlayerPtr): void {.base.} =
  ## Resumes music, if need.
  if audio.is_paused():
    resumeMusic()

method setVolume*(audio: MusicStreamPlayerPtr, volume: cint): void {.base.} =
  ## Changes music volume
  discard volumeMusic(volume)
