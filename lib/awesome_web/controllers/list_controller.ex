defmodule AwesomeWeb.ListController do
  use AwesomeWeb, :controller
  alias Awesome.Lists

  def index(conn, _params) do
    lists = Lists.list_lists()
    render conn, "index.html", lists: lists
  end
end
