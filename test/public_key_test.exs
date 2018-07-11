defmodule BrickFTP.PublicKeyTest do
  use ExUnit.Case, async: true

  alias BrickFTP.{PublicKey, Fixture}
  alias BrickFTP.InvalidRequestError

  test "create/retrieve/delete an Public key" do
    title = "testing my new key"
    fixture = %{
      "title"=> title,
      "public_key": "ssh-rsa AAAAB3NzoC1yc2EAAAADAQABAAABAQCnq8wc58VxUmBF75IIPrvol2Hc4+J1mrI6C+6xwlfv62n21ITeumZpMpR6UNIOjyo4bCC8/BZOsiAYn7UXmyYzrlIsX5IuSO1KvG+k+/vRBPexua1s3/kKWRGAloqNBsmoRTun5OgSMp++NaUTDJGRYenzgXKtCWXwGK5iQ0UCAvuhNDx+GhOcSVPzLweBx/h7Sy2EPZhFNf5Ex1fucAaBvxvKLyOqAieLzIIuyCCN5shqxXyH602QYg+JurTqYKB/FaCRA1+1w4uzxAAzaQuUyMS3clmySGiaq9LbvAIw0rItGU31AWyyaCuHmzI3642ShMDDS7tnfZQvWpoykcbF"
    }

    user = Fixture.User.random_user()

    assert {:ok, %{"title" => title} = pub_key} = PublicKey.create(user["id"], fixture)
    assert {:ok, %{"id" => id}} = PublicKey.retrieve(to_string(pub_key["id"]))

    assert {:ok, []} = PublicKey.delete(to_string(pub_key["id"]))
  end

  test "list all Public keys" do
    user = Fixture.User.random_user()

    {:ok, resp} = PublicKey.list(user["id"])
    assert is_list(resp)
  end
end
