import nodesnim
import random
randomize()


Window("Snake game")


type
  Snake = ref object
    dir: Vector2Ref
    size: Vector2Ref
    food: Vector2Ref
    body: seq[Vector2Ref]


var
  main = Scene("Main")
  game_over = Scene("GameOverScene")
  label_go = Label("GameOverLabel")

  canvas = Canvas("Canvas")

  snake = Snake(
    dir: Vector2(),
    body: @[Vector2(0, 0)],
    size: Vector2(40, 40),
    food: Vector2(160, 160))
  time = 0


game_over.addChild(label_go)

label_go.text = "Game Over"
label_go.setTextAlign(0.5, 0.5, 0.5, 0.5)
label_go.setSizeAnchor(1, 1)


Input.addKeyAction("forward", "w")
Input.addKeyAction("backward", "s")
Input.addKeyAction("left", "a")
Input.addKeyAction("right", "d")


canvas@on_process(self):
  if Input.isActionJustPressed("forward"):
    snake.dir = Vector2(0, -40)
  elif Input.isActionJustPressed("backward"):
    snake.dir = Vector2(0, 40)
  elif Input.isActionJustPressed("left"):
    snake.dir = Vector2(-40, 0)
  elif Input.isActionJustPressed("right"):
    snake.dir = Vector2(40, 0)
  if time < 10:
    inc time
    return
  canvas.resize(main.rect_size.x, main.rect_size.y)
  let
    grid_size = Vector2(
      (main.rect_size.x.int div snake.size.x.int).float,
      (main.rect_size.y.int div snake.size.y.int).float
    )
  canvas.fill(Color(0, 0, 0, 0))


  if snake.dir.y < 0:
    for i in countdown(snake.body.len()-1, 0):
      if i > 0:
        snake.body[i] = Vector2(snake.body[i-1].x, snake.body[i-1].y)
      else:
        if snake.body[i].y > 0:
          snake.body[i].y += snake.dir.y
        else:
          snake.body[i].y = grid_size.y*snake.size.y - snake.size.y
  elif snake.dir.y > 0:
    for i in countdown(snake.body.len()-1, 0):
      if i > 0:
        snake.body[i] = Vector2(snake.body[i-1].x, snake.body[i-1].y)
      else:
        if snake.body[i].y < grid_size.y*snake.size.y - snake.size.y:
          snake.body[i].y += snake.dir.y
        else:
          snake.body[i].y = 0

  elif snake.dir.x < 0:
    for i in countdown(snake.body.len()-1, 0):
      if i > 0:
        snake.body[i] = Vector2(snake.body[i-1].x, snake.body[i-1].y)
      else:
        if snake.body[i].x > 0:
          snake.body[i].x += snake.dir.x
        else:
          snake.body[i].x = grid_size.x*snake.size.x - snake.size.x
  elif snake.dir.x > 0:
    for i in countdown(snake.body.len()-1, 0):
      if i > 0:
        snake.body[i] = Vector2(snake.body[i-1].x, snake.body[i-1].y)
      else:
        if snake.body[i].x < grid_size.x*snake.size.x - snake.size.x:
          snake.body[i].x += snake.dir.x
        else:
          snake.body[i].x = 0

  if snake.body[0] == snake.food:
    snake.body.add(snake.body[^1])
    snake.food.x = (rand(grid_size.x.int-1) * snake.size.x.int).float
    snake.food.y = (rand(grid_size.y.int-1) * snake.size.y.int).float
  elif snake.body[0] in snake.body[1..^1]:
    changeScene("GameOverScene")
  # draw
  for i in snake.body:
    canvas.rect(i.x, i.y, i.x+snake.size.x, i.y+snake.size.y, Color(1f, 1f, 1f))
  # head
  canvas.rect(
    snake.body[0].x, snake.body[0].y,
    snake.body[0].x+snake.size.x, snake.body[0].y+snake.size.y,
    Color(0xaaccffff'u32))
  # food
  canvas.rect(
    snake.food.x, snake.food.y,
    snake.food.x+snake.size.x, snake.food.y+snake.size.y,
    Color(0xffccaaff'u32))
  time = 0


addScene(game_over)
main.addChild(canvas)
addScene(main)
setMainScene("Main")
windowLaunch()
