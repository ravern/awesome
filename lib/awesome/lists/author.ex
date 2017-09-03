defmodule Awesome.Lists.Author do
  @moduledoc """
  Each `Accounts.User` should have a corresponding Author,
  created lazily.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Awesome.Accounts.User

  schema "authors" do
    belongs_to :user, User

    timestamps()
  end
end
