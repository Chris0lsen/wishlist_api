defmodule WishlistBe.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WishlistBe.Games` context.
  """

  @doc """
  Generate a unique game steam_id.
  """
  def unique_game_steam_id, do: "some steam_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        name: "some name",
        steam_id: unique_game_steam_id()
      })
      |> WishlistBe.Games.create_game()

    game
  end
end
