defmodule BrickFTP.APIKeyTest do
  use ExUnit.Case, async: true

  alias BrickFTP.{APIKey, Fixture}
  alias BrickFTP.InvalidRequestError

  test "create/retrieve/delete an API key" do
    name = "My API key"
    fixture = %{
      "name"=> name,
      "permission_set"=> "full"
    }
    user = Fixture.User.random_user()

    assert {:ok, %{"name" => name} = api_key} = APIKey.create(user["id"], fixture)
    assert {:ok, %{"id" => id}} = APIKey.retrieve(to_string(api_key["id"]))

    assert {:ok, []} = APIKey.delete(to_string(api_key["id"]))
  end

  test "list all API keys" do
    user = Fixture.User.random_user()

    {:ok, resp} = APIKey.list(user["id"])
    assert is_list(resp)
  end
end
