# author: Ethosa

type
  SceneError* {.size: sizeof(int8).} = object of ValueError
  WindowError* {.size: sizeof(int8).} = object of ValueError
