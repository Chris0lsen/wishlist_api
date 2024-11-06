defmodule WishlistBeWeb.WishlistJSON do
  alias WishlistBe.Wishlists.Wishlist

  @doc """
  Renders a list of wishlists.
  """
  def index(%{wishlists: wishlists}) do
    %{data: Enum.map(wishlists, &data/1)}
  end

  @doc """
  Renders a single wishlist.
  """
  def show(%{wishlist: wishlist}) do
    %{data: data(wishlist)}
  end

  defp data(%Wishlist{} = wishlist) do
    base = %{
      id: wishlist.id,
      name: wishlist.name
    }

    if Ecto.assoc_loaded?(wishlist.group) do
      Map.put(base, :group, %{
        id: wishlist.group.id,
        name: wishlist.group.name
      })
    else
      base
    end
  end
end
