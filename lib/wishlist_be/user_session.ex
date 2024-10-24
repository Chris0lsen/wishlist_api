defmodule WishlistBe.UserSession do
  use GenServer

  @table_name :user_sessions

  # Public API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def store_user_session(session_token, user_data) do
    :ets.insert(@table_name, {session_token, user_data})
    :ok
  end

  def get_user_session(session_token) do
    case :ets.lookup(@table_name, session_token) do
      [{^session_token, user_data}] -> {:ok, user_data}
      [] -> {:error, :not_found}
    end
  end

  def delete_user_session(session_token) do
    :ets.delete(@table_name, session_token)
    :ok
  end

  # GenServer Callbacks

  def init(_args) do
    :ets.new(@table_name, [:named_table, :public, :set, {:read_concurrency, true}])
    {:ok, %{}}
  end
end
