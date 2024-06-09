defmodule First.Handler do
  def handle(request) do
    request
      |> First.Parser.parse
      |> rewrite_path
      |> route
      |> track
      |> response_format
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/pockemons"} = conv) do
    %{conv | path: "/pokemons"}
  end

  def rewrite_path(conv), do: conv

  def route(%{method: "GET", path: "/pokemons/" <> id} = conv) do
    %{conv | resp_body: "Pokemon #{id}", status: 200}
  end

  def route(%{method: "GET", path: "/pokemons"} = conv) do
    %{conv | resp_body: "Granbull, Porygon2, Zigzagon", status: 200}
  end

  def route(%{method: "GET", path: "/home"} = conv) do
      Path.expand("../../pages", __DIR__)
       |> Path.join("home.html")
       |> File.read
       |> handle_file(conv)
  end


  def route(%{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} there"}
  end
  
  def handle_file({:ok, content}, conv), do: %{ conv | status: 200, resp_body: content}
  def handle_file({:error, :enoent}, conv), do: %{ conv | status: 404, resp_body: "File not found"}
  def handle_file({:error, reason}, conv), do: %{ conv | status: 500, resp_body: "File error #{reason}"}

  def response_format(conv) do
    """
    HTTP/1.1 #{conv.status} OK
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
