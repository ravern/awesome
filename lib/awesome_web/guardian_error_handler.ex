defmodule AwesomeWeb.GuardianErrorHandler do
  @moduledoc """
  Handles no auth errors.
  """
  use AwesomeWeb, :controller

  @doc """
  Redirects user to main page, with an error flash.
  """
  def no_resource(conn, _params) do
    conn
    |> put_flash(:error, "You need to login first.")
    |> redirect(to: list_path(conn, :index))
  end
end
