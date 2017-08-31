defmodule AwesomeWeb.LayoutView do
  use AwesomeWeb, :view

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
