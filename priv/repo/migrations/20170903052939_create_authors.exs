defmodule Awesome.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :user_id, references(:users), on_delete: :delete_all

      timestamps()
    end
  end
end
