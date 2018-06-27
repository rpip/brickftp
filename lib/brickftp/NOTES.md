# defprotocol BrickFTP.FileOperation do

#   @moduledoc "Handles file and folder operations"

#   @doc """
#   Copies a file or folder to the destination provided in the
#   copy-destination parameter in the request body. Note that a copy will fail
#   if the destination already exists.

#   Optionally, provide the parameter structure and set it to any value
#   to only copy the folder structure without copying any files.

#   For more details, see https://developers.brickftp.com/#copy-a-file-or-folder
#   """

#   def copy(src, destination)

#   @doc """
#   Moves or renames a file or folder to the destination provided in the
#   move-destination parameter in the request body. Note that a move/rename will
#   fail if the destination already exists.

#   For more details, see https://developers.brickftp.com/#move-or-rename-a-file-or-folder
#   """
#   def move(src, destination)

#   @doc """
#   Deletes a file or folder.

#   Note that this operation works for both files and folders, but
#   normally it will only work on empty folders. If you want to recursively
#   delete a folder and all its contents, send the request with a Depth header
#    with the value set to infinity.
#   """
#   def delete(path)
# end

# defimpl BrickFTP.FileOperation, for: File do
#   use BrickFTP.FileOperation.Shared
# end

# defimpl BrickFTP.FileOperation, for: Folder do
#   use BrickFTP.FileOperation.Shared
# end
