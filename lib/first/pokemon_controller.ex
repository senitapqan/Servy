defmodule First.PokemonController do

  alias First.PokemonRepository
  def getPokemons(conv) do
    pokemons =
      PokemonRepository.list_pokemons
      |> Enum.filter(fn(p) -> p.type == "Water" end)
      |> Enum.sort(fn(p1, p2) -> p1.name <= p2.name end)
      |> Enum.map(fn(p) -> "#{p.name} - #{p.type} - #{p.evolution_stage} \n" end)
      |> Enum.join

    %{conv | resp_body: pokemons, status: 200}
  end

  def getPokemon(conv, id) do
    %{conv | resp_body: "Pokemon ##{id}", status: 200}
  end

  def createPokemon(conv, %{"name" => name, "type" => type}) do
    %{conv | resp_body: "Created a #{type} type pokemon named #{name}!", status: 200}
  end
end
