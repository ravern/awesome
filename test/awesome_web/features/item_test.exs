defmodule AwesomeWeb.ItemTest do
  use AwesomeWeb.FeatureCase, async: true
  import Wallaby.Query, only: [text_field: 1, button: 1, link: 1]
  alias Awesome.{Lists, Accounts}

  describe "item creation" do
    setup do
      {:ok, user} = Accounts.register_user(%{
        name: "John Tan",
        email: "john_tan@gmail.com",
        password: "123456",
        password_confirmation: "123456",
      })
      author = Lists.get_author(user)
      {:ok, _} = Lists.create_list(author, %{
        title: "List 1",
        description: "list 1 description",
      })
      :ok
    end

    test "with invalid data fails", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(list_path(Endpoint, :index))
      |> click(Wallaby.Query.text("List 1"))
      |> click(link("Add"))
      |> fill_in(text_field("Title"), with: "")
      |> fill_in(text_field("Description"), with: "")
      |> fill_in(text_field("Link"), with: "")
      |> click(button("Add new item"))
      |> assert_has(flash("Oops", :danger))
    end

    test "with valid data succeeds", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(list_path(Endpoint, :index))
      |> click(Wallaby.Query.text("List 1"))
      |> click(link("Add"))
      |> fill_in(text_field("Title"), with: "Item 1")
      |> fill_in(text_field("Description"), with: "item 1 description")
      |> fill_in(text_field("Link"), with: "http://google.com")
      |> click(button("Add new item"))
      |> assert_has(flash("Success", :success))
    end
  end
end
