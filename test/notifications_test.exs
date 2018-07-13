defmodule BrickFTP.NotificationTest do
  use ExUnit.Case, async: false

  alias BrickFTP.{Notification, Fixture}

  setup_all do
    assert {:ok, user} = Fixture.User.random_user()

    {:ok, user: user}
  end

  test "list/create/delete notification", %{user: user} do
    params = %{
      "path"=> "a/b/c/d",
      "user_id"=> user["id"]
    }

    assert {:ok, _} = Notification.list()
    assert {:ok, notification} = Notification.create(params)
    assert {:ok, _} = Notification.delete(notification["id"])
   end
end
