defmodule First.Handler do
  @moduledoc "Handles HTTP requests"

  @pages_path Path.expand("../../pages", __DIR__)

  import First.Plugins, only: [rewrite_path: 1, track: 1]
  import First.Parser, only: [parse: 1]
  import First.Conv, only: [full_status: 1]

  alias First.Conv
  alias First.PokemonController
  @doc "Transforms the request into a response"
  def handle(request) do
    IO.puts request
    request
      |> parse
      |> rewrite_path
      |> route
      |> track
      |> response_format
  end

  def route(%Conv{method: "POST", path: "/pokemons"} = conv) do
    PokemonController.createPokemon(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pokemons/" <> id} = conv) do
    PokemonController.getPokemon(conv, id)
  end

  def route(%Conv{method: "GET", path: "/pokemons"} = conv) do
    PokemonController.getPokemons(conv)
  end

  def route(%Conv{method: "GET", path: "/home"} = conv) do
    @pages_path
      |> Path.join("home.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} there"}
  end

  def handle_file({:ok, content}, %Conv{} = conv), do: %{ conv | status: 200, resp_body: content}
  def handle_file({:error, :enoent}, %Conv{} = conv), do: %{ conv | status: 404, resp_body: "File not found"}
  def handle_file({:error, reason}, %Conv{} = conv), do: %{ conv | status: 500, resp_body: "File error #{reason}"}

  def response_format(%Conv{} = conv) do
    """
    HTTP/1.1 #{full_status(conv.status)}
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

request = """
GET /pokemons/5 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = First.Handler.handle(request)

IO.puts response

request = """
GET /pockemons HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = First.Handler.handle(request)

IO.puts response


request = """
GET /pikachu HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = First.Handler.handle(request)

IO.puts response

request = """
GET /home HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = First.Handler.handle(request)

IO.puts response

request = """
POST /pokemons HTTP/1.1
Host: example.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 27

name=Raichu&type=Electrical
"""

response = First.Handler.handle(request)

IO.puts response
