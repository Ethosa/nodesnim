<h1 align="center">Nodesnim</h1>
<div align="center">The Nim GUI/2D framework based on OpenGL and SDL2.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/nodesnim)](https://github.com/Ethosa/nodesnim/blob/master/LICENSE)
[![time tracker](https://wakatime.com/badge/github/Ethosa/nodesnim.svg)](https://wakatime.com/badge/github/Ethosa/nodesnim)
[![test](https://github.com/Ethosa/nodesnim/workflows/test/badge.svg)](https://github.com/Ethosa/nodesnim/actions)

<h4>Latest version - 0.0.4</h4>
<h4>Stable version - 0.0.3</h4>
<h5><a href="https://github.com/Ethosa/toshiko">Draft of the best version.</a></h5>
</div>

## Install
1. Install this repo
   -  `nimble install nodesnim` or `nimble install https://github.com/Ethosa/nodesnim.git`
2. Install dependencies
   -  Linux (tested on Ubuntu and Mint):
      - `sudo apt install -y freeglut3 freeglut3-dev`
      - `sudo apt install --fix-missing -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev`
   -  Windows / MacOS:
      -  [SDL2](https://www.libsdl.org/download-2.0.php)
      -  [SDL2_image](https://www.libsdl.org/projects/SDL_image/)
      -  [SDL2_mixer](https://www.libsdl.org/projects/SDL_mixer/)
      -  [freeGLUT](http://freeglut.sourceforge.net/)
      -  Put Runtime binaries in the `.nimble/bin/` folder

## Features
- Godot-like node system.
- Simple usage
  ```nim
  import nodesnim

  Window("Hello, world!")

  var
    scene = Scene("Main")
    hello = Label()

  hello.setText("Hello, world!")
  hello.setSizeAnchor(1, 1)
  hello.setTextAlign(0.5, 0.5, 0.5, 0.5)
  scene.addChild(hello)

  addMainScene(scene)
  windowLaunch()
  ```

## Now available
This section contains links to documentation for all nodes.
|Core                |Default nodes             |Control nodes                  |2D Nodes                    |3D Nodes                     |
|:--:                |:--:                      |:--:                           |  :--:                      |:--:                         |
|[Anchor][Anchor]    |[Node][Node]              |[Control][Control]             |[Node2D][Node2D]            |[Node3D][Node3D]             |
|[Color][Color]      |[Canvas][Canvas]          |[ColorRect][ColorRect]         |[Sprite][Sprite]            |[GeometryInstance][ginstance]|
|[ColorText][clrtext]|[Scene][Scene]            |[TextureRect][TextureRect]     |[AnimatedSprite][asprite]   |                             |
|[Enums][Enums]      |[AudioStreamPlayer][aplay]|[Label][Label]                 |[YSort][YSort]              |                             |
|[Exceptions][except]|                          |[Button][Button]               |[CollisionShape2D][cshape2d]|                             |
|[Image][Image]      |                          |[EditText][EditText]           |[Camera2D][Camera2D]        |                             |
|[Input][Input]      |                          |[RichLabel][RichLabel]         |                            |                             |
|[Rect2][Rect2]      |                          |[RichEditText][RichEditText]   |                            |                             |
|[Vector2][Vector2]  |                          |[Box][Box]                     |                            |                             |
|[Circle2][Circle2]  |                          |[HBox][HBox]                   |                            |                             |
|[Polygon2][Polygon2]|                          |[VBox][VBox]                   |                            |                             |
|[AudioStream][astrm]|                          |[GridBox][GridBox]             |                            |                             |
|[Animation][anim]   |                          |[Scroll][Scroll]               |                            |                             |
|[Vector3][Vector3]  |                          |[ProgressBar][ProgressBar]     |                            |                             |
|[SceneBuilder][SBld]|                          |[Slider][Slider]               |                            |                             |
|                    |                          |[VSlider][VSlider]             |                            |                             |
|                    |                          |[Popup][Popup]                 |                            |                             |
|                    |                          |[TextureButton][TextureButton] |                            |                             |
|                    |                          |[TextureProgressBar][tprogress]|                            |                             |
|                    |                          |[Counter][Counter]             |                            |                             |
|                    |                          |[Switch][Switch]               |                            |                             |
|                    |                          |[SubWindow][swindow]           |                            |                             |
|                    |                          |[LineEdit][lineedit]           |                            |                             |



## Debug mode
For use debug mode you should compile with `-d:debug` or `--define:debug`, e.g. `nim c -r -d:debug main.nim`.

## Export
Use the [`Nim compiler user guide`](https://nim-lang.org/docs/nimc.html#dynliboverride) for export to the other OS.

-   CrossPlatform export for Windows (tested on Windows 7 x64 and Windows 10 x64)
    -   `nim c -d:mingw -d:release --opt:speed --noNimblePath file.nim`
    -   put Runtime binaries in the folder with the program.

## Screenshots
<div align="center">
  <a href="https://github.com/Ethosa/nodesnim/blob/master/examples/hello_world">
    <img src="https://github.com/Ethosa/nodesnim/blob/master/screenshots/1.png" width="380" height="220" alt="Hello world example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/blob/master/examples/calculator">
    <img src="https://github.com/Ethosa/nodesnim/blob/master/screenshots/2.png" width="380" height="220" alt="Calculator example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/blob/master/examples/snake">
    <img src="https://github.com/Ethosa/nodesnim/blob/master/screenshots/3.png" width="380" height="220" alt="Snake game example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/blob/master/examples/screensaver">
    <img src="https://github.com/Ethosa/nodesnim/blob/master/screenshots/4.png" width="380" height="220" alt="Screensaver example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/blob/master/examples/novel">
    <img src="https://github.com/Ethosa/nodesnim/blob/master/screenshots/5.png" width="380" height="220" alt="Novel game example">
  </a>
</div>


## F.A.Q
*Q*: Where can I see examples?  
*A*: You can see this in the [`tests`](https://github.com/Ethosa/nodesnim/blob/master/tests) or [`examples`](https://github.com/Ethosa/nodesnim/blob/master/examples) folder.

*Q*: Where can I read the docs?  
*A*: You can read docs [here](https://ethosa.github.io/nodesnim/nodesnim.html)



[Anchor]:https://ethosa.github.io/nodesnim/nodesnim/core/anchor.html
[Color]:https://ethosa.github.io/nodesnim/nodesnim/core/color.html
[clrtext]:https://ethosa.github.io/nodesnim/nodesnim/core/color_text.html
[Enums]:https://ethosa.github.io/nodesnim/nodesnim/core/enums.html
[except]:https://ethosa.github.io/nodesnim/nodesnim/core/exceptions.html
[Image]:https://ethosa.github.io/nodesnim/nodesnim/core/image.html
[Input]:https://ethosa.github.io/nodesnim/nodesnim/core/input.html
[Rect2]:https://ethosa.github.io/nodesnim/nodesnim/core/rect2.html
[Vector2]:https://ethosa.github.io/nodesnim/nodesnim/core/vector2.html
[Circle2]:https://ethosa.github.io/nodesnim/nodesnim/core/circle2.html
[Polygon2]:https://ethosa.github.io/nodesnim/nodesnim/core/polygon2.html
[astrm]:https://ethosa.github.io/nodesnim/nodesnim/core/audio_stream.html
[anim]:https://ethosa.github.io/nodesnim/nodesnim/core/animation.html
[Vector3]:https://ethosa.github.io/nodesnim/nodesnim/core/vector3.html
[SBld]:https://ethosa.github.io/nodesnim/nodesnim/core/scene_builder.html

[Node]:https://ethosa.github.io/nodesnim/nodesnim/nodes/node.html
[Canvas]:https://ethosa.github.io/nodesnim/nodesnim/nodes/canvas.html
[Scene]:https://ethosa.github.io/nodesnim/nodesnim/nodes/scene.html
[aplay]:https://ethosa.github.io/nodesnim/nodesnim/nodes/audio_stream_player.html

[Control]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/control.html
[ColorRect]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/color_rect.html
[TextureRect]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_rect.html
[Label]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/label.html
[Button]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/button.html
[EditText]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/edittext.html
[RichLabel]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/rich_label.html
[RichEditText]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/rich_edit_text.html
[Box]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/box.html
[HBox]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/hbox.html
[VBox]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/vbox.html
[GridBox]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/grid_box.html
[Scroll]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/scroll.html
[ProgressBar]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/progress_bar.html
[Slider]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/slider.html
[VSlider]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/vslider.html
[Popup]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/popup.html
[TextureButton]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_button.html
[tprogress]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_progress_bar.html
[Counter]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/counter.html
[Switch]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/switch.html
[swindow]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/subwindow.html
[lineedit]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/lindeedit.html

[Node2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/node2d.html
[Sprite]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/sprite.html
[asprite]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/animated_sprite.html
[YSort]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/ysort.html
[cshape2d]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/collision_shape2d.html
[KinematicBody2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/kinematic_body2d.html
[Camera2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/camera2d.html
[Node2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/node2d.html

[Node3D]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/node3d.html
[ginstance]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/geometry_instance.html
