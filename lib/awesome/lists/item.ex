defmodule Awesome.Lists.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Awesome.Lists.{List, Author, Item}

  schema "items" do
    field :title, :string
    field :description, :string
    field :url, :string

    belongs_to :list, List
    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(%List{} = list, attrs) do
    list
    |> cast(attrs, [:title, :description, :url])
    |> validate_required([:title, :description, :url])
    |> validate_length(:title, max: 20)
    |> validate_length(:description, max: 60)
  end
end

