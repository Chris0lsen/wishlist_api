defmodule WishlistBe.Wishlists do
  @moduledoc """
  The Wishlists context.
  """

  import Ecto.Query, warn: false
  alias WishlistBe.Repo

  alias WishlistBe.Wishlists.Wishlist
  alias WishlistBe.Games

  @doc """
  Returns the list of wishlists.

  ## Examples

      iex> list_wishlists()
      [%Wishlist{}, ...]

  """
  def list_wishlists do
    Repo.all(Wishlist)
  end

  @doc """
  Returns all wishlists for a given user

  ## Examples

      iex> list_wishlists_for_user(1)
      [%Wishlist{}, ...]
  """
  def list_wishlists_for_user_by_group(user_id) do
    query =
      from w in WishlistBe.Wishlists.Wishlist,
        join: g in assoc(w, :group),
        join: u in assoc(g, :users),
        where: u.id == ^user_id,
        select: w,
        preload: [group: g]

    Repo.all(query)
  end

  @doc """
  Gets a single wishlist.

  Raises `Ecto.NoResultsError` if the Wishlist does not exist.

  ## Examples

      iex> get_wishlist!(123)
      %Wishlist{}

      iex> get_wishlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wishlist!(id), do: Repo.get!(Wishlist, id)

  @doc """
  Gets a single wishlist, returning an :ok tuple

  Returns an :error tuple if the wishlist does not exist

  ## Examples

      iex> get_wishlist(123)
      {:ok, %Wishlist{}}

      iex> get_wishlist(456)
      {:error, :wishlist_not_found}
  """
  def get_wishlist(wishlist_id) do
    case Repo.get(Wishlist, wishlist_id) do
      nil -> {:error, :wishlist_not_found}
      wishlist -> {:ok, wishlist}
    end
  end
  @doc """
  Creates a wishlist.

  ## Examples

      iex> create_wishlist(%{field: value})
      {:ok, %Wishlist{}}

      iex> create_wishlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wishlist(attrs \\ %{}) do
    %Wishlist{}
    |> Wishlist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wishlist.

  ## Examples

      iex> update_wishlist(wishlist, %{field: new_value})
      {:ok, %Wishlist{}}

      iex> update_wishlist(wishlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wishlist(%Wishlist{} = wishlist, attrs) do
    wishlist
    |> Wishlist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Adds a game to a wishlist by its Steam id.

  ## Examples

      iex> add_game_to_wishlist(wishlist_id, steam_id)
      {:ok, %Wishlist{}}

      iex> add_game_to_wishlist(wishlist_id, bad_steam_id)
      {:error, $Ecto.Changeset{}}
  """
def add_game_to_wishlist_by_steam_id(wishlist_id, steam_id) do
  import Ecto.Query, warn: false

  Repo.transaction(fn ->
    with {:ok, wishlist} <- get_wishlist(wishlist_id),
         {:ok, game} <- Games.get_game_by_steam_id(steam_id) do

      # Preload the games association
      wishlist = Repo.preload(wishlist, :games)

      # Check if the game is already associated with the wishlist
      if Enum.any?(wishlist.games, &(&1.id == game.id)) do
        {:ok, wishlist}  # Game is already in the wishlist
      else
        # Create a changeset to add the game to the wishlist
        changeset =
          wishlist
          |> Ecto.Changeset.change()
          |> Ecto.Changeset.put_assoc(:games, [game | wishlist.games])

        case Repo.update(changeset) do
          {:ok, updated_wishlist} ->
            {:ok, updated_wishlist}

          {:error, changeset} ->
            Repo.rollback(changeset)
        end
      end
    else
      {:error, reason} ->
        Repo.rollback(reason)
    end
  end)
end




  @doc """
  Deletes a wishlist.

  ## Examples

      iex> delete_wishlist(wishlist)
      {:ok, %Wishlist{}}

      iex> delete_wishlist(wishlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wishlist(%Wishlist{} = wishlist) do
    Repo.delete(wishlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wishlist changes.

  ## Examples

      iex> change_wishlist(wishlist)
      %Ecto.Changeset{data: %Wishlist{}}

  """
  def change_wishlist(%Wishlist{} = wishlist, attrs \\ %{}) do
    Wishlist.changeset(wishlist, attrs)
  end
end
