defmodule AwesomeWeb.RegisterTest do
  use AwesomeWeb.FeatureCase, async: true
  import Wallaby.Query, only: [text_field: 1, button: 1, css: 1]

  describe "registration" do
    test "with valid input succeeds", %{session: session} do
      session
      |> visit(user_path(Endpoint, :new))
      |> fill_in(text_field("Email"), with: "john_tan@gmail.com")
      |> fill_in(text_field("Name"), with: "John Tan")
      |> fill_in(css("#password"), with: "123456")
      |> fill_in(css("#password-confirmation"), with: "123456")
      |> click(button("Register"))
      |> perform_login("john_tan@gmail.com", "123456")
      |> assert_has(flash("Successful", :success))
    end

    test "with invalid input fails", %{session: session} do
      session
      |> visit(user_path(Endpoint, :new))
      |> fill_in(text_field("Email"), with: "bad_email")
      |> fill_in(text_field("Name"), with: "Bad name")
      |> fill_in(css("#password"), with: "1")
      |> fill_in(css("#password-confirmation"), with: "1")
      |> click(button("Register"))
      |> assert_has(flash("Oops", :danger))
    end
  end
end
