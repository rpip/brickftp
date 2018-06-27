defmodule BrickFTP.APIConnectionError do
  @moduledoc """
  Failure to connect to BrickFTP's API.
  """
  defexception type: "api_connection_error", message: nil
end
