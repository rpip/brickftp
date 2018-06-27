defmodule BrickFTP.Bundle do
  use BrickFTP.API, [:list, :retrieve, :create, :delete]
  import BrickFTP.Utils, only: [clean_dict: 1]

  def endpoint do
    "bundles"
  end

  @doc """
  Lists the contents of a bundle.
  This endpoint only reveals the public part of the file paths (i.e. relative to the root of the bundle)

  The password parameter is required only for bundles that are password-protected.
  If a bundle is password-protected and the password is missing or incorrect, an error
  message will specify that the correct password is required.

  For more details, see https://developers.brickftp.com/#list-bundle-contents
  """
  def list_contents(code, password \\ nil,  path \\ nil) do
    params = [code: code, password: password, path: path]
    request(:post, "#{endpoint()}/contents", clean_dict(params))
  end

  @doc """
  Provides a download URL to download a single file in the bundle.
  The download URL is a direct URL to Amazon S3 that has been signed by
  BrickFTP to provide temporary access to the file.
  The download links are valid for 3 minutes.

  For more details, see https://developers.brickftp.com/#download-one-file-in-a-bundle
  """
  def download_bundle_file(code, password \\ nil,  path \\ nil) do
    params = [code: code, password: password, path: path]
    request(:post, "#{endpoint()}/download", clean_dict(params))
  end

  def download_bundle_zip(code, password \\ nil) do
    params = [code: code, password: password]
    request(:post, "#{endpoint()}/zip", clean_dict(params))
  end
end
