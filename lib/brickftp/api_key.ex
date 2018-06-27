defmodule BrickFTP.APIKey do
  use BrickFTP.API, [:list, :retrieve, :create, :update]

  def endpoint do
    "api_keys"
  end
end
