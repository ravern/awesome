defmodule Awesome.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset
  alias Awesome.Lists.{List, Author}
  alias Awesome.Lists.List.TitleSlug

  schema "lists" do
    field :title, :string
    field :description, :string

    field :slug, TitleSlug.Type

    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(%List{} = list, attrs) do
    list
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> validate_length(:title, max: 20)
    |> validate_length(:description, max: 40)
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint(message: "has been used before (or similar)")
  end
end
