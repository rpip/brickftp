defmodule BrickFTP.Permission do
  use BrickFTP.API, [:list, :create, :delete]

  def endpoint do
    "permissions"
  end
end
