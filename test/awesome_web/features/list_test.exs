defmodule AwesomeWeb.ListTest do
  use AwesomeWeb.FeatureCase, async: true
  import Wallaby.Query, only: [css: 2, text_field: 1, button: 1]
  alias Awesome.{Lists, Accounts}

  describe "list listing" do
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
        slug: "list1"
      })
      {:ok, _} = Lists.create_list(author, %{
        title: "List 2",
        description: "list 2 description",
        slug: "list2"
      })
      {:ok, _} = Lists.create_list(author, %{
        title: "List 3",
        description: "list 3 description",
        slug: "list3"
      })
      :ok
    end

    test "lists display content and author correctly", %{session: session} do
      session
      |> visit(list_path(Endpoint, :index))
      |> find(css(".card", count: 3))
      |> Enum.with_index()
      |> Enum.each(fn {elem, idx}->
        elem
        |> assert_has(Wallaby.Query.text("List #{idx + 1}"))
        |> assert_has(Wallaby.Query.text("John Tan"))
      end)
    end
  end

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

    test "creating a list with invalid data fails", %{session: session} do
      session
      |> perform_login("john_tan@gmail.com", "123456")
      |> visit(list_path(Endpoint, :new))
      |> take_screenshot()
      |> fill_in(text_field("Title"), with: "a very looooooooooooooooooooooooooooooooooooooooooooooooooooong title")
      |> fill_in(text_field("Description"), with: "an even loooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonger description")
      |> fill_in(text_field("Slug"), with: "i n v a l i d s l u g s")
      |> click(button("Create the list"))
      |> assert_has(flash("Oops", :danger))
    end

    test "is a protected route", %{session: session} do
      session
      |> visit(list_path(Endpoint, :new))
      |> assert_has(flash("need to login", :danger))
    end
  end
end
