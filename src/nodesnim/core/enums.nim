# author: Ethosa

type
  MouseMode* {.size: sizeof(int8).} = enum
    MOUSEMODE_IGNORE = 0x00000001  ## Igore mouse input. This used in Control nodes
    MOUSEMODE_SEE = 0x00000002     ## Handle mouse input.
  PauseMode* {.size: sizeof(int8).} = enum
    PROCESS,  ## Continue to work when the window paused.
    PAUSE,    ## Pause work when the window paused.
    INHERIT   ## Take parent value.
  TextureMode* {.size: sizeof(int8).} = enum
    TEXTURE_FILL_XY,            ## Fill texture without keeping the aspect ratio.
    TEXTURE_KEEP_ASPECT_RATIO,  ## Fill texture with keeping the aspect ratio.
    TEXTURE_CROP                ## Crop and fill texture.
