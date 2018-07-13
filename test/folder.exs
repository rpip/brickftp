defmodule BrickFTP.Folder do
  use ExUnit.Case, async: true

  @path "Images"
  @newpath "Images2"

  setup do
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
    assert {:ok, _} = Folder.copy(@path, @newpath)
  end

  test "move a folder" do
    assert {:ok, _} = Folder.move(@path, @newpath)
  end

  test "delete a folder" do
    assert {:ok, _} = Folder.delete(@path)
    assert {:ok, _} = Folder.delete(@newpath)
  end
end
