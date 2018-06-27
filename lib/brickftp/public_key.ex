defmodule BrickFTP.PublicKey do
  use BrickFTP.API, [:list, :retrieve, :create, :update]

  def endpoint do
    "public_keys"
  end
end
