defmodule WishlistBe.Wishlists do
  @moduledoc """
  The Wishlists context.
  """

  import Ecto.Query, warn: false
  alias WishlistBe.Repo

  alias WishlistBe.Wishlists.Wishlist

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
  def list_wishlists_for_user(user_id) do
    query =
      from w in Wishlist,
        where: w.user_id == ^user_id

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
