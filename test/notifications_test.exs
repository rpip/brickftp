defmodule BrickFTP.NotificationTest do
  use ExUnit.Case, async: false

  alias BrickFTP.{Notification, Fixture}

  setup_all do
    user = Fixture.random_user()

    {:ok, user: user}
  end

  test "list/create/delete notification", %{user: user} do
    params = %{
      "path"=> "ab/cd",
      "user_id"=> user["id"]
    }

    assert {:ok, _} = Notification.list()
    assert {:ok, notification} = Notification.create(params)
    assert {:ok, _} = Notification.delete(to_string(notification["id"]))
   end
end
