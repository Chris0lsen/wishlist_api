defmodule WishlistBe.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias WishlistBe.Repo

  alias WishlistBe.Accounts.User

  alias WishlistBe.Accounts.RefreshToken

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

   @doc """
  Retrieves a user by their Steam ID or creates a new one if not found.

  ## Examples

      iex> get_or_create_user_by_steam_id("76561198077440039")
      {:ok, %User{}}

      iex> get_or_create_user_by_steam_id(nil)
      {:error, %Ecto.Changeset{}}

  """
  def get_or_create_user_by_steam_id(steam_id) when is_binary(steam_id) do
    case Repo.get_by(User, steam_id: steam_id) do
      nil ->
        %User{}
        |> User.changeset(%{steam_id: steam_id})
        |> Repo.insert()

      user ->
        {:ok, user}
    end
  end

  def get_or_create_user_by_steam_id(_invalid_steam_id) do
    {:error, :invalid_steam_id}
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def generate_refresh_token(user) do
    token = :crypto.strong_rand_bytes(64) |> Base.url_encode64()
    # 30 days
    expires_at = DateTime.add(DateTime.utc_now(), 60 * 60 * 24 * 30, :second)

    %RefreshToken{}
    |> RefreshToken.changeset(%{
      token: token,
      user_id: user.id,
      expires_at: expires_at
    })
    |> Repo.insert()
    |> case do
      {:ok, refresh_token} -> {:ok, refresh_token.token}
      error -> error
    end
  end

  def verify_refresh_token(token) do
    now = DateTime.utc_now()

    query =
      from rt in RefreshToken,
        where: rt.token == ^token and rt.revoked == false and rt.expires_at > ^now,
        preload: [:user]

    case Repo.one(query) do
      %RefreshToken{user: user} -> {:ok, user}
      _ -> {:error, :invalid_token}
    end
  end

  def revoke_refresh_token(token) do
    from(rt in RefreshToken, where: rt.token == ^token)
    |> Repo.update_all(set: [revoked: true])
  end

end
