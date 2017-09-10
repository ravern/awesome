defmodule Awesome.Lists.Author do
  @moduledoc """
  Each `Accounts.User` should have a corresponding Author,
  created lazily.
  """

  use Ecto.Schema
  alias Awesome.Accounts.User
  alias Awesome.Lists.{List, Item}

  schema "authors" do
    belongs_to :user, User
    has_many :contributions, Item
    has_many :lists, List

    timestamps()
  end
end
