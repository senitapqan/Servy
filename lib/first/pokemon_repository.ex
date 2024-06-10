defmodule First.PokemonRepository do
  alias First.Pokemon

  def list_pokemons do
    [
      %Pokemon{id: 1, name: "Pikachu", type: "Electric", evolution_stage: 1},
      %Pokemon{id: 2, name: "Charmeleon", type: "Fire", evolution_stage: 2},
      %Pokemon{id: 3, name: "Ivysaur", type: "Grass/Poison", evolution_stage: 2},
      %Pokemon{id: 4, name: "Wartortle", type: "Water", evolution_stage: 2},
      %Pokemon{id: 5, name: "Wigglytuff", type: "Normal/Fairy", evolution_stage: 2},
      %Pokemon{id: 6, name: "Persian", type: "Normal", evolution_stage: 2},
      %Pokemon{id: 7, name: "Golduck", type: "Water", evolution_stage: 2},
      %Pokemon{id: 8, name: "Machoke", type: "Fighting", evolution_stage: 2},
      %Pokemon{id: 9, name: "Golem", type: "Rock/Ground", evolution_stage: 3},
      %Pokemon{id: 10, name: "Vaporeon", type: "Water", evolution_stage: 2}
    ]
  end

  def get_pokemon(id) when is_integer(id) do
    Enum.find(list_pokemons(), fn(p) -> p.id == id end)
  end
end
