defmodule BrickFTP.Fixture.User do

  alias BrickFTP.User

  def random_user() do
    {:ok, [h|_] = _users} = User.list()
    h
  end
end
