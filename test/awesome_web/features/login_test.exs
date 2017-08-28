defmodule AwesomeWeb.LoginTest do
  use AwesomeWeb.FeatureCase, async: true
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
end
