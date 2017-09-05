defmodule AwesomeWeb.CreateListTest do
  use AwesomeWeb.FeatureCase, async: true
  import Wallaby.Query, only: [css: 1]
  alias Awesome.Accounts

  describe "list creation" do
    setup do
      {:ok, _} = Accounts.register_user(%{
        name: "John Tan",
        email: "john_tan@gmail.com",
        password: "123456",
        password_confirmation: "123456",
      })
      :ok
    end

    test "is a protected route", %{session: session} do
      session
      |> visit(list_path(Endpoint, :new))
      |> take_screenshot()
      |> assert_has(flash("need to login", :danger))
    end
  end
end
