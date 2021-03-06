defmodule BrickFTP.FileOperation do
  defmacro  __using__(_opts) do
    import BrickFTP, only: [request: 2, request: 3]

    quote do
      @doc """
      Copy a file or folder
      For more details, see https://developers.brickftp.com/#file-and-folder-operations
      """
      def copy(src, copy_destination) do
        # TODO(yao): Add 'structure' param
        params = %{"copy-destination"=> copy_destination}
        request(:post, "/files/#{src}", params)
      end

      @doc """
      Moves or renames a file or folder to the destination provided in the
      move-destination parameter in the request body. Note that a move/rename will
      fail if the destination already exists.

      For more details, see https://developers.brickftp.com/#file-and-folder-operations
      """
      def move(src, move_destination) do
        params = %{"move-destination"=> move_destination}
        request(:post, "/files/#{src}", params)
      end

      @doc """
      Deletes a file or folder.

      Note that this operation works for both files and folders, but
      normally it will only work on empty folders. If you want to recursively
      delete a folder and all its contents, send the request with a Depth header
      with the value set to infinity.

      For more details, see https://developers.brickftp.com/#file-and-folder-operations
      """
      def delete(path) do
        request(:delete, "/files/#{path}")
      end
    end
  end
end

defmodule BrickFTP.FileOperation.Upload do
  import BrickFTP, only: [request: 3, request: 4]

  def endpoint, do: "files"

  @doc """
  Start a new upload by sending a request to API to
  indicate intent to upload a file.
  """
  def at(path) do
    request(:post, "#{endpoint()}/#{path}", %{action: :put})
  end

  @doc """
  Returns uploading URL for multi part uploading
  """
  def at(path, part_number, ref) do
    params = %{action: :put, ref: ref, part: part_number}
    request(:post, "#{endpoint()}/#{path}", params)
  end

  defp to_chunks(data, chunk_size) do
    data
    |> Stream.unfold(&String.split_at(&1, chunk_size))
    |> Enum.take_while(&(&1 != ""))
  end

  @doc """
  Upload the file to the URL(s) provided by the REST API, possibly in parts via
  multiple uploads.

  data is binary
  """
  # TODO(yao): support direct upload from IO devices. use streams
  def run(path, data, chunk_size) do
    # if chunk_size,
    # create chunks of data
    # generate upload_uri for each part of the chunked data
    # for each upload_uri, upload chunk
    # commit
    {firstref, _lasttref} =
      to_chunks(data, chunk_size)
      |> Enum.with_index
      |> Enum.map(fn {x, y} -> {x, y+1} end)
      |> Enum.reduce({nil, nil},
    fn {chunk, part}, {initial_ref, ref} ->
      if part > 2 do
        with {:ok, upload_info} <- at(path, part, ref),
        upload_uri = upload_info['upload_uri'],
        {:ok, _} <- upload(upload_uri, chunk) do
          {initial_ref, upload_info["ref"]}
        end
      else
        # TODO(yao): match 'with' error clauses
        with {:ok, upload_info} <- at(path),
        upload_uri = upload_info['upload_uri'],
        {:ok, _} <- upload(upload_uri, chunk) do
          ref1 = upload_info["ref"]
          {ref1, ref1}
        end
      end
    end)

  # end upload
  commit(path, firstref)
  end

  @doc """
  Upload the file to the URL provided by the REST API, in one go
  """
  def run(path, data) do
    with {:ok, upload_info} <- at(path),
         {:ok, _} <- upload(upload_info["upload_uri"], data) do

      # end upload
      commit(path, upload_info["ref"])
    end
  end

  # Upload data
  defp upload(upload_uri, data) do
    request(:put, upload_uri, data, [aws: true])
  end

  # Complete the upload by notifying the REST API that the file upload has completed.
  defp commit(path, ref) do
    request(:post, "#{endpoint()}/#{path}", %{action: :end, ref: ref})
  end
end
