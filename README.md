<h1 align="center">Nodesnim</h1>
<div align="center">The Nim GUI/2D framework using SDL2.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/nodesnim)](https://github.com/Ethosa/nodesnim/blob/master/LICENSE)

<h4>Latest version - 0.0.1</h4>
<h4>Stable version - 0.0.1</h4>
</div>

# Install
1. Install library
   -  `nimble install https://github.com/Ethosa/nodesnim.git`
2. Install dependencies
   -  SDL2: `nimble install sdl2`
3. Download DLLs for your OS
   -  [SDL2](https://www.libsdl.org/download-2.0.php)
   -  [SDL2_image](https://www.libsdl.org/tmp/SDL_image)
   -  [SDL2_ttf](https://www.libsdl.org/projects/SDL_ttf)
   -  [SDL2_mixer](https://www.libsdl.org/tmp/SDL_mixer/)
   -  SDL2_gfx
      -  [dll for windows x64](https://github.com/Ethosa/yukiko/blob/master/sdl_bin/windows_x64/SDL2_gfx.dll)
      -  [manual assembly](http://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/)
4. Put DLLs in the `.nimble/bin/` folder

# Features
- Godot-like node system.
- All operations with changing coordinates use `float` instead of `int`, e.g. ```node.move(17.98278, 0.87127)```

# F.A.Q
*Q*: Where I can see examples?  
*A*: You can see this in the [`tests`](https://github.com/Ethosa/nodesnim/blob/master/tests) folder


<div align="center">
  Copyright 2020 Ethosa
</div>
