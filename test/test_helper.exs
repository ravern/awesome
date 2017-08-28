# Wallaby comfiguration
Application.put_env(:wallaby, :base_url, AwesomeWeb.Endpoint.url)

{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Awesome.Repo, :manual)

