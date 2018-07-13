defmodule BrickFTP.User do
  use BrickFTP.API, [:list, :retrieve, :update]

  def endpoint do
    "users"
  end

  def count() do
    request(:get, endpoint(), [action: "count"])
  end

  def search(username) do
    request(:get, endpoint(), [q: [username: username]])
  end

  def create_user(username, password) do
    request(:post, endpoint(), %{"username"=> username, "password"=> password})
  end

  @doc """
  Updates the specified user.
  For additional security, this method requires reauthentication when
  updating a password unless an API key is used.

  For more details see https://developers.brickftp.com/#update-a-user
  """
  def change_password(id, current_password, new_password) do
    params = %{
      "password"=> new_password,
      "require_password_change" => true
    }
    update(id, params, [reauth: current_password])
  end

  @doc """
   Deletes the specified user.
   For additional security, this method requires reauthentication when
   updating a password unless an API key is used
   For more details see https://developers.brickftp.com/#delete-a-user
  """
  def delete_user(id, current_password) do
    resource_url = Path.join(endpoint(), id)
    request(:delete, resource_url, %{}, [reauth: current_password])
  end

  @doc """
  Unlocks a user that has been locked out by Brute Force Login Protection.
  """
  def unlock(user_id) do
    request(:post, "#{endpoint()}/#{user_id}/unlock")
  end
end
