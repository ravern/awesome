defmodule Awesome.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset
  alias Awesome.Lists.{List, Author}

  schema "lists" do
    field :title, :string
    field :description, :string
    field :slug, :string

    belongs_to :author, Author
    
    timestamps()
  end
end
