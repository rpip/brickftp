defmodule BrickFTP.Folder do

  use BrickFTP.API, [:retrieve]
  use BrickFTP.FileOperation

  def endpoint do
    "folders"
  end

  @doc "Creates a folder"
  def create(path) do
    request(:post, "#{endpoint()}/#{path}")
  end

  @doc "Lists the contents of the folder provided in the URL"
  def list_contents(path, params) do
    request(:get, "#{endpoint()}/#{path}", params)
  end

  @doc """
  Count folder contents recursively

  Returns the combined total number of files and subfolders in
  a given folder recursively.
  """
  def count_contents_rs(path) do
    request(:get, "#{endpoint()}/#{path}", [action: :count])
  end

  @doc """
  Count folder contents non-recursively

  Returns the number of files and folders, separately, located inside
  a given folder (non-recursively)
  """
  def count_contents_nrs(path) do
    request(:get, "#{endpoint()}/#{path}", [action: :count_nrs])
  end

  @doc """
  Returns the size (in bytes) of the specified folder, recursively.
  """
  def get_size(path) do
    request(:get, "#{endpoint()}/#{path}", [action: :size])
  end
end
