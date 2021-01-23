defmodule IssuesTest do
  use ExUnit.Case
  doctest Issues

  test "greets the world" do
    assert Issues.hello() == :world
  end

  import Issues.CLI, only: [parse_args: 1]

  test "help option selected, --help or -h, :help returned." do
    assert parse_args(["--help", "anything"]) == :help
    assert parse_args(["-h", "anything"]) == :help
  end

  test "Three values given, three returned." do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "Only user and project given, count defaulted to 4." do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
