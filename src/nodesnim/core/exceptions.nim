# author: Ethosa

type
  ResourceError* {.size: sizeof(int8).} = object of ValueError
  SceneError* {.size: sizeof(int8).} = object of ValueError
  WindowError* {.size: sizeof(int8).} = object of ValueError
