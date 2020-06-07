# main scene
import nodesnim

Window("Novel game", 1280, 720)

var
  main = Scene("Main")

  button = Button("New game")


  # Game scene
  game_scene = Scene("Game")

  # Backgrounds:
  night = load("assets/night.jpg")

  # Charapters:
  akiko_default = load("assets/test.png", GL_RGBA)

  name_charapter = Label()
  dialog_text = RichLabel()
  background_image = TextureRect()
  foreground_rect = ColorRect()

  charapter = TextureRect("Charapter")

  dialog = @[
    ("Me", "H-Hey .. ?", false),
    ("Eileen", "NANI??????", true)
  ]
  stage = -1


game_scene.addChild(background_image)
background_image.setSizeAnchor(1, 1)
background_image.setTexture(night)
background_image.setTextureAnchor(0.5, 0.5, 0.5, 0.5)
background_image.texture_mode = TEXTURE_KEEP_ASPECT_RATIO

game_scene.addChild(charapter)
charapter.setSizeAnchor(1, 1)
charapter.setTexture(akiko_default)
charapter.setTextureAnchor(0.5, 0.5, 0.5, 0.5)
charapter.texture_mode = TEXTURE_KEEP_ASPECT_RATIO
charapter.visible = false

game_scene.addChild(dialog_text)
dialog_text.setSizeAnchor(0.8, 0.3)
dialog_text.setAnchor(0.1, 0.6, 0, 0)
dialog_text.setBackgroundColor(Color(0x0e131760))

dialog_text.addChild(name_charapter)
name_charapter.resize(128, 32)
name_charapter.setAnchor(0, 0, 0, 1)
name_charapter.setBackgroundColor(Color(0x0e131760))
name_charapter.setTextAlign(0.1, 0.5, 0.1, 0.5)

game_scene.addChild(foreground_rect)
foreground_rect.setSizeAnchor(1, 1)

foreground_rect@on_ready(self):
  foreground_rect.color = Color(0x0e1317ff)

foreground_rect@on_process(self):
  if foreground_rect.color.a > 0f:
    foreground_rect.color.a -= 0.001

foreground_rect@on_input(self, event):
  if event.isInputEventMouseButton() and not event.pressed:
    inc stage
    if stage < dialog.len():
      name_charapter.setText(dialog[stage][0])
      dialog_text.setText(clrtext(dialog[stage][1]))
      charapter.visible = dialog[stage][2]



main.addChild(button)
button.text = "New game"
button.resize(128, 32)
button.setAnchor(0.5, 0.5, 0.5, 0.5)
button.on_touch =
  proc(self: ButtonRef, x, y: float) =
    changeScene("Game")


addScene(main)
addScene(game_scene)
setMainScene("Main")
windowLaunch()
