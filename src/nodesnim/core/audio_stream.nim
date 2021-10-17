# author: Ethosa
import
  ../thirdparty/sdl2,
  ../thirdparty/sdl2/mixer


discard mixer.init(MIX_INIT_OGG)
discard mixer.openAudio(44100, MIX_DEFAULT_FORMAT, 2, 1024)

type
  AudioStreamRef* = ref object of RootObj
    chunk*: ptr Chunk
    channel*: cint
    loop*: bool

var
  channel_num: cint = 2
  current_channel: cint = 0


proc loadAudio*(file: cstring, loop: bool = true): AudioStreamRef =
  ## Loads a new AudioStream from file.
  ##
  ## Arguments:
  ## - `file` is the audio path.
  inc current_channel
  if current_channel == channel_num:
    channel_num *= 2
    discard allocateChannels(channel_num)
  AudioStreamRef(chunk: loadWAV(file), channel: current_channel, loop: loop)
