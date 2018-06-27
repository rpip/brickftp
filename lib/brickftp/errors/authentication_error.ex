defmodule BrickFTP.AuthenticationError do
  @moduledoc """
  Unauthorized: missing API key or invalid API key provided.
  """
  defexception type: "authentication_error", message: nil, code: nil, errors: nil
end
