defmodule WishlistBeWeb.GroupJSON do
  alias WishlistBe.Groups.Group

  @doc """
  Renders a list of groups.
  """
  def index(%{groups: groups}) do
    %{data: Enum.map(groups, &data/1)}
  end

  @doc """
  Renders a single group.
  """
  def show(%{group: group}) do
    %{data: data(group)}
  end

  defp data(%Group{} = group) do
    base = %{
      id: group.id,
      name: group.name
    }

    val = if Ecto.assoc_loaded?(group.wishlists) do
      Map.put(base, :wishlists, Enum.map(group.wishlists, &wishlist_data/1))
    else
      base
    end
    IO.inspect(val)
  end

  defp wishlist_data(wishlist) do
    %{
      id: wishlist.id,
      name: wishlist.name
      # Include other fields if necessary
    }
  end
end
