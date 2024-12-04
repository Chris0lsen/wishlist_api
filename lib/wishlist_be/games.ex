defmodule WishlistBe.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias WishlistBe.Repo

  alias WishlistBe.Games.Game
  alias WishlistBe.Steam

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
    Returns all games for a given wishlist.

    ## Examples

        iex> list_games_for_wishlist(wishlist_id)
        {:ok, %Game{}}

    """
  def list_games_for_wishlist(wishlist_id) do
    query =
      from g in WishlistBe.Games.Game,
        join: w in assoc(g, :wishlists),
        where: w.id == ^wishlist_id,
        select: g,
        preload: [wishlists: w]

    Repo.all(query)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Gets a single game by its Steam id, returning an :ok tuple

  Returns an :error tuple if the game does not exist

  ## Examples

      iex> get_game_by_steam_id(123)
      {:ok, %Game{}}

      iex> get_game_by_steam_id(456)
      {:error, :game_not_found}
  """

  def get_game_by_steam_id(steam_id) do
    case Repo.get_by(Game, steam_id: steam_id) do
      nil -> create_game_from_steam_id(steam_id)
      game -> {:ok, game}
    end
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  defp create_game_from_steam_id(steam_id) do
    case Steam.get_game_by_id(steam_id) do
      {:ok, %{id: steam_id, name: name}} -> create_game(%{steam_id: steam_id, name: name})
      _ -> nil
    end
  end
end
