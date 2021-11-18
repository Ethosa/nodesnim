import
  ../server_api/api,
  asyncdispatch,
  httpclient,
  nodesnim,
  json


var
  thr: Thread[tuple[scene: ptr SceneRef, username: ptr string, timed_chat: ptr seq[JsonNode]]]
  gradient = GradientDrawable()

gradient.setCornerColors(Color("#C9D6FF"), Color("#C9D6FF"), Color("#E2E2E2"), Color("#E2E2E2"))


build:
  - Scene (chat_scene):
    - Control background:
      call:
        setBackground(gradient)
        setSizeAnchor(1, 1)

      - VBox vbox:
        call:
          setSizeAnchor(1, 0.8)

      - EditText message:
        call:
          setSizeAnchor(0.95, 0.15)
          setAnchor(0.5, 1, 0.5, 1.2)
          setStyle(style({
              border-radius: 8,
              border-detail: 8,
              background-color: rgba(50, 60, 70, 0.5)
            }))


proc listenChat(arg: tuple[scene: ptr SceneRef, username: ptr string, timed_chat: ptr seq[JsonNode]]) {.thread.} =
  var client = newAsyncHttpClient()
  while true:
    var
      response = waitFor client.get("http://127.0.0.1:5000/getchat")
      tmp_chat = arg.timed_chat
    arg.timed_chat[] = parseJson(waitFor response.body())["data"].getElems

    {.cast(gcsafe).}:
      arg.scene[][0].removeChild(0)
      build:
        - VBox chat:
          separator: 8
          call:
            resize(arg.scene[].rect_size.x, 0)
            setSizeAnchor(1, 0.65)
      arg.scene[][0].insertChild(0, chat)

    var i = 0
    while i < arg.timed_chat[].len:
      if tmp_chat[][i].kind != JString:
        continue
      {.cast(gcsafe).}:
        build:
          - Control back:
            - Label label:
              call:
                setText(arg.timed_chat[][i].str & ": " & arg.timed_chat[][i+1].str)
            call:
              setSizeAnchor(1, 0)
              resize(0, label.rect_size.y)
        chat.addChild(back)

        if tmp_chat[][i].str == username:
          label.setStyle(style({
              border-radius: 10,
              border-detail: 8,
              background-color: "#ffc"
            }))
          label.setAnchor(1, 0, 1, 0)
        else:
          label.setStyle(style({
              border-radius: 10,
              border-detail: 8,
              background-color: "#dda"
            }))
        chat.calcPositionAnchor()
        back.calcPositionAnchor()
        label.calcPositionAnchor()
      inc i, 2

    waitFor sleepAsync(100)


background@onEnter(self):
  createThread(thr, listenChat, (chat_scene.addr, username.addr, timed_chat.addr))

background@onInput(self, event):
  if isActionJustPressed("send"):
    if message.getText().len > 0:
      sendMessage(message.getText())
      message.setText("")
