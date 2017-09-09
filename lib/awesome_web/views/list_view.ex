defmodule AwesomeWeb.ListView do
  use AwesomeWeb, :view
  alias AwesomeWeb.Endpoint

  def columned_lists(lists) do
    {left, len_left, right, len_right} =
      Enum.reduce(lists, {[], 0, [], 0}, &distribute_elem/2)

    if len_left > len_right do
      Enum.zip(left, [nil | right])
      |> Enum.reverse()
    else
      Enum.zip(left, right)
      |> Enum.reverse()
    end
  end

  # Distributes the elem to left or right list, depending
  # on which has more. If equal, put to left
  def distribute_elem(list, {left, len_left, right, len_right}) when len_left > len_right,
    do: {left, len_left, [list | right], len_right + 1}
  def distribute_elem(list, {left, len_left, right, len_right}),
    do: {[list | left], len_left + 1, right, len_right}

  @doc """
  Removed the "http://" in front of the url
  """
  def display_url() do
    URI.parse(Endpoint.url()).authority
  end

  # FIXME duplicated code from LayoutView
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def utility_button(conn) do
    list_author_user_id = conn.assigns.list.author.user.id
    case current_user(conn) do
      nil ->
        link "Login to contribute", to: auth_path(conn, :request, "identity"), class: "text-dark text-center", style: "text-decoration: none;"
      %{id: ^list_author_user_id} ->
        link "Add", to: list_path(conn, :index), class: "text-dark text-center", style: "text-decoration: none;"
      _ ->
        link "Contribute", to: list_path(conn, :index), class: "text-dark text-center", style: "text-decoration: none"
    end
  end
end
