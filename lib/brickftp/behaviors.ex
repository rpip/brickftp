defmodule BrickFTP.Behavior do
  @default_folder_recursive 1

  use BrickFTP.API, [:list, :retrieve, :create, :delete, :update]

  def endpoint do
    "behaviors"
  end


  @doc """
  Returns the behaviors that apply to the given path.
  By default, only behaviors applied directly on the the given path will be returned.

  To include nherited behaviours from parent folders, set the recursive param to true.
  """
  def list_folder_behaviors(path, recursive \\ false) do
    path = "#{endpoint()}/folders/#{path}"
    case recursive do
      false ->
        request(:get, path, [recursive: @default_folder_recursive])
      true ->
        request(:get, path)
    end
  end
end
