defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv |> parse_args() |> process()  #check whether there was an error while fetching

  end

  def process({user, project, count}) do
      Issues.GithubIssues.fetch(user, project)
      |> decode_response()
      |> sort_issues()
      |> last(count)
  end

  defp last(list, count) do
    list |>
    Enum.take(count) |>
    Enum.reverse()
  end


  def sort_issues(issues) do
    issues |>
    Enum.sort(fn (issue1, issue2) -> issue1["created_at"] >= issue2["created_at"] end)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    #parse the command line arguments
    {options, arguments, _ } = OptionParser.parse(argv, [switches: [help: :boolean], aliases: [h: :help]])
    args_to_internal_representation(options, arguments)
  end


  def args_to_internal_representation([help: true], _), do: :help
  def args_to_internal_representation( _, [user, project, count]), do: {user, project, String.to_integer(count)}
  def args_to_internal_representation( _, [user, project]), do: {user, project, @default_count}
  def args_to_internal_representation( _, _), do: :help


  defp decode_response({:ok, body}), do: body
  defp decode_response({:error, error}) do
    IO.puts("Error fetching from Github:\n #{error["message"]}")
    System.halt(2)
  end

end
