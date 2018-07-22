defmodule BrickFTP do
  @moduledoc """
  Documentation for BrickFTP.
  """
  @client_version Mix.Project.config()[:version]
  @useragent "BrickFTP/v1 brickftp-elixir/#{@client_version}"

  @default_content_type "text/html"
  @accept_headers [
    json: "application/json",
    xml: "application/xml",
    html: "text/html",
    excel: "application/vnd.ms-excel",
    csv: "text/csv"
  ]

  @base_headers [
    {"User-Agent", @useragent},
    {"Content-Type", "application/json"},
    {"Accept", "application/json"}
  ]

  @missing_key_error_message """
  The api_key settings is required to use BrickFTP. Please include your
  BrickFTP api key in your application config file like so:
  config :brickftp, api_key: YOUR_API_KEY

  Alternatively, you can also set the API key as an environment variable:
  BrickFTP_API_KEY=YOUR_API_KEY
  """

  alias BrickFTP.Authentication
  alias BrickFTP.{
    APIError,
    PermissionError,
    AuthenticationError,
    InvalidRequestError,
    APIConnectionError
  }

  def version do
    @client_version
  end

  def request(action, endpoint, data \\ %{}, opts \\ []) do
    headers = create_headers(opts)

    cond do
      action in [:get, :delete] ->
        url = request_url(endpoint, data)
        HTTPoison.request(action, url, "", headers, build_opts(opts))
        |> handle_response

      action in [:post, :put, :patch] ->
        # if binary, set content-length, don't encode binary data
        headers =
          case is_binary(data) do
            true ->
              [{"Content-Length", byte_size(data)} | headers]
            _ ->
              headers
          end

        headers =
            case Keyword.has_key?(opts, :aws) do
              true ->
                h = :proplists.delete("Authorization", headers)
                [{"Content-Length", byte_size(data)} | h]
              _ ->
                headers
            end

        data = if Keyword.has_key?(opts, :aws), do: data, else: Poison.encode!(data)

        HTTPoison.request(action, request_url(endpoint), data, headers, build_opts(opts))
        |> handle_response
    end
  end

  ## private methods

  # For more details, see https://developers.brickftp.com/#request-and-response-format
  defp content_type(headers) do
    case List.keyfind(headers, "Content-Type", 0) do
      {_, type} ->
        xs = @accept_headers
        Enum.reduce(xs, %{}, fn {k, v}, acc -> Map.put(acc, v, k) end)
        |> Map.get(type)
      _ ->
        @default_content_type
    end
  end

  defp handle_response({:ok, %{body: body, status_code: code, headers: headers}})
  when code in [200, 201] do
    {:ok, parse_response_body(body, content_type(headers))}
  end

  defp handle_response({:ok, %{body: body, status_code: code, headers: headers}} = _req) do
    response = body |> parse_response_body(content_type(headers))
    message = Map.get(response, "error")
    errors = Map.get(response, "errors")

    error_struct =
      case code do
        code when code in [400, 422, 404] ->
          %InvalidRequestError{errors: errors, code: code}
        401 ->
          %AuthenticationError{errors: errors}
        403 ->
          %PermissionError{message: message}
        _ ->
          %APIError{message: message}
      end

    {:error, %{error_struct | code: code, message: message}}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    %APIConnectionError{message: "Network Error: #{reason}"}
  end

  defp parse_response_body(body, :json) do
    Poison.decode!(body)
  end

  defp parse_response_body(body, _) do
    body
  end

  # Access key of API. Get value from enviroment variable `BrickFTP_API_KEY`
  # If not set in environment, look in application env
  def get_api_key do
    System.get_env("BrickFTP_API_KEY") || Application.get_env(:brickftp, :api_key) ||
      raise AuthenticationError, message: @missing_key_error_message
  end

  # Subdomain of API endpoint. If not specified, get value from enviroment variable `BrickFTP_SUBDOMAIN`.
  defp subdomain do
    System.get_env("BrickFTP_SUBDOMAIN") || Application.get_env(:brickftp, :subdomain)
  end

  defp get_api_endpoint do
    "https://#{subdomain()}.brickftp.com/api/rest/v1/"
  end

  defp request_url("http" <> _ = url), do: url

  defp request_url(endpoint) do
    Path.join(get_api_endpoint(), endpoint)
  end

  defp request_url(endpoint, []) do
    Path.join(get_api_endpoint(), endpoint)
  end

  defp request_url(endpoint, data) do
    base_url = request_url(endpoint)
    query_params = BrickFTP.Utils.encode(data)
    "#{base_url}?#{query_params}"
  end

  @doc "Wraps the callback in an authenticated session"
  def with_session(username, password, callback) do
    Authentication.login(username, password)
    response = callback.()
    Authentication.logout

    # return response
    response
  end

  @doc """
  Builds the request headers, some based on info in the opts.

  Sets the Accept header to the :accept type in `opts`.
  For the response, the REST API normally looks at the file extension
  (.json or .xml) or the Accept header in the request.
  However, for requests sent to the /files and /folders interfaces
  (and other endpoints that include the path name directly, such as
  /history/files and /history/folders), any file extension is assumed
  to be part of the file name being operated on and does not
  affect the response format.
  """
  def create_headers(opts) do
    headers =
      case Keyword.has_key?(opts, :session) do
        false ->
          basic_auth = "Basic " <> Base.encode64("#{get_api_key()}:x")
          [{"Authorization", basic_auth} | @base_headers]
        _ ->
          case Keyword.has_key?(opts, :reauth) do
            false ->
              @base_headers
            _ ->
              reauth_password = Keyword.pop(opts, :reauth)
              reauth_header = {"X-BRICK-REAUTHENTICATION", "password:#{reauth_password}"}
              [reauth_header| @base_headers]
          end
      end

    # set Accept header
    case Keyword.get(opts, :accept) do
      false ->
        headers
      accept ->
        List.keyreplace(headers, "Accept", 0, {"Accept", @accept_headers[accept]})
    end
  end

  # set authentication cookie
  defp build_opts(opts) do
    case Keyword.has_key?(opts, :session) do
      false ->
        opts
      _ ->
        case Application.get_env(:brickftp, :session) do
          nil ->
            opts
          session ->
            [hackney: [cookie: ["BrickAPI=#{session}"]]]
            |> Keyword.merge(opts)
        end
    end
  end
end
