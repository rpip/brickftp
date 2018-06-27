defmodule BrickFTP.InvalidRequestError do
  @moduledoc """
  Bad Request: often due to missing a required parameter

  Also for when resource Not Found.
  """
  defexception [
    type: "invalid_request_error",
    message: nil,
    code: nil,
    errors: nil
  ]
end
