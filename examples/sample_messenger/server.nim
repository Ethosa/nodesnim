# author: Ethosa
import
  asyncdispatch,
  db_sqlite,
  akane


proc userExists(connect: DbConn, username: string): bool =
  for row in connect.rows(sql"SELECT username FROM users"):
    if row[0] == username:
      return true
  return false

proc addUser(connect: DbConn, username: string) =
  if not connect.userExists(username):
    connect.exec(sql"INSERT INTO users VALUES (?)", username)


when isMainModule:
  var db = open("users.db", "", "", "")

  db.exec(sql"CREATE TABLE IF NOT EXISTS users (username text)")

  proc main {.gcsafe.} =
    var
      server = newServer()
      timed_chat = %*[]

    server.pages:
      "/":
        await request.answer("Hello, World!")

      startswith("/enter"):
        var data = await parseQuery(request)
        if "username" in data:
          db.addUser($data["username"])
          await request.sendJson(%*{"response": 0})
        else:
          await request.sendJson(
            %*{
              "response": 1,
              "data": {
                "text": "You need to specify a username!"
              }})

      startswith("/send"):
        var data = await parseQuery(request)
        if "username" in data and "msg" in data:
          if db.userExists($data["username"]):
            timed_chat.add(data["username"])
            timed_chat.add(data["msg"])
            await request.sendJson(%*{"response": 0})
          else:
            await request.sendJson(
              %*{
                "response": 1,
                "data": {
                  "text": "This user isn't registered!"
                }})
        else:
          await request.sendJson(
            %*{
              "response": 1,
              "data": {
                "text": "You need to specify a msg and username!"
              }})

      startswith("/getchat"):
        var response = %*{}
        response["response"] = %0
        response["data"] = timed_chat
        await request.sendJson(response)


    server.start()
  main()
