defmodule Awesome.Lists do
  @moduledoc """
  CRUD for lists and collaborative stuffs
  """

  alias Awesome.Repo
  alias Awesome.Accounts.User
  alias Awesome.Lists.{List, Author}

  @doc """
  Returns author for user. If doesn't exist, create
  the author.
  """
  def get_author(%User{} = user) do
    case Repo.preload(user, :author).author do
      nil -> create_author(user)
      author -> author
    end
  end

  # TODO don't use bang
  defp create_author(user) do
    user
    |> Ecto.build_assoc(:author)
    |> Repo.insert!()
  end

  @doc """
  Returns a list of all the lists.
  """
  def list_lists() do
    Repo.all(List)
  end
end
