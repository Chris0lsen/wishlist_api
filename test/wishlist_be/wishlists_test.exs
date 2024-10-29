defmodule WishlistBe.WishlistsTest do
  use WishlistBe.DataCase

  alias WishlistBe.Wishlists

  describe "wishlists" do
    alias WishlistBe.Wishlists.Wishlist

    import WishlistBe.WishlistsFixtures

    @invalid_attrs %{name: nil}

    test "list_wishlists/0 returns all wishlists" do
      wishlist = wishlist_fixture()
      assert Wishlists.list_wishlists() == [wishlist]
    end

    test "get_wishlist!/1 returns the wishlist with given id" do
      wishlist = wishlist_fixture()
      assert Wishlists.get_wishlist!(wishlist.id) == wishlist
    end

    test "create_wishlist/1 with valid data creates a wishlist" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Wishlist{} = wishlist} = Wishlists.create_wishlist(valid_attrs)
      assert wishlist.name == "some name"
    end

    test "create_wishlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wishlists.create_wishlist(@invalid_attrs)
    end

    test "update_wishlist/2 with valid data updates the wishlist" do
      wishlist = wishlist_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Wishlist{} = wishlist} = Wishlists.update_wishlist(wishlist, update_attrs)
      assert wishlist.name == "some updated name"
    end

    test "update_wishlist/2 with invalid data returns error changeset" do
      wishlist = wishlist_fixture()
      assert {:error, %Ecto.Changeset{}} = Wishlists.update_wishlist(wishlist, @invalid_attrs)
      assert wishlist == Wishlists.get_wishlist!(wishlist.id)
    end

    test "delete_wishlist/1 deletes the wishlist" do
      wishlist = wishlist_fixture()
      assert {:ok, %Wishlist{}} = Wishlists.delete_wishlist(wishlist)
      assert_raise Ecto.NoResultsError, fn -> Wishlists.get_wishlist!(wishlist.id) end
    end

    test "change_wishlist/1 returns a wishlist changeset" do
      wishlist = wishlist_fixture()
      assert %Ecto.Changeset{} = Wishlists.change_wishlist(wishlist)
    end
  end
end
