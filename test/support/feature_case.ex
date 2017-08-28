defmodule AwesomeWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import AwesomeWeb.FeatureHelpers

      alias Awesome.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import AwesomeWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Awesome.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Awesome.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Awesome.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
