import
  asyncdispatch,
  httpclient,
  json,
  uri

var
  username*: string = ""
  client = newAsyncHttpClient()
  timed_chat*: seq[JsonNode]


proc enter*(): Future[bool] {.async.} =
  echo "http:/127.0.0.1:5000/enter?username=" & username
  var
    response = await client.get("http://127.0.0.1:5000/enter?" & encodeQuery({"username": username}))
    data = parseJson(await response.body())
  
  return data["response"].num == 0


proc sendMessage*(msg: string) =
  var response = waitFor client.get("http://127.0.0.1:5000/send?" & encodeQuery({"username": username, "msg": msg}))
