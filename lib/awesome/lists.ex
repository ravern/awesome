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
  Returns a list of all the lists with
  `author` preloaded.
  """
  def list_lists() do
    List
    |> Repo.all()
    |> Repo.preload([author: :user])
  end

  @doc """
  Returns an empty list changeset.
  """
  def change_list(list \\ %List{}) do
    List.changeset(list, %{})
  end

  @doc """
  Creates a list with the author as the owner.
  """
  def create_list(%Author{} = author, attrs) do
    author
    |> Ecto.build_assoc(:lists)
    |> List.changeset(attrs)
    |> Repo.insert()
  end
end
