defmodule Awesome.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset
  alias Awesome.Lists.{List, Author}

  @max_slug_length 15

  schema "lists" do
    field :title, :string
    field :description, :string
    field :slug, :string

    belongs_to :author, Author
    
    timestamps()
  end

  @doc false
  def changeset(%List{} = list, attrs) do
    list
    |> cast(attrs, [:title, :description, :slug])
    |> validate_required([:title, :description, :slug])
    |> validate_length(:slug, max: @max_slug_length)
    |> unique_constraint(:slug)
  end
end
