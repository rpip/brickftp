defmodule BrickFTPTest do
  use ExUnit.Case
  doctest BrickFTP

  test "api connection error" do
    Application.put_env(:brickftp, :subdomain, "bftpex")
    assert {:error, %APIConnectionError{type: "api_connection_error"}} =
    # BrickFTP.Bundle.list()
    assert true
  end
end
