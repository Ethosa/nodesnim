<h1 align="center">Nodesnim</h1>
<div align="center">The Nim GUI/2D framework based on OpenGL and SDL2.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.png?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/nodesnim)](https://github.com/Ethosa/nodesnim/blob/master/LICENSE)
[![time tracker](https://wakatime.com/badge/github/Ethosa/nodesnim.svg)](https://wakatime.com/badge/github/Ethosa/nodesnim)

<h4>Latest version - 0.0.1</h4>
<h4>Stable version - 0.0.1</h4>
</div>

# Install
1. Install this repo
   -  `nimble install https://github.com/Ethosa/nodesnim.git`
2. Download OpenGL, SDL2_image, SDL2_mixer and GLUT Runtime binaries for your OS
   -  [SDL2](https://www.libsdl.org/download-2.0.php)
   -  [SDL2_image](https://www.libsdl.org/projects/SDL_image/)
   -  [SDL2_mixer](https://www.libsdl.org/projects/SDL_mixer/)
3. Put Runtime binaries in the `.nimble/bin/` folder

# Features
- Godot-like node system.

<details>
  <summary>Now available</summary>

-  Core
   -  [Anchor](https://ethosa.github.io/nodesnim/anchor.html)
   -  [Color](https://ethosa.github.io/nodesnim/color.html)
   -  [ColorText](https://ethosa.github.io/nodesnim/color_text.html)
   -  [Enums](https://ethosa.github.io/nodesnim/enums.html)
   -  [Exceptions](https://ethosa.github.io/nodesnim/exceptions.html)
   -  [Image](https://ethosa.github.io/nodesnim/image.html)
   -  [Input](https://ethosa.github.io/nodesnim/input.html)
   -  [Rect2](https://ethosa.github.io/nodesnim/rect2.html)
   -  [Vector2](https://ethosa.github.io/nodesnim/vector2.html)
   -  [AudioStream](https://ethosa.github.io/nodesnim/audio_stream.html)
-  Default nodes
   -  [Node](https://ethosa.github.io/nodesnim/node.html)
   -  [Canvas](https://ethosa.github.io/nodesnim/canvas.html)
   -  [Scene](https://ethosa.github.io/nodesnim/scene.html)
   -  [AudioStreamPlayer](https://ethosa.github.io/nodesnim/audio_stream_player.html)
-  Control nodes
   -  [Control](https://ethosa.github.io/nodesnim/control.html)
   -  [ColorRect](https://ethosa.github.io/nodesnim/color_rect.html)
   -  [TextureRect](https://ethosa.github.io/nodesnim/texture_rect.html)
   -  [Label](https://ethosa.github.io/nodesnim/label.html)
   -  [Button](https://ethosa.github.io/nodesnim/button.html)
   -  [EditText](https://ethosa.github.io/nodesnim/edittext.html)
   -  [RichLabel](https://ethosa.github.io/nodesnim/rich_label.html)
   -  [RichEditText](https://ethosa.github.io/nodesnim/rich_edit_text.html)
   -  [Box](https://ethosa.github.io/nodesnim/box.html)
   -  [HBox](https://ethosa.github.io/nodesnim/hbox.html)
   -  [VBox](https://ethosa.github.io/nodesnim/vbox.html)
   -  [GridBox](https://ethosa.github.io/nodesnim/grid_box.html)
   -  [Scroll](https://ethosa.github.io/nodesnim/scroll.html)
   -  [ProgressBar](https://ethosa.github.io/nodesnim/progress_bar.html)
   -  [Slider](https://ethosa.github.io/nodesnim/slider.html)
   -  [VProgressBar](https://ethosa.github.io/nodesnim/vprogress_bar.html)
   -  [VSlider](https://ethosa.github.io/nodesnim/vslider.html)
   -  [Popup](https://ethosa.github.io/nodesnim/popup.html)

</details>

# Export
Use the [`Nim compiler user guide`](https://nim-lang.org/docs/nimc.html#dynliboverride) for export to the other OS.

-   CrossPlatform export for Windows (tested on Windows 7 x64 and Windows 10 x64)
    -   `nim c -d:mingw -d:release --opt:speed --noNimblePath file.nim`
    -   put Runtime binaries in the folder with the program.


# F.A.Q
*Q*: Where I can see examples?  
*A*: You can see this in the [`tests`](https://github.com/Ethosa/nodesnim/blob/master/tests) or [`examples`](https://github.com/Ethosa/nodesnim/blob/master/examples) folder.

*Q*: Where I can read the docs?  
*A*: You can read docs [here](https://ethosa.github.io/nodesnim)

<div align="center">
  Copyright 2020 Ethosa
</div>
