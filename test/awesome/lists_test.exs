defmodule Awesome.ListsTest do
  use Awesome.DataCase
  alias Awesome.{Accounts, Lists}

  describe "Awesome.Lists" do
    test "get_author/1 creates the author if doesn't exist" do
      {:ok, user} = Accounts.register_user(%{
        name: "John Tan",
        email: "john_tan@gmail.com",
        password: "123456",
        password_confirmation: "123456",
      })

      author = Lists.get_author(user)

      # Check that an author is created
      refute nil == author

      # Check that it is persisted
      assert author == Lists.get_author(user)
    end
  end
end
