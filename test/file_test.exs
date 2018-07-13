defmodule BrickFTP.FileTest do
  use ExUnit.Case, async: false

  @path "sitemap.txt"
  @newpath "sitemap-2.txt"

  setup_all do
    data = File.read!("test/fixtures/sitemap.txt")

    assert {:ok, file} = BrickFTP.File.upload(@path, data)

    {:ok, file: file}
  end

  test "download a file" do
    assert {:ok, _} = BrickFTP.File.download(@path)
  end

  test "copy a file" do
    assert {:ok, _} = BrickFTP.File.copy(@path, @newpath)
  end

  test "move a file" do
    assert {:ok, _} = BrickFTP.File.move(@path, @newpath)
  end

  test "delete a file" do
    assert {:ok, _} = BrickFTP.File.delete(@path)
    assert {:ok, _} = BrickFTP.File.delete(@newpath)
  end
end
