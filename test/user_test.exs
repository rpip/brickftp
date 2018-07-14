defmodule BrickFTP.UserTest do
  use ExUnit.Case, async: false

  alias BrickFTP.{User, Fixture}

  @new_password "jdoe#{Fixture.random_num()}"

  setup_all do
    assert {user, password} = Fixture.new_user()

    {:ok, user: user, password: password}
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

  test "session required. update a user", %{user: user, password: password} do
    assert {:ok, _resp} = User.change_password(
      to_string(user["id"]), user["username"], password, @new_password)
  end

  test "delete a user", %{user: user} do
    assert {:ok, _resp} = User.delete_user(
      to_string(user["id"]), user["username"], @new_password)
  end
end
