defmodule First.Plugins do

  alias First.Conv

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(%Conv{} = conv), do: conv


  def rewrite_path(%Conv{path: "/pockemons"} = conv) do
    %{conv | path: "/pokemons"}
  end

  def rewrite_path(conv), do: conv
end
