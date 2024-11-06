defmodule WishlistBeWeb.FallbackController do
  use WishlistBeWeb, :controller

  # Handle changeset errors
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("error.json", changeset: changeset)
  end

  # Handle not found errors
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render("404.json", message: "Not found")
  end
end
