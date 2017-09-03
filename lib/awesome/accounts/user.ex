defmodule Awesome.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1, checkpw: 2]
  alias Awesome.Accounts.User
  alias Awesome.Lists.Author

  @email_format ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :picture_url, :string

    field :old_password, :string, virtual: true
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_one :author, Author

    timestamps()
  end

  @doc false
  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast_password(attrs, :password, :password_confirmation)
  end

  @doc false
  def profile_changeset(%User{} = user, attrs) do
    changeset = changeset(user, attrs)

    # Check if user intends to set new password
    if attrs["password"] && attrs["password"] != "" do
      changeset
      |> cast(attrs, [:old_password])
      |> validate_required([:old_password])
      |> validate_old_password_matches(:old_password)
      |> cast_password(attrs, :password, :password_confirmation)
    else
      changeset
    end
  end

  # Base changeset
  defp changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 2, max: 20)
    |> validate_format(:email, @email_format)
    |> unique_constraint(:email)
  end

  defp validate_old_password_matches(%Ecto.Changeset{} = changeset, field, opts \\ []) do
    password_hash = changeset.data.password_hash
    validate_change(changeset, field, fn _, old_pw ->
      if checkpw(old_pw, password_hash),
        do: [],
        else: [{field, opts[:message] || "did not match old password"}]
    end)
  end

  # Only casts if changeset is valid
  defp cast_password(_changeset, _attrs, _field, _confirm_field)
  defp cast_password(%Ecto.Changeset{valid?: false} = changeset, _attrs, _field, _confirm_field), do: changeset
  defp cast_password(%Ecto.Changeset{valid?: true} = changeset, attrs, field, confirm_field) do
    changeset
    |> cast(attrs, [field, confirm_field])
    |> validate_required([field, confirm_field])
    |> validate_length(field, min: 6)
    |> validate_confirmation(field)
    |> put_password_hash(field)
  end

  # Uses Bcrypt for hashing password
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
