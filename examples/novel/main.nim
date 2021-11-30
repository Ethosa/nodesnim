# main scene
import nodesnim

Window("Novel game", 1280, 720)

var
  # Backgrounds:
  night = load("assets/night.jpg")
  # Charapters:
  akiko_default = load("assets/test.png", GL_RGBA)
  dialog = @[
    ("Me", "H-Hey .. ?", GONE),
    ("Eileen", "NANI??????", VISIBLE)
  ]
  stage = 0


build:
  - Scene main:
    - Button button:
      call:
        setText("New game")
        resize(128, 32)
        setAnchor(0.5, 0.5, 0.5, 0.5)
      @onTouch(x, y):
        changeScene("game_scene")

  - Scene game_scene:
    - TextureRect background_image:
      texture_mode: TEXTURE_KEEP_ASPECT_RATIO
      call:
        setSizeAnchor(1, 1)
        setTexture(night)
        setTextureAnchor(0.5, 0.5, 0.5, 0.5)
    - TextureRect charapter:
      texture_mode: TEXTURE_KEEP_ASPECT_RATIO
      visibility: GONE
      call:
        setSizeAnchor(1, 1)
        setTexture(akiko_default)
        setTextureAnchor(0.5, 0.5, 0.5, 0.5)
    - Label dialog_text:
      call:
        setSizeAnchor(0.8, 0.3)
        setAnchor(0.1, 0.6, 0, 0)
        setBackgroundColor(Color(0x0e131760))
        setPadding(8, 8, 8, 8)
      - Label name_charapter:
        call:
          resize(128, 32)
          setAnchor(0, 0, 0, 1)
          setBackgroundColor(Color(0x0e131760'u32))
          setStyle(style({
            border-radius: "8 8 0 0"
          }))
          setTextAlign(0.1, 0.5, 0.1, 0.5)
    - ColorRect foreground_rect:
      call setSizeAnchor(1, 1)
      color: Color(0x0e1317ff)
    - AnimationPlayer animation:
      loop: false
      call addState(foreground_rect.color.a.addr,
                    @[(tick: 0, value: 1.0), (tick: 100, value: 0.0)])
      @onReady():
        animation.play()


foreground_rect@onInput(self, event):
  if event.isInputEventMouseButton() and not event.pressed:
    if stage < dialog.len():
      name_charapter.setText(dialog[stage][0])
      dialog_text.setText(dialog[stage][1])
      charapter.visibility = dialog[stage][2]
    inc stage


addMainScene(main)
addScene(game_scene)
runApp()
