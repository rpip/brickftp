defmodule BrickFTP.GroupTest do
  use ExUnit.Case, async: true

  alias BrickFTP.{Group, Fixture}
  alias BrickFTP.InvalidRequestError

  test "create/retrieve/update/delete an Group" do
    name = "Accra Office 11"
    fixture = %{
      "name" => name,
      "user_ids"=> "3,7,9"
    }

    user = Fixture.User.random_user()

    # IO.puts user

    # unknown user ids
    assert {:error, %InvalidRequestError{"code": 422}} = Group.create(fixture)

    assert {:ok, %{"name" => name} = group} =
      Group.create(%{fixture| "user_ids" => to_string(user["id"])})
    assert {:ok, %{"id" => id}} = Group.retrieve(to_string(group["id"]))

    update_params = %{"user_ids" => to_string(user["id"])}
    assert {:ok, _resp} = Group.update(to_string(id), update_params)

    params = %{
      "user" => %{
    "username"=> "janesmith211",
    "email"=> "janesmith211@example.com"
   }}
    assert {:ok, _resp} = Group.create_user_in_group(params, id)

    # add a member
    user = Fixture.User.random_user()
    assert {:ok, _resp} = Group.add_member(id, user["id"])

    # update a member
    {:ok, _resp} = Group.update_member(id, user["id"], true)

    # remove member
    {:ok, _resp} = Group.remove_member(id, user["id"])
  end
end
