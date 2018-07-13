defmodule BrickFTP.FolderTest do
  use ExUnit.Case, async: false

  alias BrickFTP.Folder

  @path "foo"
  @copypath "foo-copy"
  @movepath "foo-move"

  setup_all do
    assert {:ok, folder} = Folder.create(@path)

    {:ok, folder: folder}
  end

  test "count folder contents", %{folder: folder} do
    # count recursively
    assert {:ok, _} = Folder.count_contents_rs(@path)

    # non-recursively
    assert {:ok, _} = Folder.count_contents_nrs(@path)
  end

  test "get folder size" do
    assert {:ok, _} = Folder.get_size(@path)
  end

  test "copy a folder" do
    assert {:ok, _} = Folder.copy(@path, @copypath)
  end

  test "move a folder" do
    assert {:ok, _} = Folder.move(@path, @movepath)
  end

  test "delete a folder" do
    assert {:ok, _} = Folder.delete(@copypath)
    assert {:ok, _} = Folder.delete(@movepath)
  end
end
