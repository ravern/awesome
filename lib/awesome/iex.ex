defmodule Awesome.IEx do
  defmacro __using__(_opts) do
    quote do
      alias Awesome.{Repo, Lists, Accounts}
      alias Awesome.Lists.{Author, List}
      alias Awesome.Accounts.User
    end
  end
end
