defmodule AwesomeWeb.ListController do
  use AwesomeWeb, :controller
  alias Awesome.Lists

  plug Guardian.Plug.EnsureResource, [handler: AwesomeWeb.GuardianErrorHandler]
    when action in [:new, :create]

  def index(conn, _params) do
    lists = Lists.list_lists()
    render conn, "index.html", lists: lists
  end

  def new(conn, _params) do
    changeset = Lists.change_list()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"list" => list_params}) do
    author =
      conn
      |> Guardian.Plug.current_resource()
      |> Lists.get_author()

    case Lists.create_list(author, list_params) do
      {:ok, list} ->
        conn
        |> put_flash(:success, "Created your list: #{list.title}!")
        |> redirect(to: list_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    list = Lists.get_list!(slug)
    render conn, "show.html", list: list
  end
end
