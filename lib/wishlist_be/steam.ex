defmodule WishlistBe.Steam do
  @openid_endpoint "https://steamcommunity.com/openid/login"

  def generate_openid_redirect_url do
    params = [
      {"openid.ns", "http://specs.openid.net/auth/2.0"},
      {"openid.mode", "checkid_setup"},
      {"openid.return_to", callback_url()},
      {"openid.realm", realm()},
      {"openid.identity", "http://specs.openid.net/auth/2.0/identifier_select"},
      {"openid.claimed_id", "http://specs.openid.net/auth/2.0/identifier_select"}
    ]

    query = URI.encode_query(params)
    "#{@openid_endpoint}?#{query}"
  end

  def verify_openid_response(params) do
    params = Enum.into(params, %{})

    verification_params = [
      {"openid.assoc_handle", params["openid.assoc_handle"]},
      {"openid.signed", params["openid.signed"]},
      {"openid.sig", params["openid.sig"]},
      {"openid.ns", params["openid.ns"]}
    ]

    signed_params =
      params["openid.signed"]
      |> String.split(",")
      |> Enum.map(fn field ->
        {"openid." <> field, params["openid." <> field]}
      end)

    verification_params = verification_params ++ signed_params
    verification_params = verification_params ++ [{"openid.mode", "check_authentication"}]

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    body = URI.encode_query(verification_params)

    case Req.post(@openid_endpoint, body: body, headers: headers) do
      {:ok, %{body: response_body}} ->
        if String.contains?(response_body, "is_valid:true") do
          steam_id = extract_steam_id(params["openid.claimed_id"])
          {:ok, steam_id}
        else
          {:error, "Invalid OpenID response"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def frontend_redirect_url(steam_id \\ nil) do
    url = get_config_url(:frontend)
    query = URI.encode_query(%{steam_id: steam_id})
    URI.to_string(%{url | query: query})
  end

  defp extract_steam_id(claimed_id) do
    # Extract the SteamID from the claimed_id URL
    [_, steam_id] = Regex.run(~r/^https?:\/\/steamcommunity\.com\/openid\/id\/(\d+)$/, claimed_id)
    steam_id
  end

  defp callback_url do
    url = get_config_url(:backend)
    URI.to_string(url)
  end

  defp realm do
    # The realm (or trust root) is the base URL of your application
    url = get_config_url(:backend)

    %{url | path: nil, query: nil}
    |> URI.to_string()
  end

  def get_config_url(type) do
    config = Application.get_env(:wishlist_be, :urls)[type]

    %URI{
      scheme: config[:scheme],
      host: config[:host],
      port: config[:port],
      path: config[:path]
    }
  end
end
