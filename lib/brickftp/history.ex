defmodule BrickFTP.History do
  use BrickFTP.API, [:list]
  import BrickFTP.Utils, only: [clean_dict: 1]

  def endpoint do
    "history"
  end

  @doc """
  Returns login history only. The history starts with the most recent
  entries and proceeds back in time. There is a maximum number of records
  that will be returned with a single request (default 1000 or whatever
  value you provide as the per_page parameter, up to a maximum of 10,000).

  For more details, see https://developers.brickftp.com/#retrieve-login-history
  """
  def login_history(page \\ nil, per_page \\ nil, start_at  \\ nil) do
    params = [page: page, per_page: per_page, start_at: start_at]
    request(:get, "#{endpoint()}/login", clean_dict(params))
  end

  @doc """
  Returns all history for a specific user. The history starts with the
  most recent entries and proceeds back in time. There is a maximum number
  of records that will be returned with a single request (default 1000 or
  whatever value you provide as the per_page parameter, up to a maximum of 10,000).

  For more details, see https://developers.brickftp.com/#retrieve-user-history
  """
  def user_history(user_id, page \\ nil, per_page \\ nil, start_at  \\ nil) do
    params = [page: page, per_page: per_page, start_at: start_at]
    request(:get, "#{endpoint()}/users/#{user_id}", clean_dict(params))
  end

  @doc """
  Returns all history for a specific folder.
  The history starts with the most recent entries and proceeds back in time.
  There is a maximum number of records that will be returned with a single request
  (default 1000 or whatever value you provide as the per_page parameter, up to a maximum of 10,000).

  For more details, see https://developers.brickftp.com/#retrieve-folder-history
  """
  def folder_history(path, page \\ nil, per_page \\ nil, start_at  \\ nil) do
    params = [page: page, per_page: per_page, start_at: start_at]
    request(:get, "#{endpoint()}/folders/#{path}", clean_dict(params))
  end

  @doc """
  Returns all history for a specific file.
  The history starts with the most recent entries and proceeds back in time.
  There is a maximum number of records that will be returned with a single request
  (default 1000 or whatever value you provide as the per_page parameter, up to a maximum of 10,000).
  For more details, see https://developers.brickftp.com/#retrieve-file-history
  """
  def file_history(path, page \\ nil, per_page \\ nil, start_at  \\ nil) do
    params = [page: page, per_page: per_page, start_at: start_at]
    request(:get, "#{endpoint()}/files/#{path}", clean_dict(params))
  end
end
