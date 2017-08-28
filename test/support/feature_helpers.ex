defmodule AwesomeWeb.FeatureHelpers do
  use Wallaby.DSL
  import Wallaby.Query, only: [css: 2, text_field: 1, button: 1]
  import AwesomeWeb.Router.Helpers
  alias AwesomeWeb.Endpoint

  @doc """
  Selector for flash message.
  """
  def flash(msg, type), do: css(".alert.alert-#{type}", text: msg)

  @doc """
  Logs in a user for the session.

  Returns the session.
  """
  def perform_login(session, email, password) do
    session
    |> visit(auth_path(Endpoint, :request, "identity"))
    |> fill_in(text_field("Email"), with: email)
    |> fill_in(text_field("Password"), with: password)
    |> click(button("Login"))
  end
end
