defmodule BrickFTP.BehaviorTest do
  use ExUnit.Case, async: true

  alias BrickFTP.Behavior
  alias BrickFTP.InvalidRequestError

  test "create/update a behavior" do
    value = ["https://d.mywebhookhandler.com"]
    fixture = %{
      "path" => "cloud/images",
      "behavior" => "webhook",
      "value" => value
    }

    assert {:ok, %{"value" => value} =  behavior} = Behavior.create(fixture)
    assert {:ok, %{"id" => id, "value" => value}} = Behavior.update(
      behavior["id"], value: ["http://brickftp.com"])
  end

  test "retrieve a behavior" do
    assert {:error, %InvalidRequestError{message: "id is invalid"}}
    = Behavior.retrieve("not exist")
  end

  test "list all behaviors" do
    {:ok, resp} = Behavior.list
    assert is_list(resp)
  end
end
