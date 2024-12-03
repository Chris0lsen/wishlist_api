defmodule WishlistBeWeb.GameJSON do
  alias WishlistBe.Games.Game

  @doc """
  Renders a list of games.
  """
  def index(%{games: games}) do
    %{data: Enum.map(games, &data/1)}
  end

  @doc """
  Renders a single game.
  """
  def show(%{game: game}) do
    %{data: data(game)}
  end

  defp data(%Game{} = game) do
    %{
      id: game.id,
      name: game.name,
      steam_id: game.steam_id
    }
  end
end
