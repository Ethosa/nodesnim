<h1 align="center">Nodesnim</h1>
<div align="center">The Nim GUI/2D framework based on OpenGL and SDL2.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/nodesnim)](https://github.com/Ethosa/nodesnim/blob/master/LICENSE)
[![time tracker](https://wakatime.com/badge/github/Ethosa/nodesnim.svg)](https://wakatime.com/badge/github/Ethosa/nodesnim)
[![test](https://github.com/Ethosa/nodesnim/workflows/test/badge.svg)](https://github.com/Ethosa/nodesnim/actions)

<h4>Latest version - 0.0.2</h4>
<h4>Stable version - 0.0.1</h4>
</div>

## Install
1. Install this repo
   -  `nimble install nodesnim` or `nimble install https://github.com/Ethosa/nodesnim.git`
2. Download OpenGL, SDL2_image, SDL2_mixer and freeglut Runtime binaries for your OS
   -  [SDL2](https://www.libsdl.org/download-2.0.php)
   -  [SDL2_image](https://www.libsdl.org/projects/SDL_image/)
   -  [SDL2_mixer](https://www.libsdl.org/projects/SDL_mixer/)
3. Put Runtime binaries in the `.nimble/bin/` folder

## Features
- Godot-like node system.

<details>
  <summary>Now available</summary>

-  Core
   -  [Anchor](https://ethosa.github.io/nodesnim/nodesnim/core/anchor.html)
   -  [Color](https://ethosa.github.io/nodesnim/nodesnim/core/color.html)
   -  [ColorText](https://ethosa.github.io/nodesnim/nodesnim/core/color_text.html)
   -  [Enums](https://ethosa.github.io/nodesnim/nodesnim/core/enums.html)
   -  [Exceptions](https://ethosa.github.io/nodesnim/nodesnim/core/exceptions.html)
   -  [Image](https://ethosa.github.io/nodesnim/nodesnim/core/image.html)
   -  [Input](https://ethosa.github.io/nodesnim/nodesnim/core/input.html)
   -  [Rect2](https://ethosa.github.io/nodesnim/nodesnim/core/rect2.html)
   -  [Vector2](https://ethosa.github.io/nodesnim/nodesnim/core/vector2.html)
   -  [Circle2](https://ethosa.github.io/nodesnim/nodesnim/core/circle2.html)
   -  [Polygon2](https://ethosa.github.io/nodesnim/nodesnim/core/polygon2.html)
   -  [AudioStream](https://ethosa.github.io/nodesnim/nodesnim/core/audio_stream.html)
   -  [Animation](https://ethosa.github.io/nodesnim/nodesnim/core/animation.html)
-  Default nodes
   -  [Node](https://ethosa.github.io/nodesnim/nodesnim/nodes/node.html)
   -  [Canvas](https://ethosa.github.io/nodesnim/nodesnim/nodes/canvas.html)
   -  [Scene](https://ethosa.github.io/nodesnim/nodesnim/nodes/scene.html)
   -  [AudioStreamPlayer](https://ethosa.github.io/nodesnim/nodesnim/nodes/audio_stream_player.html)
-  Control nodes
   -  [Control](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/control.html)
   -  [ColorRect](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/color_rect.html)
   -  [TextureRect](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_rect.html)
   -  [Label](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/label.html)
   -  [Button](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/button.html)
   -  [EditText](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/edittext.html)
   -  [RichLabel](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/rich_label.html)
   -  [RichEditText](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/rich_edit_text.html)
   -  [Box](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/box.html)
   -  [HBox](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/hbox.html)
   -  [VBox](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/vbox.html)
   -  [GridBox](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/grid_box.html)
   -  [Scroll](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/scroll.html)
   -  [ProgressBar](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/progress_bar.html)
   -  [Slider](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/slider.html)
   -  [VProgressBar](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/vprogress_bar.html)
   -  [VSlider](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/vslider.html)
   -  [Popup](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/popup.html)
   -  [TextureButton](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_button.html)
   -  [TextureProgressBar](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_progress_bar.html)
   -  [Counter](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/counter.html)
   -  [Switch](https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/switch.html)
-  2D nodes
   -  [Node2D](https://ethosa.github.io/nodesnim/nodesnim/nodes2d/node2d.html)
   -  [Sprite](https://ethosa.github.io/nodesnim/nodesnim/nodes2d/sprite.html)
   -  [AnimatedSprite](https://ethosa.github.io/nodesnim/nodesnim/nodes2d/animated_sprite.html)
   -  [YSort](https://ethosa.github.io/nodesnim/nodesnim/nodes2d/ysort.html)
   -  [CollisionShape2D](https://ethosa.github.io/nodesnim/nodesnim/nodes2d/collision_shape2d.html)
   -  [KinematicBody2D](https://ethosa.github.io/nodesnim/nodesnim/nodes2d/kinematic_body2d.html)

</details>

## Debug mode
For use debug mode you should compile with `-d:debug` or `--define:debug`, e.g. `nim c -r -d:debug main.nim`.

## Export
Use the [`Nim compiler user guide`](https://nim-lang.org/docs/nimc.html#dynliboverride) for export to the other OS.

-   CrossPlatform export for Windows (tested on Windows 7 x64 and Windows 10 x64)
    -   `nim c -d:mingw -d:release --opt:speed --noNimblePath file.nim`
    -   put Runtime binaries in the folder with the program.


## F.A.Q
*Q*: Where I can see examples?  
*A*: You can see this in the [`tests`](https://github.com/Ethosa/nodesnim/blob/master/tests) or [`examples`](https://github.com/Ethosa/nodesnim/blob/master/examples) folder.

*Q*: Where I can read the docs?  
*A*: You can read docs [here](https://ethosa.github.io/nodesnim/nodesnim.html)

<div align="center">
  Copyright 2020 Ethosa
</div>
