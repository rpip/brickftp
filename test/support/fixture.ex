defmodule BrickFTP.Fixture do

  alias BrickFTP.{User, Folder, Fixture}

  def random_user() do
    {:ok, [h|_] = _users} = User.list()
    h
  end

  def new_user() do
    password = "@pass#{random_num()}"
    {:ok, user} = User.create_user("user#{random_num()}", "#{password}")
    {user, password}
  end

  def new_file() do
    data = File.read!("test/fixtures/sitemap.txt")
    # task = BrickFTP.File.upload("#{random_num()}.txt", data)
    # Task.await(task)
     BrickFTP.FileOperation.Upload.run("#{random_num()}.txt", data)
  end

  def new_folder() do
    Folder.create("#{random_num()}")
  end

  def random_num() do
    :rand.uniform(1000000)
  end
end
