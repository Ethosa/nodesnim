# author: Ethosa

type
  MouseMode* {.size: sizeof(int8).} = enum
    MOUSEMODE_IGNORE = 0x00000001  ## Igore mouse input. This used in Control nodes
    MOUSEMODE_SEE = 0x00000002     ## Handle mouse input.
  PauseMode* {.size: sizeof(int8).} = enum
    PROCESS,  ## Continue to work when the window paused.
    PAUSE,    ## Pause work when the window paused.
    INHERIT   ## Take parent value.
  TextureMode* {.size: sizeof(int8).} = enum
    TEXTURE_FILL_XY,            ## Fill texture without keeping the aspect ratio.
    TEXTURE_KEEP_ASPECT_RATIO,  ## Fill texture with keeping the aspect ratio.
    TEXTURE_CROP                ## Crop and fill texture.
  NodeKind* {.pure, size: sizeof(int8).} = enum
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
  NodeTypes* {.pure, size: sizeof(int8).} = enum
    NODE_TYPE_DEFAULT,
    NODE_TYPE_CONTROL,
    NODE_TYPE_2D,
    NODE_TYPE_3D
  Visibility* {.pure, size: sizeof(int8).} = enum
    VISIBLE,
    INVISIBLE,
    GONE
  ProgressBarType* {.pure, size: sizeof(int8).} = enum
    PROGRESS_BAR_HORIZONTAL,
    PROGRESS_BAR_VERTICAL,
    PROGRESS_BAR_CIRCLE
  SliderType* {.pure, size: sizeof(int8).} = enum
    SLIDER_HORIZONTAL,
    SLIDER_VERTICAL
  GeometryType* {.pure, size: sizeof(int8).} = enum
    GEOMETRY_CUBE,
    GEOMETRY_CYLINDER,
    GEOMETRY_SPHERE
  TileMapMode* {.pure, size: sizeof(int8).} = enum
    TILEMAP_2D,            ## Default 2D mode.
    TILEMAP_ISOMETRIC      ## Isometric mode.
  CollisionShape2DType* {.size: sizeof(int8), pure.} = enum
    COLLISION_SHAPE_2D_RECTANGLE,
    COLLISION_SHAPE_2D_CIRCLE,
    COLLISION_SHAPE_2D_POLYGON
  AnimationMode* {.pure, size: sizeof(int8).} = enum
    ANIMATION_NORMAL,
    ANIMATION_EASE,
    ANIMATION_BEZIER
