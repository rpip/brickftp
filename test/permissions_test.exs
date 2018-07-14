defmodule BrickFTP.PermissionTest do
  use ExUnit.Case, async: false

  alias BrickFTP.{Permission, Fixture, User}

  setup_all do
    {user, password} = Fixture.new_user()

    {:ok, user: user, password: password}
  end

  test "list/create/delete permission", %{user: user, password: password} do
    params = %{
      "path" => "ab/cd",
      "user_id" => user["id"],
      "permission" => "writeonly"
    }

    assert {:ok, _} = Permission.list()
    assert {:ok, perm} = Permission.create(params)
    assert {:ok, _} = Permission.delete(to_string(perm["id"]))

    User.delete_user(to_string(user["id"]), user["username"], password)
  end
end
