defmodule BrickFTP.Group do
  use BrickFTP.API, [:list, :create, :retrieve, :update, :delete]

  def endpoint do
    "groups"
  end

  @doc """
  Creates a new user within a specified group

  For more details, see https://developers.brickftp.com/#create-a-user-in-a-group
  """
  def create_user_in_group(params, group_id) do
    # TODO(yao): validate params. only some attrs allowed
    request(:post, "#{endpoint()}/#{group_id}/users", params)
  end

  @doc """
  Adds a user to a group. By default, the member will not be an admin.
  If the user is already a member of the group, their attributes will
  be updated to match the request.
  """
  def add_member(group_id, user_id) do
    request(:put, "#{endpoint()}/#{group_id}/memberships/#{user_id}", %{})
  end

  @doc """
  Last param indicates whether the user is an administrator of the group.
  """
  def add_member(group_id, user_id, true) do
    url = "#{endpoint()}/#{group_id}/memberships/#{user_id}"
    params = [memberships: [admin: true]]
    request(:put, url, params)
  end

  @doc """
  Updates a user's group membership
  For more details, see https://developers.brickftp.com/#update-a-member
  """
  def update_member(group_id, user_id, is_admin) do
    url = "#{endpoint()}/#{group_id}/memberships/#{user_id}"
    params = [memberships: [admin: is_admin]]
    request(:patch, url, params)
  end

  @doc "Removes a user from a group."
  def delete_member(group_id, user_id) do
    request(:delete, "#{endpoint()}/#{group_id}/memberships/#{user_id}")
  end
end
