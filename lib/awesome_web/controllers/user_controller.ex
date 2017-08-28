defmodule AwesomeWeb.UserController do
  use AwesomeWeb, :controller
  alias Awesome.Accounts

  plug Guardian.Plug.EnsureResource, [handler: AwesomeWeb.GuardianErrorHandler]
    when action in [:edit_profile, :update_profile]

  def new(conn, _params) do
    changeset = Accounts.change_user(:registration)
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "You have been successfully registered!")
        |> redirect(to: auth_path(conn, :request, "identity"))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit_profile(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = Accounts.change_user(user, :profile)
    render conn, "edit_profile.html", changeset: changeset, user: user
  end

  def update_profile(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    case Accounts.update_user_profile(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Successfully updated profile!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit_profile.html", changeset: changeset, user: user)
    end
  end
end
