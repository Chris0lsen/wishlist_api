defmodule WishlistBe.PrioritiesTest do
  use WishlistBe.DataCase

  alias WishlistBe.Priorities

  describe "priorities" do
    alias WishlistBe.Priorities.Priority

    import WishlistBe.PrioritiesFixtures

    @invalid_attrs %{priority: nil}

    test "list_priorities/0 returns all priorities" do
      priority = priority_fixture()
      assert Priorities.list_priorities() == [priority]
    end

    test "get_priority!/1 returns the priority with given id" do
      priority = priority_fixture()
      assert Priorities.get_priority!(priority.id) == priority
    end

    test "create_priority/1 with valid data creates a priority" do
      valid_attrs = %{priority: 42}

      assert {:ok, %Priority{} = priority} = Priorities.create_priority(valid_attrs)
      assert priority.priority == 42
    end

    test "create_priority/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Priorities.create_priority(@invalid_attrs)
    end

    test "update_priority/2 with valid data updates the priority" do
      priority = priority_fixture()
      update_attrs = %{priority: 43}

      assert {:ok, %Priority{} = priority} = Priorities.update_priority(priority, update_attrs)
      assert priority.priority == 43
    end

    test "update_priority/2 with invalid data returns error changeset" do
      priority = priority_fixture()
      assert {:error, %Ecto.Changeset{}} = Priorities.update_priority(priority, @invalid_attrs)
      assert priority == Priorities.get_priority!(priority.id)
    end

    test "delete_priority/1 deletes the priority" do
      priority = priority_fixture()
      assert {:ok, %Priority{}} = Priorities.delete_priority(priority)
      assert_raise Ecto.NoResultsError, fn -> Priorities.get_priority!(priority.id) end
    end

    test "change_priority/1 returns a priority changeset" do
      priority = priority_fixture()
      assert %Ecto.Changeset{} = Priorities.change_priority(priority)
    end
  end
end
