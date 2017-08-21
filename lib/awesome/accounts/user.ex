defmodule Awesome.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Awesome.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :picture_url, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :picture_url, :password_hash])
    |> validate_required([:name, :email, :picture_url, :password_hash])
  end
end
