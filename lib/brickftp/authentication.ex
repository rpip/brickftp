defmodule BrickFTP.Authentication do
  import BrickFTP, only: [request: 3]

  defmodule Session do
    use BrickFTP.API, [:create, :delete]

    def endpoint, do: "sessions"

    def destroy do
      request(:delete, "#{endpoint()}", %{}, [session: true])
      Application.delete_env(:brickftp, :session)
    end
  end

  @doc """
  Login with the user’s username and password, and store authentication session.
  For more details see https://developers.brickftp.com/#authentication-with-a-session
  """
  def login(username, password) do
    params = %{"username"=> username, "password"=> password}
    {:ok, %{"id"=> session}} = Session.create(params, [session: true])
    Application.put_env(:brickftp, :session, session)
  end

  @doc """
  Logout and discard authentication session.

  Returns true if there's active session, otherwise returns false.
  For more details see https://developers.brickftp.com/#authentication-with-a-session
  """
  def logout do
    case Application.get_env(:brickftp, :session) do
      nil ->
        false
      _ ->
        Session.destroy
        true
    end
  end
end
