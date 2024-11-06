defmodule WishlistBe.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias WishlistBe.Repo

  alias WishlistBe.Groups.Group

  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Returns all groups for the given user, optionally with wishlists.

  ## Examples

      iex> list_groups_for_user(123)
      [%Group{}]

      iex> list_groups_for_user(123, preload_wishlists: true)
      [%Group{wishlists: [...]}, ...]

  """
  def list_groups_for_user(user_id, opts \\ []) do
    preloads =
      if Keyword.get(opts, :preload_wishlists, false) do
        [:wishlists]
      else
        []
      end

    Group
    |> join(:inner, [g], u in assoc(g, :users))
    |> where([g, u], u.id == ^user_id)
    |> preload(^preloads)
    |> Repo.all()
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id)

  @doc """
  Gets a single group, returning an :ok tuple

  ## Examples

      iex> get_group(123)
      {:ok, %Group{}}

      iex> get_group!(456)
      {:error, Ecto.NoResultsError}

  """
  def get_group(id), do: Repo.get(Group, id)

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end
end
