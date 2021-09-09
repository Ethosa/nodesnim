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
  NodeKind* {.pure.} = enum
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
    VPROGRESS_BAR_NODE,
    VSLIDER_NODE,
    SUB_WINDOW_NODE,
    LINE_EDIT_NODE,
    # 3D nodes
    NODE3D_NODE,
    GEOMETRY_INSTANCE_NODE
  NodeTypes* {.pure.} = enum
    NODE_TYPE_DEFAULT,
    NODE_TYPE_CONTROL,
    NODE_TYPE_2D,
    NODE_TYPE_3D
