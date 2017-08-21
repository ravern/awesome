defmodule Awesome.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :citext
      add :picture_url, :string
      add :password_hash, :string

      timestamps()
    end
  end
end
