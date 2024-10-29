defmodule WishlistBeWeb.Plugs.AuthPlug do
  import Plug.Conn
  alias WishlistBe.Token

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> jwt] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Token.verify_and_validate(jwt, Token.signer()) do
      assign(conn, :current_user, claims)
    else
      _ ->
        conn
        |> send_resp(:unauthorized, "Unauthorized")
        |> halt()
    end
  end
end
