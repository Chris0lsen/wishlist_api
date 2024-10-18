defmodule WishlistBeWeb.SearchController do
  use WishlistBeWeb, :controller

  def get(conn, %{"term" => term}) do
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
end
