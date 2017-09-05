defmodule AwesomeWeb.ProfileTest do
  use AwesomeWeb.FeatureCase, async: true
  import Wallaby.Query, only: [text_field: 1, css: 1, button: 1]
  alias Awesome.Accounts

  describe "profile" do
    setup do
      {:ok, _} = Accounts.register_user(%{
        name: "John Tan",
        email: "john_tan@gmail.com",
        password: "123456",
        password_confirmation: "123456",
      })
      :ok
    end

    test "updating non-password fields with valid input succeeds", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(user_path(Endpoint, :edit))
      |> fill_in(text_field("Email"), with: "new_john_tan@gmail.com")
      |> fill_in(text_field("Name"), with: "New John Tan")
      |> click(button("Update profile"))
      |> assert_has(flash("Successful", :success))
    end

    test "updating non-password fields with invalid input fails", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(user_path(Endpoint, :edit))
      |> fill_in(text_field("Email"), with: "bad_email")
      |> fill_in(text_field("Name"), with: "Bad name")
      |> click(button("Update profile"))
      |> assert_has(flash("Oops", :danger))
    end

    test "updating password with correct old password succeeds", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(user_path(Endpoint, :edit))
      |> fill_in(css("#old-password"), with: "123456")
      |> fill_in(css("#password"), with: "12345678")
      |> fill_in(css("#password-confirmation"), with: "12345678")
      |> click(button("Update profile"))
      |> assert_has(flash("Successful", :success))
    end

    test "updating password with wrong old password fails", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(user_path(Endpoint, :edit))
      |> fill_in(css("#old-password"), with: "")
      |> fill_in(css("#password"), with: "12345678")
      |> fill_in(css("#password-confirmation"), with: "12345678")
      |> click(button("Update profile"))
      |> assert_has(flash("Oops", :danger))
    end

    test "is a protected route", %{session: session} do
      session
      |> visit(user_path(Endpoint, :edit))
      |> assert_has(flash("need to login", :danger))
    end
  end
end
