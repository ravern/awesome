defmodule AwesomeWeb.ItemTest do
  use AwesomeWeb.FeatureCase, async: true
  import Wallaby.Query, only: [css: 2, text_field: 1, button: 1, css: 1, link: 1]
  alias Awesome.{Lists, Accounts}

  # describe "item listing" do
    # setup do
      # {:ok, user} = Accounts.register_user(%{
        # name: "John Tan",
        # email: "john_tan@gmail.com",
        # password: "123456",
        # password_confirmation: "123456",
      # })
      # author = Lists.get_author(user)
      # {:ok, _} = Lists.create_list(author, %{
        # title: "List 1",
        # description: "list 1 description",
      # })
      # :ok
    # end

    # test "displays content and author correctly", %{session: session} do
      # session
      # |> visit(list_path(Endpoint, :index))
      # |> take_screenshot()
      # |> find(css(".card", count: 3))
      # |> Enum.with_index()
      # |> Enum.each(fn {elem, idx}->
        # elem
        # |> assert_has(Wallaby.Query.text("List #{idx + 1}"))
        # |> assert_has(Wallaby.Query.text("list #{idx + 1} description"))
        # |> assert_has(link("John Tan"))
      # end)
    # end
  # end
end
