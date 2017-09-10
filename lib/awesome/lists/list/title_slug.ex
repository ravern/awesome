defmodule Awesome.Lists.List.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug

  @reserved_slugs ~w(user users auth lists)

  def build_slug(sources, changeset) do
    sources
    |> super(changeset)
    |> ensure_slug_unreserved()
  end

  def ensure_slug_unreserved(slug) when slug in @reserved_slugs do
    slug <> "-list"
  end

  def ensure_slug_unreserved(slug) do
    slug
  end
end
