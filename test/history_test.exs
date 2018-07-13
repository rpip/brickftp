defmodule BrickFTP.HistoryTest do
  use ExUnit.Case, async: false

  alias BrickFTP.{Permission, Fixture}

  @filepath "hist.txt"
  @folderpath "hist"

  setup_all do
    assert {:ok, user} = Fixture.User.random_user()
    assert {:ok, folder} = Folder.create(@folderpath)

    {:ok, user: user, folder: folder}
  end

  test "get login/site/folder history", %{user: user} do
    assert {:ok, _} = History.login_history()
    assert {:ok, _} = History.user_history(user["id"])
    assert {:ok, _} = History.folder_history(@folderpath)

    assert {:ok, _} = Folder.delete(@folderpath)
  end

  test "get file history" do
  end
end
