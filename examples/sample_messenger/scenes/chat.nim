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
      call setBackground(gradient)
      call setSizeAnchor(1, 1)

      - Label chat:
        call setSizeAnchor(1, 1)

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
      text = ""
    arg.timed_chat[] = parseJson(waitFor response.body())["data"].getElems

    var i = 0
    while i < arg.timed_chat[].len:
      text &= (arg.timed_chat[][i].str & ": " & arg.timed_chat[][i+1].str & "\n\n")
      inc i, 2
    
    # TODO: Fix it
    # arg.scene[].getNode("background/chat").LabelRef.setText(text)

    waitFor sleepAsync(100)


background@onEnter(self):
  createThread(thr, listenChat, (chat_scene.addr, username.addr, timed_chat.addr))

background@onInput(self, event):
  if isActionJustPressed("send"):
    if message.getText().len > 0:
      sendMessage(message.getText())
      message.setText("")
