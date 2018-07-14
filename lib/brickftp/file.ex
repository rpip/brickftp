defmodule BrickFTP.File do
  use BrickFTP.API, [:retrieve]
  use BrickFTP.FileOperation

  alias BrickFTP.FileOperation

  def endpoint do
    "files"
  end

  @doc """
  Upload file.
  For more details, see https://developers.brickftp.com/#file-uploading
  """

  def upload(path, source) do
    Task.async(fn -> FileOperation.Upload.run(path, source) end)
  end

  def upload(path, source, chunk_size) do
    Task.async(fn -> FileOperation.Upload.run(path, source, chunk_size) end)
  end

  @doc """
  Provides download URLs that will enable you to download the files in a bundle.
  """
  def download(path) do
    request(:get, "#{endpoint()}/files/#{path}")
  end

  def download(path, true) do
    request(:get, "#{endpoint()}/files/#{path}", [stats: true])
  end
end
