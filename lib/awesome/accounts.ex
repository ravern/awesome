defmodule Awesome.Accounts do
  @moduledoc """
  Handles all things admin/account related.
  """

  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Awesome.{Repo, Accounts}
  alias Awesome.Accounts.User

  @doc """
  Changeset for user schema.
  """
  def change_user(_user \\ %User{}, _type)
  def change_user(user, :registration),
    do: User.registration_changeset(user, %{})
  def change_user(user, :profile),
    do: User.profile_changeset(user, %{})

  @doc """
  Registers a user from the provided attributes
  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the user provided with the provided attributes
  """
  def update_user_profile(%User{} = user, attrs) do
    user
    |> User.profile_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Attempts to find a user with the correct email.
  If not found, creates a new user.

  Returns the user if successful or an error tuple
  if it fails.
  """
  def find_or_register_user(%Ueberauth.Auth{info: %{email: email}} = auth) do
    case Repo.get_by(User, email: email) do
      nil -> register_user_from_auth(auth)
      user -> {:ok, user}
    end
  end

  # Creates a user from an Ueberauth object
  defp register_user_from_auth(auth) do
    Accounts.register_user(%{
      email: auth.info.email,
      name: auth.info.name,
      picture_url: auth.info.image,
    })
  end

  @doc """
  Attempts to find a user with the correct email.
  If found, attempts to authenticate.

  Returns the user if successful or an error tuple
  if it fails.
  """
  def find_and_authenticate_user(email, password) do
    user = Repo.get_by(User, email: email) 
    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :invalid_credentials}
      true ->
        dummy_checkpw()
        {:error, :invalid_credentials}
    end
  end
end
