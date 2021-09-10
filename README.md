<h1 align="center">Nodesnim</h1>
<div align="center">The Nim GUI/2D framework based on OpenGL and SDL2.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/nodesnim)](https://github.com/Ethosa/nodesnim/blob/master/LICENSE)
[![time tracker](https://wakatime.com/badge/github/Ethosa/nodesnim.svg)](https://wakatime.com/badge/github/Ethosa/nodesnim)
[![test](https://github.com/Ethosa/nodesnim/workflows/test/badge.svg)](https://github.com/Ethosa/nodesnim/actions)

<h4>Stable version - 0.2.2</h4>
</div>

## Install
1. Install Nodesnim
   -  Stable: `nimble install nodesnim` or `nimble install https://github.com/Ethosa/nodesnim.git`
   -  Nightly:
      ```bash
      git clone https://github.com/Ethosa/nodesnim/
      cd nodesnim
      git checkout nightly-0.X.X
      nimble install
      ```
2. Install dependencies
   -  Linux (tested on Ubuntu and Mint):
      - `sudo apt install -y freeglut3 freeglut3-dev`
      - `sudo apt install --fix-missing -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev`
   -  Windows / MacOS:
      -  [SDL2](https://www.libsdl.org/download-2.0.php)
      -  [SDL2_image](https://www.libsdl.org/projects/SDL_image/)
      -  [SDL2_mixer](https://www.libsdl.org/projects/SDL_mixer/)
      -  [SDL2_ttf](https://www.libsdl.org/projects/SDL_ttf/)
      -  [freeGLUT](http://freeglut.sourceforge.net/)
      -  Put Runtime binaries in the `.nimble/bin/` folder

## Features
- Godot-like node system.
- Build nodes with YML-like syntax.
- Stylesheets (CSS-like).
- Simple usage
  ```nim
  import nodesnim

  Window("Hello, world!")


  build:
    - Scene scene:
      name: "Main"
      - Label hello:
        call setSizeAnchor(1, 1)
        call setTextAlign(0.5, 0.5, 0.5, 0.5)
        call setText("Hello, world!")
        call setBackgroundColor(Color(31, 45, 62))

  addMainScene(scene)
  windowLaunch()
  
  ```

## Now available
This section contains links to documentation for all nodes.
|Core            |Default nodes        |Control nodes         |2D Nodes            |3D Nodes            |Graphics            |
|:--:            |:--:                 |:--:                  |  :--:              |:--:                |:--:                |
|[Anchor][]      |[Node][]             |[Control][]           |[Node2D][]          |[Node3D][]          |[Drawable][]        |
|[Color][]       |[Canvas][]           |[ColorRect][]         |[Sprite][]          |[GeometryInstance][]|[GradientDrawable][]|
|[Font][]        |[Scene][]            |[TextureRect][]       |[AnimatedSprite][]  |                    |                    |
|[Enums][]       |[AudioStreamPlayer][]|[Label][]             |[YSort][]           |                    |                    |
|[Exceptions][]  |[AnimationPlayer][]  |[Button][]            |[CollisionShape2D][]|                    |                    |
|[Image][]       |                     |[EditText][]          |[Camera2D][]        |                    |                    |
|[Input][]       |                     |[Box][]               |                    |                    |                    |
|[Rect2][]       |                     |[HBox][]              |                    |                    |                    |
|[Vector2][]     |                     |[VBox][]              |                    |                    |                    |
|[Circle2][]     |                     |[GridBox][]           |                    |                    |                    |
|[Polygon2][]    |                     |[Scroll][]            |                    |                    |                    |
|[AudioStream][] |                     |[ProgressBar][]       |                    |                    |                    |
|[Animation][]   |                     |[Slider][]            |                    |                    |                    |
|[Vector3][]     |                     |[VSlider][]           |                    |                    |                    |
|[SceneBuilder][]|                     |[Popup][]             |                    |                    |                    |
|[StyleSheet][]  |                     |[TextureButton][]     |                    |                    |                    |
|                |                     |[TextureProgressBar][]|                    |                    |                    |
|                |                     |[Counter][]           |                    |                    |                    |
|                |                     |[Switch][]            |                    |                    |                    |
|                |                     |[SubWindow][]         |                    |                    |                    |
|                |                     |[LineEdit][]          |                    |                    |                    |
|                |                     |[CheckBox][]          |                    |                    |                    |



## Debug mode
For use debug mode you should compile with `-d:debug` or `--define:debug`, e.g. `nim c -r -d:debug main.nim`.

## Export
Use the [`Nim compiler user guide`](https://nim-lang.org/docs/nimc.html#dynliboverride) for export to the other OS.  
[Static linking SDL2](https://github.com/nim-lang/sdl2#static-linking-sdl2) (or compile with `-d:static_sdl2` -> tested on Windows)

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



<div align="center" width="100%">
   
   |[Wiki][]|[Examples][]|[Docs][]|[Tests][]|
   |--------|------------|--------|---------|
   
</div>



[Anchor]:https://ethosa.github.io/nodesnim/nodesnim/core/anchor.html
[Color]:https://ethosa.github.io/nodesnim/nodesnim/core/color.html
[Enums]:https://ethosa.github.io/nodesnim/nodesnim/core/enums.html
[Exceptions]:https://ethosa.github.io/nodesnim/nodesnim/core/exceptions.html
[Image]:https://ethosa.github.io/nodesnim/nodesnim/core/image.html
[Input]:https://ethosa.github.io/nodesnim/nodesnim/core/input.html
[Rect2]:https://ethosa.github.io/nodesnim/nodesnim/core/rect2.html
[Vector2]:https://ethosa.github.io/nodesnim/nodesnim/core/vector2.html
[Circle2]:https://ethosa.github.io/nodesnim/nodesnim/core/circle2.html
[Polygon2]:https://ethosa.github.io/nodesnim/nodesnim/core/polygon2.html
[AudioStream]:https://ethosa.github.io/nodesnim/nodesnim/core/audio_stream.html
[Animation]:https://ethosa.github.io/nodesnim/nodesnim/core/animation.html
[Vector3]:https://ethosa.github.io/nodesnim/nodesnim/core/vector3.html
[SceneBuilder]:https://ethosa.github.io/nodesnim/nodesnim/core/scene_builder.html
[Font]:https://ethosa.github.io/nodesnim/nodesnim/core/font.html
[StyleSheet]:https://ethosa.github.io/nodesnim/nodesnim/core/stylesheet.html

[Node]:https://ethosa.github.io/nodesnim/nodesnim/nodes/node.html
[Canvas]:https://ethosa.github.io/nodesnim/nodesnim/nodes/canvas.html
[Scene]:https://ethosa.github.io/nodesnim/nodesnim/nodes/scene.html
[AudioStreamPlayer]:https://ethosa.github.io/nodesnim/nodesnim/nodes/audio_stream_player.html
[AnimationPlayer]:https://ethosa.github.io/nodesnim/nodesnim/nodes/animation_player.html

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
[TextureProgressBar]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_progress_bar.html
[Counter]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/counter.html
[Switch]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/switch.html
[SubWindow]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/subwindow.html
[LineEdit]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/lindeedit.html
[CheckBox]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/checkbox.html

[Node2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/node2d.html
[Sprite]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/sprite.html
[AnimatedSprite]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/animated_sprite.html
[YSort]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/ysort.html
[CollisionShape2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/collision_shape2d.html
[KinematicBody2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/kinematic_body2d.html
[Camera2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/camera2d.html
[Node2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/node2d.html

[Node3D]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/node3d.html
[GeometryInstance]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/geometry_instance.html

[Drawable]:https://ethosa.github.io/nodesnim/nodesnim/graphics/drawable.html
[GradientDrawable]:https://ethosa.github.io/nodesnim/nodesnim/graphics/gradient_drawable.html

[Examples]:https://github.com/Ethosa/nodesnim/blob/master/examples
[Wiki]:https://github.com/Ethosa/nodesnim/wiki
[Docs]:https://ethosa.github.io/nodesnim/nodesnim.html
[Tests]:https://github.com/Ethosa/nodesnim/blob/master/tests
