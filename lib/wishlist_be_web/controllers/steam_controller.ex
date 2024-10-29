defmodule WishlistBeWeb.SteamController do
  use WishlistBeWeb, :controller

  def search(conn, %{"term" => term}) do
    url = "https://store.steampowered.com/api/storesearch/"
    # Currency code and language will ventually come from i18n
    params = [term: term, cc: "US", l: "en"]

    # Make the HTTP request using Req

    case Req.get(url, params: params) do
      {:ok, %{status: 200, body: body}} ->
        # Successful response
        json(conn, body)


    {:ok, %{status: status, body: body}} ->
      # Non-200 response
      conn
      |> put_status(status)
      |> json(%{error: "Request failed with status #{status}", details: body})

    {:error, %{reason: reason}} ->
      # Error during the request
      conn
      |> put_status(:bad_gateway)
      |> json(%{error: "HTTP request failed", reason: inspect(reason)})

      end
  end

  def wishlist(conn, %{"steam_id" => steam_id, "cc" => cc}) do
    url = "https://store.steampowered.com/wishlist/profiles/#{steam_id}/wishlistdata?p=0&cc=#{cc}";

    # TODO pass cc and page num as params
    case Req.get(url) do
      {:ok, %{status: 200, body: body}} ->
        IO.inspect(body, label: "wishlist req")
        json(conn, body)

        {:ok, %{status: status, body: body}} ->
          # Non-200 response
          conn
          |> put_status(status)
          |> json(%{error: "Request failed with status #{status}", details: body})

        {:error, %{reason: reason}} ->
          # Error during the request
          conn
          |> put_status(:bad_gateway)
          |> json(%{error: "HTTP request failed", reason: inspect(reason)})

      end
    end
end
