defmodule Awesome.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :description, :string
      add :url, :string

      add :list_id, references(:lists), on_delete: :delete_all
      add :author_id, references(:authors), on_delete: :nilify_all

      timestamps()
    end
  end
end
