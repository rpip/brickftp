defmodule BrickFTP.PublicKey do
  use BrickFTP.API, [:retrieve, :delete]

  def endpoint do
    "public_keys"
  end

  @doc "Returns a list of all Public keys for a user on the current site."
  def list(user_id) do
    request(:get, "users/#{user_id}/#{endpoint()}")
  end

  def create(user_id, params) do
    url = "users/#{user_id}/#{endpoint()}"
    request(:post, url, params)
 end
end
