import
  ../server_api/api,
  asyncdispatch,
  nodesnim


var
  gradient = GradientDrawable()

gradient.setCornerColors(Color("#cac"), Color("#cac"), Color("#acc"), Color("#acc"))


build:
  - Scene (enter_scene):
    call rename("Enter")
  
    - Control background:
      call setSizeAnchor(1, 1)
      call setBackground(gradient)
  
      - VBox input:
        separator: 8
        call setAnchor(0.5, 0.5, 0.5, 0.5)
        call setChildAnchor(0.5, 0.5, 0.5, 0.5)
        call resize(256, 256+64)
        call setStyle(style({
          border-radius: 8,
          border-detail: 8,
          background-color: rgba(100, 111, 122, 0.4)
          }))
  
        - EditText login:
          caret: false
          call setTextAlign(0.5, 0.5, 0.5, 0.5)
          call setStyle(style({
            border-radius: 8,
            border-detail: 8,
            border-color: rgba(100, 111, 122, 0.4),
            border-width: 1
            }))
        - Button send:
          call setText("ENTER")


send.normal_background.setStyle(style({
  border-radius: 8,
  border-detail: 8,
  background-color: rgba(100, 111, 122, 0.4),
  background-width: 1
}))
send.hover_background.setStyle(style({
  border-radius: 8,
  border-detail: 8,
  background-color: rgba(100, 111, 122, 0.6),
  background-width: 1
}))
send.press_background.setStyle(style({
  border-radius: 8,
  border-detail: 8,
  background-color: rgba(100, 111, 122, 0.8),
  background-width: 1
}))


login.hint = stext"Username"
login.hint.setColor(Color("#ebebeb"))
login.text.setColor(Color("#fff"))


send@onClick(self, x, y):
  username = login.getText()
  if username.len > 0:
    var response = waitFor enter()
    if response:
      changeScene("Chat")
