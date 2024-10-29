defmodule WishlistBe.WishlistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WishlistBe.Wishlists` context.
  """

  @doc """
  Generate a wishlist.
  """
  def wishlist_fixture(attrs \\ %{}) do
    {:ok, wishlist} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> WishlistBe.Wishlists.create_wishlist()

    wishlist
  end
end
