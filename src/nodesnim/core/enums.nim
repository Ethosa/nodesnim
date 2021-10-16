# author: Ethosa

{.push pure, size: sizeof(int8).}

type
  MouseMode* = enum
    MOUSEMODE_IGNORE = 0x00000001  ## Igore mouse input. This used in Control nodes
    MOUSEMODE_SEE = 0x00000002     ## Handle mouse input.
  PauseMode* = enum
    PROCESS,  ## Continue to work when the window paused.
    PAUSE,    ## Pause work when the window paused.
    INHERIT   ## Take parent value.
  TextureMode* = enum
    TEXTURE_FILL_XY,            ## Fill texture without keeping the aspect ratio.
    TEXTURE_KEEP_ASPECT_RATIO,  ## Fill texture with keeping the aspect ratio.
    TEXTURE_CROP                ## Crop and fill texture.

  NodeKind* = enum
    NODE_NODE,
    CANVAS_NODE,
    SCENE_NODE,
    AUDIO_STREAM_PLAYER_NODE,
    ANIMATION_PLAYER_NODE,
    # 2D nodes
    COLLISION_SHAPE_2D_NODE,
    YSORT_NODE,
    CAMERA_2D_NODE,
    SPRITE_NODE,
    ANIMATED_SPRITE_NODE,
    NODE2D_NODE,
    KINEMATIC_BODY_2D_NODE,
    TILEMAP_NODE,
    # Control nodes
    BOX_NODE,
    BUTTON_NODE,
    CHECKBOX_NODE,
    COLOR_RECT_NODE,
    CONTROL_NODE,
    COUNTER_NODE,
    EDIT_TEXT_NODE,
    GRID_BOX_NODE,
    HBOX_NODE,
    LABEL_NODE,
    POPUP_NODE,
    PROGRESS_BAR_NODE,
    SCROLL_NODE,
    SLIDER_NODE,
    TEXTURE_BUTTON_NODE,
    TEXTURE_PROGRESS_BAR_NODE,
    TEXTURE_RECT_NODE,
    VBOX_NODE,
    SUB_WINDOW_NODE,
    # 3D nodes
    NODE3D_NODE,
    GEOMETRY_INSTANCE_NODE,
    CAMERA_3D_NODE,
    SPRITE_3D_NODE

  NodeTypes* = enum
    NODE_TYPE_DEFAULT,
    NODE_TYPE_CONTROL,
    NODE_TYPE_2D,
    NODE_TYPE_3D

  Visibility* = enum
    VISIBLE,
    INVISIBLE,
    GONE

  ProgressBarType* = enum
    PROGRESS_BAR_HORIZONTAL,
    PROGRESS_BAR_VERTICAL,
    PROGRESS_BAR_CIRCLE

  SliderType* = enum
    SLIDER_HORIZONTAL,
    SLIDER_VERTICAL

  GeometryType* = enum
    GEOMETRY_CUBE,      ## Uses for cube rendering.
    GEOMETRY_CYLINDER,  ## Uses for cylinder rendering.
    GEOMETRY_SPHERE     ## Uses for sphere rendering.

  TileMapMode* = enum
    TILEMAP_2D,         ## Default 2D mode.
    TILEMAP_ISOMETRIC   ## Isometric mode.

  CollisionShape2DType* = enum
    COLLISION_SHAPE_2D_RECTANGLE,  ## Uses for handle rect collision.
    COLLISION_SHAPE_2D_CIRCLE,     ## Uses for handle circle collision.
    COLLISION_SHAPE_2D_POLYGON     ## Uses for handle polygon collision.

  AnimationMode* = enum
    ANIMATION_NORMAL,  ## specific speed per second.
    ANIMATION_EASE,    ## ease mode.
    ANIMATION_BEZIER   ## specific bezier curve for speed.

  ScreenMode* = enum
    SCREEN_MODE_NONE,  ## default mode.
    SCREEN_MODE_EXPANDED  ## Keep screen size.

{.pop.}
