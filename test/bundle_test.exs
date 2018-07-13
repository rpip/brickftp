defmodule BrickFTP.BundleTest do
  use ExUnit.Case, async: true

  @password "samplePassword"
  @path "backup.zip"

  alias BrickFTP.{Bundle, Folder}

  setup_all do
    {:ok, folder} = Folder.create(@path)
    params = %{
      "paths" => [@path],
      "password": @password
    }

    assert {:ok, bundle} = Bundle.create(params)

    {:ok, bundle: bundle, folder: folder}
  end

  test "list/show a bundle", %{bundle: bundle} do
    assert {:ok, _resp} = Bundle.list()
    assert {:ok, _resp} = Bundle.retrieve(to_string(Enum.at(_resp, 0)["id"]))
  end

  test "download a bundle", %{bundle: bundle} do
    assert {:ok, _resp} = Bundle.download_zip(bundle["code"], @password)
    # assert {:ok, _resp} = Bundle.download_file(bundle["code"], @password, @path)
  end

  test "delete a bundle", %{bundle: bundle} do
    assert {:ok, _} = Bundle.delete(to_string(bundle["id"]))
    Folder.delete(@path)
  end
end
