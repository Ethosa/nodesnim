# main scene
import nodesnim

Window("Novel game", 1280, 720)

var
  # Backgrounds:
  night = load("assets/night.jpg")
  # Charapters:
  akiko_default = load("assets/test.png", GL_RGBA)
  dialog = @[
    ("Me", "H-Hey .. ?", false),
    ("Eileen", "NANI??????", true)
  ]
  stage = 0


build:
  - Scene main:
    call rename("Main")
    - Button button:
      text: "New game"
      call resize(128, 32)
      call setAnchor(0.5, 0.5, 0.5, 0.5)
  - Scene game_scene:
    call rename("Game")
    - TextureRect background_image:
      call setSizeAnchor(1, 1)
      call setTexture(night)
      call setTextureAnchor(0.5, 0.5, 0.5, 0.5)
      texture_mode: TEXTURE_KEEP_ASPECT_RATIO
    - TextureRect charapter:
      call setSizeAnchor(1, 1)
      call setTexture(akiko_default)
      call setTextureAnchor(0.5, 0.5, 0.5, 0.5)
      texture_mode: TEXTURE_KEEP_ASPECT_RATIO
      visible: false
    - RichLabel dialog_text:
      call setSizeAnchor(0.8, 0.3)
      call setAnchor(0.1, 0.6, 0, 0)
      call setBackgroundColor(Color(0x0e131760))
      - Label name_charapter:
        call resize(128, 32)
        call setAnchor(0, 0, 0, 1)
        call setBackgroundColor(Color(0x0e131760'u32))
        call setStyle(style({
          border-radius: "8 8 0 0"
        }))
        call setTextAlign(0.1, 0.5, 0.1, 0.5)
    - ColorRect foreground_rect:
      call setSizeAnchor(1, 1)
      color: Color(0x0e1317ff)
    - AnimationPlayer animation:
      loop: false
      call addState(foreground_rect.color.a.addr,
                    @[(tick: 0, value: 1.0), (tick: 100, value: 0.0)])


foreground_rect@on_ready(self):
  animation.play()

foreground_rect@on_input(self, event):
  if event.isInputEventMouseButton() and not event.pressed:
    if stage < dialog.len():
      name_charapter.setText(dialog[stage][0])
      dialog_text.setText(clrtext(dialog[stage][1]))
      charapter.visible = dialog[stage][2]
    inc stage



button.on_touch =
  proc(self: ButtonRef, x, y: float) =
    changeScene("Game")

addMainScene(main)
addScene(game_scene)
windowLaunch()
