defmodule AwesomeWeb.Router do
  use AwesomeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # TODO: Refactor to better naming
  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  scope "/", AwesomeWeb do
    pipe_through [:browser, :browser_session]

    resources "/", ListController, only: [:index, :show], param: "slug"
    resources "/lists", ListController, only: [:new, :create]

    resources "/users", UserController, only: [:new, :create]
    resources "/user", UserController, only: [:edit, :update], singleton: true
  end

  scope "/auth", AwesomeWeb do
    pipe_through [:browser, :browser_session]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/identity/callback", AuthController, :identity_callback
    delete "/sign_out", AuthController, :sign_out
  end
end
