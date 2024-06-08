defmodule First.Handler do
  def handle(request) do
    request
      |> parse
      |> route
      |> response_format
  end

  def parse(request) do
    [method, path, _] =
    request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

      %{method: method, path: path, resp_body: ""}
  end

  def route(%{method: "GET", path: "/pokemons"} = conv) do
    %{conv | resp_body: "Granbull, Porygon2, Zigzagon"}
  end

  def response_format(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

end

request = """
GET /pokemons HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = First.Handler.handle(request)

IO.puts response
