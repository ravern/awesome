defmodule AwesomeWeb.AuthController do
  use AwesomeWeb, :controller
  alias Awesome.Accounts
  plug Ueberauth

  def request(conn, %{"provider" => "identity"}) do
    render conn, "request.html", title: "Login"
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_or_register_user(auth) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:success, "Successfully logged in!")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:error, "Unknown error occured.")
        |> render("request.html")
    end
  end

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_and_authenticate_user(auth.info.email, auth.credentials.other.password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:success, "Successfully logged in!")
        |> redirect(to: "/")
      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password. Try again.")
        |> render("request.html")
    end
  end
end
