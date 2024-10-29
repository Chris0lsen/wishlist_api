defmodule WishlistBe.Priorities do
  @moduledoc """
  The Priorities context.
  """

  import Ecto.Query, warn: false
  alias WishlistBe.Repo

  alias WishlistBe.Priorities.Priority

  @doc """
  Returns the list of priorities.

  ## Examples

      iex> list_priorities()
      [%Priority{}, ...]

  """
  def list_priorities do
    Repo.all(Priority)
  end

  @doc """
  Gets a single priority.

  Raises `Ecto.NoResultsError` if the Priority does not exist.

  ## Examples

      iex> get_priority!(123)
      %Priority{}

      iex> get_priority!(456)
      ** (Ecto.NoResultsError)

  """
  def get_priority!(id), do: Repo.get!(Priority, id)

  @doc """
  Creates a priority.

  ## Examples

      iex> create_priority(%{field: value})
      {:ok, %Priority{}}

      iex> create_priority(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_priority(attrs \\ %{}) do
    %Priority{}
    |> Priority.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a priority.

  ## Examples

      iex> update_priority(priority, %{field: new_value})
      {:ok, %Priority{}}

      iex> update_priority(priority, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_priority(%Priority{} = priority, attrs) do
    priority
    |> Priority.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a priority.

  ## Examples

      iex> delete_priority(priority)
      {:ok, %Priority{}}

      iex> delete_priority(priority)
      {:error, %Ecto.Changeset{}}

  """
  def delete_priority(%Priority{} = priority) do
    Repo.delete(priority)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking priority changes.

  ## Examples

      iex> change_priority(priority)
      %Ecto.Changeset{data: %Priority{}}

  """
  def change_priority(%Priority{} = priority, attrs \\ %{}) do
    Priority.changeset(priority, attrs)
  end
end
