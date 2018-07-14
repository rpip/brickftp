# Brickftp

BrickFTP Elixir REST API client.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `brickftp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:brickftp, "~> 0.1.0"}
  ]
end
```

### Configuration

```elixir
use Mix.Config

config :brickftp, subdomain: ...

config :logger, level: :debug

config :brickftp, api_key: ...
```

- Environment value `BRICK_FTP_SUBDOMAIN` is set to `subdomain`.
- Environment value `BRICK_FTP_API_KEY` is set to `api_key`.

### Authentication

To authenticate by API key, you must set the API key in your conig configuration.

Currently, reauthentication is required for the following actions:

* Changing the password of a User
* Deleting a User

```elixir
# Authenticate and set authentication session to configuration.
BrickFTP.Authentication.login("username", "password")

# log out
BrickFTP.Authentication.login()

# with_session to wrap API calls
with_session(username, password, fn -> ... end)
```

## Building docs

```
$ MIX_ENV=docs mix docs
```

### Running tests

Clone the repo and fetch its dependencies:

```
$ git clone https://gitlab.com/rpip/brickftp
$ cd brickftp
$ mix deps.get
$ export BrickFTP_API_KEY=....
$ export BrickFTP_SUBDOMAIN=...
$ mix test
```
