# author: Ethosa

type
  MouseMode* {.size: sizeof(int8).} = enum
    MOUSEMODE_IGNORE = 0x00000001
    MOUSEMODE_SEE = 0x00000002
  PauseMode* {.size: sizeof(int8).} = enum
    PROCESS, PAUSE, INHERIT
  TextureMode* {.size: sizeof(int8).} = enum
    TEXTURE_FULL_SIZE,
    TEXTURE_KEEP_ASPECT_RATIO,
    TEXTURE_CROP
