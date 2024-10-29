defmodule WishlistBe.PrioritiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WishlistBe.Priorities` context.
  """

  @doc """
  Generate a priority.
  """
  def priority_fixture(attrs \\ %{}) do
    {:ok, priority} =
      attrs
      |> Enum.into(%{
        priority: 42
      })
      |> WishlistBe.Priorities.create_priority()

    priority
  end
end
