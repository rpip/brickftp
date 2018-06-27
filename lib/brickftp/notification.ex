defmodule BrickFTP.Notification do
  use BrickFTP.API, [:list, :create, :delete]

  def endpoint do
    "notifications"
  end
end
