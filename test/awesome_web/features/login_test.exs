defmodule AwesomeWeb.LoginTest do
  use AwesomeWeb.FeatureCase, async: true
  import Wallaby.Query, only: [css: 1]
  alias AwesomeWeb.Endpoint
  alias Awesome.Accounts

  describe "login" do
    setup do
      {:ok, _} = Accounts.register_user(%{
        name: "John Tan",
        email: "john_tan@gmail.com",
        password: "123456",
        password_confirmation: "123456",
      })
      :ok
    end

    test "with valid credentials succeeds", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> assert_has(flash("Successfully logged in!", :success))
    end

    test "with invalid credentials fails", %{session: session} do
      session
      |> perform_login("invalid_user@gmail.com", "")
      |> assert_has(flash("Invalid email or password. Try again.", :danger))
    end
  end

  describe "sign out" do
    setup do
      {:ok, _} = Accounts.register_user(%{
        name: "John Tan",
        email: "john_tan@gmail.com",
        password: "123456",
        password_confirmation: "123456",
      })
      :ok
    end

    test "by clicking button works", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(list_path(Endpoint, :index))
      |> click(css(".navbar-toggler"))
      |> click(css("#signOut"))
      |> visit(user_path(Endpoint, :edit))
      |> assert_has(flash("need to login", :danger))
    end
  end
end
