defmodule Awesome.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]
  alias Awesome.Accounts.User

  @email_format ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :picture_url, :string

    field :old_password, :string, virtual: true
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  def register_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> validate_required([:password])
    |> put_password_hash(:password)
  end

  def profile_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:old_password, :password_confirmation])
    |> validate_old_password_match(:old_password)
    |> validate_confirmation(:password)
    |> put_password_hash(:password)
  end

  defp changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:email])
    |> validate_length(:name, min: 2)
    |> validate_format(:email, @email_format)
    |> validate_length(:password, min: 6)
  end

  defp validate_old_password_match(%Ecto.Changeset{} = changeset, field, opts \\ []) do
    password_hash = changeset.data.password_hash

    validate_change(changeset, field, fn _, old_password ->
      if checkpw(old_password, password_hash) do
        []
      else
        [{field, opts[:message] || "wrong password"}]
      end
    end)
  end

  defp put_password_hash(%Ecto.Changeset{valid?: false} = changeset, _field), do: changeset
  defp put_password_hash(%Ecto.Changeset{valid?: true} = changeset, field) do
    case get_change(changeset, field) do
      nil -> changeset
      password ->
        hash = hashpwsalt(password)
        put_change(changeset, :password_hash, hash)
    end
  end
end
