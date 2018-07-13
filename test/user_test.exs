defmodule BrickFTP.UserTest do
  use ExUnit.Case, async: true

  @username "doejohn#{:rand.uniform(100)}"
  @password "doejohn#{:rand.uniform(100)}"
  @new_change_password "doejohn#{:rand.uniform(100)}"

  alias BrickFTP.User

  setup_all do
    assert {:ok, user} = User.create_user(@username, @password)

    {:ok, user: user}
  end

  test "list/count/search/show user", %{user: user} do
    assert {:ok, users} = User.list()

    assert {:ok, resp} = User.count()

    assert {:ok, _resp} = User.search(user["username"])

    assert {:ok, _resp} = User.retrieve(to_string(user["id"]))
  end

  test "unlock user", %{user: user} do
    assert {:ok, _resp} = User.unlock(user["id"])
  end

  test "update a user", %{user: user} do
    assert {:ok, _resp} = User.change_password(
      to_string(user["id"]), @password, @new_change_password)
  end

  test "delete a user", %{user: user} do
    assert {:ok, _resp} = User.delete_user(to_string(user["id"]), @password)
  end
end
