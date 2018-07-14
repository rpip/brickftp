defmodule BrickFTP.FileTest do
  use ExUnit.Case, async: false

  alias BrickFTP.Fixture

  @copypath "sitemap-copy.txt"
  @movepath "sitemap-move.txt"

  setup_all do
    assert {:ok, file} = Fixture.new_file()

    {:ok, file: file}
  end

  test "download a file", %{file: file} do
    assert {:ok, _} = BrickFTP.File.download(file[:path])
  end

  test "copy a file", %{file: file} do
    assert {:ok, _} = BrickFTP.File.copy(file[:path], @copypath)
  end

  test "move a file", %{file: file} do
    assert {:ok, _} = BrickFTP.File.move(file[:path], @movepath)
  end

  test "delete a file" do
    assert {:ok, _} = BrickFTP.File.delete(@copypath)
    assert {:ok, _} = BrickFTP.File.delete(@movepath)
  end
end
