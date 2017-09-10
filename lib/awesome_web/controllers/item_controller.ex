defmodule AwesomeWeb.ItemController do
  use AwesomeWeb, :controller
  alias Awesome.Lists

  def new(conn, %{"slug" => slug}) do
    list = Lists.get_list!(slug)
    changeset = Lists.change_item()
    render conn, "new.html", changeset: changeset, list: list
  end

  def create(conn, %{"item" => item_params, "slug" => slug}) do
    list = Lists.get_list!(slug)

    author =
      conn
      |> Guardian.Plug.current_resource()
      |> Lists.get_author()

    case Lists.create_item(author, list, item_params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Successfully created the item!")
        |> redirect(to: list_path(conn, :show, list.slug))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, list: list)
    end
  end

end
