defmodule BrickFTP.APIConnectionError do
  @moduledoc """
  Failure to connect to BrickFTP's API.

  Network issues, timeouts etc
  """
  defexception [
    type: "api_connection_error",
    message: nil,
    code: nil
  ]
end
