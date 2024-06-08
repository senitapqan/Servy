defmodule First.Handler do
  def handle(request) do
     request
      |> parse
      |> response
  end

  def parse(request) do
    [method, path, _] =
      request
        |> String.split("\n")
        |> List.first
        |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def response(_conv) do
    """
    HTTP/1.1 200 OK

    Pikachu, Raichi, Esh
    """
  end
end

request = """
GET /pockemons HTTP/1.1
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive
"""

response = First.Handler.handle(request)
IO.puts(response)
