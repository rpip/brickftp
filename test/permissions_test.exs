defmodule BrickFTP.PermissionTest do
  use ExUnit.Case, async: false

  alias BrickFTP.{Permission, Fixture}

  setup_all do
    assert {:ok, user} = Fixture.User.random_user()

    {:ok, user: user}
  end

  test "list/create/delete notification", %{user: user} do
    params = %{
      "path" => "a/b/c/d",
      "user_id" => user["id"],
      "permission" => "writeonly"
    }

    assert {:ok, _} = Permission.list()
    assert {:ok, perm} = Permission.create(params)
    assert {:ok, _} = Permission.delete(perm["id"])
  end
end
