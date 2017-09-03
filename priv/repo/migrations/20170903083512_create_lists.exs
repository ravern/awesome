defmodule Awesome.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :description, :string
      add :slug, :citext

      add :author_id, references(:authors), on_delete: :nilify_all

      timestamps()
    end

    create unique_index(:lists, [:slug])
  end
end
