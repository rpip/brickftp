defmodule BrickFTP.HistoryTest do
  use ExUnit.Case, async: false

  alias BrickFTP.{History, Fixture, Folder, File}

  @folderpath "hist#{Fixture.random_num()}"

  setup_all do
    {:ok, file} = Fixture.new_file()

    {:ok, folder} = Folder.create(@folderpath)
    user = Fixture.random_user()

    {:ok, user: user, folder: folder, file: file}
  end

  test "get login/site/folder history", %{user: user, file: file, folder: folder} do
    assert {:ok, _} = History.login_history()
    assert {:ok, _} = History.user_history(to_string(user["id"]))
    assert {:ok, _} = History.folder_history(folder[:path])
    assert {:ok, _} = History.file_history(file[:path])

    # assert {:ok, _} = File.delete(file[:path])
    #assert {:ok, _} = Folder.delete(folder[:path])
  end
end
