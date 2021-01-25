defmodule Issues.GithubIssues do

  @user_agent [ {"User-agent", "MarinV0321 marin.lff@libero.it"} ]


  def fetch(user, project) do
    issues_url(user, project) |>
    HTTPoison.get(@user_agent) |>
    handle_response()
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body} }) do
    {
      status_code |>  check_for_error(), #map the status code the corresponding atom to signal whether there was an error or not
      body |> Poison.Parser.parse!() #parse github json object
    }
  end


  #return ok if the status_code of the http response was 200, otherwise error
  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error


end
