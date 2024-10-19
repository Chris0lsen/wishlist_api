# lib/steam_auth/steam.ex
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
    dbg()
    query = URI.encode_query(params)
    "#{@openid_endpoint}?#{query}"
  end

  def verify_openid_response(params) do
    IO.inspect("DOES THIS HAPPEN")
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
          IO.inspect(steam_id, label: "STEAM ID")
          {:ok, steam_id}
        else
          {:error, "Invalid OpenID response"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp extract_steam_id(claimed_id) do
    # Extract the SteamID from the claimed_id URL
    # Example claimed_id: https://steamcommunity.com/openid/id/76561197960435530
    [_, steam_id] = Regex.run(~r/^https?:\/\/steamcommunity\.com\/openid\/id\/(\d+)$/, claimed_id)
    steam_id
  end

  defp callback_url do
    # Return the URL where Steam should redirect back after authentication
    # Adjust the host and port as needed
    "http://192.168.68.90:4000/api/auth/steam/return"
  end

  defp realm do
    # The realm (or trust root) is the base URL of your application
    # Adjust the host and port as needed
    "http://192.168.68.90:4000/"
  end
end
