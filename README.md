<div align="center">
  <img src="https://github.com/Ethosa/nodesnim/blob/nightly/icon.svg" width="240">

The Nim GUI/2D framework based on OpenGL and SDL2.

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)
[![Nim language-plastic](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)](https://github.com/Ethosa/yukiko/blob/master/nim-lang.svg)
[![License](https://img.shields.io/github/license/Ethosa/nodesnim)](https://github.com/Ethosa/nodesnim/blob/master/LICENSE)
[![time tracker](https://wakatime.com/badge/github/Ethosa/nodesnim.svg)](https://wakatime.com/badge/github/Ethosa/nodesnim)
[![test](https://github.com/Ethosa/nodesnim/workflows/test/badge.svg)](https://github.com/Ethosa/nodesnim/actions)


[![channel icon](https://patrolavia.github.io/telegram-badge/follow.png)](https://t.me/nim1love)
[![channel icon](https://patrolavia.github.io/telegram-badge/chat.png)](https://t.me/nodesnim)

<h4>Stable version - 0.4.2</h4>
</div>

## Install
1. Install Nodesnim
   -  [Stable](https://github.com/Ethosa/nodesnim/tree/master):
      ```bash
      nimble install nodesnim@#master
      ```
   -  [Nightly](https://github.com/Ethosa/nodesnim/tree/nightly):
      ```bash
      nimble install nodesnim@#nightly
      ```
2. Install dependencies
   -  Linux (tested on Ubuntu and Mint):
      - `sudo apt install --fix-missing -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev`
   -  Windows / MacOS:
      -  [SDL2](https://www.libsdl.org/download-2.0.php)
      -  [SDL2_image](https://www.libsdl.org/projects/SDL_image/)
      -  [SDL2_mixer](https://www.libsdl.org/projects/SDL_mixer/)
      -  [SDL2_ttf](https://www.libsdl.org/projects/SDL_ttf/)
      -  Put Runtime binaries in the `.nimble/bin/` folder

## Features
- Godot-like node system.
- Runtime scene loader.
- Powerful node build system using YML-like syntax.
- Stylesheets (CSS-like).
- Android-like drawables.
- Customizable GUI themes.
- Simple usage
  ```nim
  import nodesnim

  Window("Hello, world!")


  build:
    - Scene scene:
      - Label hello:
        call:
          setSizeAnchor(1, 1)
          setTextAlign(0.5, 0.5, 0.5, 0.5)
          setText("Hello, world!")
          setBackgroundColor(Color(31, 45, 62))

  addMainScene(scene)
  windowLaunch()
  
  ```

## Now available
This section contains links to documentation for all nodes.
|Core            |Default nodes        |Control nodes         |2D Nodes            |3D Nodes            |Graphics            |
|:--:            |:--:                 |:--:                  |  :--:              |:--:                |:--:                |
|[Anchor][]      |[Node][]             |[Control][]           |[Node2D][]          |[Node3D][]          |[Drawable][]        |
|[Color][]       |[Canvas][]           |[ColorRect][]         |[Sprite][]          |[GeometryInstance][]|[GradientDrawable][]|
|[Font][]        |[Scene][]            |[TextureRect][]       |[AnimatedSprite][]  |[Camera3D][]        |                    |
|[Enums][]       |[AudioStreamPlayer][]|[Label][]             |[YSort][]           |[Sprite3D][]        |                    |
|[Exceptions][]  |[AnimationPlayer][]  |[Button][]            |[CollisionShape2D][]|                    |                    |
|[Image][]       |                     |[EditText][]          |[Camera2D][]        |                    |                    |
|[Input][]       |                     |[Box][]               |[TileMap][]         |                    |                    |
|[Rect2][]       |                     |[HBox][]              |                    |                    |                    |
|[Vector2][]     |                     |[VBox][]              |                    |                    |                    |
|[Circle2][]     |                     |[GridBox][]           |                    |                    |                    |
|[Polygon2][]    |                     |[Scroll][]            |                    |                    |                    |
|[AudioStream][] |                     |[ProgressBar][]       |                    |                    |                    |
|[Animation][]   |                     |[Slider][]            |                    |                    |                    |
|[Vector3][]     |                     |[Popup][]             |                    |                    |                    |
|[SceneBuilder][]|                     |[TextureButton][]     |                    |                    |                    |
|[StyleSheet][]  |                     |[TextureProgressBar][]|                    |                    |                    |
|[TileSet][]     |                     |[Counter][]           |                    |                    |                    |
|[ChartData][]   |                     |[Switch][]            |                    |                    |                    |
|[Scripts][]     |                     |[SubWindow][]         |                    |                    |                    |
|[Scene loader][]|                     |[CheckBox][]          |                    |                    |                    |
|                |                     |[ToolTip][]           |                    |                    |                    |
|                |                     |[Chart][]             |                    |                    |                    |


## Debug mode
For use debug mode you should compile with `-d:debug` or `--define:debug`, e.g. `nim c -r -d:debug main.nim`.

## Export
Use the [`Nim compiler user guide`](https://nim-lang.org/docs/nimc.html#dynliboverride) for export to the other OS.
[Static linking SDL2](https://github.com/nim-lang/sdl2#static-linking-sdl2)  
Also use [`niminst`](https://github.com/nim-lang/niminst) tool for generate an installer

-   CrossPlatform export for Windows (tested on Windows 7 x64 and Windows 10 x64)
    -   `nim c -d:mingw -d:release --opt:speed --noNimblePath file.nim`
    -   put Runtime binaries in the folder with the program.

## Screenshots
<div align="center">
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/hello_world">
    <img src="https://user-images.githubusercontent.com/49402667/138453889-ea538f86-2fc4-4947-843f-ca100561b05d.png" height="220" alt="Hello world example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/calculator">
    <img src="https://user-images.githubusercontent.com/49402667/138453360-6b701b6a-8695-4ace-bf9f-25d5ae8c68c2.png" height="220" alt="Calculator example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/snake">
    <img src="https://user-images.githubusercontent.com/49402667/138456143-292a5b73-7a52-4d29-9769-1c8101db9f85.png" height="220" alt="Snake game example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/screensaver">
    <img src="https://user-images.githubusercontent.com/49402667/138455275-3df817ae-275d-4164-afc1-92fbdbbb4a6c.png" height="220" alt="Screensaver example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/novel">
    <img src="https://user-images.githubusercontent.com/49402667/138454518-376b40ba-44d0-458a-9b2b-48a5ea53ff64.png" height="220" alt="Novel game example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/roguelike">
    <img src="https://user-images.githubusercontent.com/49402667/138454722-e2b2766d-29cd-412a-92d2-29393d442775.png" height="200" alt="Roguelike game example">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/sample_messenger">
    <img src="https://user-images.githubusercontent.com/49402667/138455176-d38ea0b3-274d-41c6-b877-2a9be39a7b90.png" height="460" alt="sample messenger">
  </a>
  <a href="https://github.com/Ethosa/nodesnim/tree/nightly/examples/calculator">
    <img src="https://user-images.githubusercontent.com/49402667/138453719-0b4d50a9-b4a3-40c5-b017-1e0e0dd4892b.png" height="460" alt="Material Calculator example">
  </a>
</div>



<div align="center" width="100%">
   
   |[Wiki][]|[Examples][]|[Docs][]|[Tests][]|
   |--------|------------|--------|---------|
   
</div>

[![Stargazers over time](https://starchart.cc/Ethosa/nodesnim.svg)](https://starchart.cc/Ethosa/nodesnim)



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
[TileSet]:https://ethosa.github.io/nodesnim/nodesnim/core/tileset.html
[Scripts]:https://ethosa.github.io/nodesnim/nodesnim/runtime/scripts.html
[Scene loader]:https://ethosa.github.io/nodesnim/nodesnim/runtime/scene_loader.html
[ChartData]:https://ethosa.github.io/nodesnim/nodesnim/core/chartdata.html

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
[Popup]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/popup.html
[TextureButton]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_button.html
[TextureProgressBar]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/texture_progress_bar.html
[Counter]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/counter.html
[Switch]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/switch.html
[SubWindow]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/subwindow.html
[CheckBox]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/checkbox.html
[ToolTip]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/tooltip.html
[Chart]:https://ethosa.github.io/nodesnim/nodesnim/nodescontrol/chart.html

[Node2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/node2d.html
[Sprite]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/sprite.html
[AnimatedSprite]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/animated_sprite.html
[YSort]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/ysort.html
[CollisionShape2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/collision_shape2d.html
[KinematicBody2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/kinematic_body2d.html
[Camera2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/camera2d.html
[Node2D]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/node2d.html
[TileMap]:https://ethosa.github.io/nodesnim/nodesnim/nodes2d/tilemap.html

[Node3D]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/node3d.html
[GeometryInstance]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/geometry_instance.html
[Camera3D]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/camera3d.html
[Sprite3D]:https://ethosa.github.io/nodesnim/nodesnim/nodes3d/sprite3d.html

[Drawable]:https://ethosa.github.io/nodesnim/nodesnim/graphics/drawable.html
[GradientDrawable]:https://ethosa.github.io/nodesnim/nodesnim/graphics/gradient_drawable.html

[Examples]:https://github.com/Ethosa/nodesnim/blob/master/examples
[Wiki]:https://github.com/Ethosa/nodesnim/wiki
[Docs]:https://ethosa.github.io/nodesnim/nodesnim.html
[Tests]:https://github.com/Ethosa/nodesnim/blob/master/tests
