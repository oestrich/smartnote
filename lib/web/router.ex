defmodule Web.Router do
  use Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Web.Plugs.FetchUser
  end

  pipeline :logged_in do
    plug Web.Plugs.EnsureUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through([:browser])

    get "/", PageController, :index

    delete("/sign-out", SessionController, :delete)

    get("/auth/:provider", AuthController, :request)

    get("/auth/:provider/callback", AuthController, :callback)

    get("/_health", PageController, :health)
  end

  scope "/", Web do
    pipe_through([:browser, :logged_in])

    get("/search", PageController, :search)

    resources("/notes", NoteController, except: [:delete])

    resources("/questions", QuestionController, except: [:index, :show])

    resources("/tags", TagController, only: [:show, :index])
  end

  scope "/", Web do
    pipe_through([:browser])

    get("/questions/:id", QuestionController, :show)
  end

  if Mix.env() == :dev do
    forward("/emails/sent", Bamboo.SentEmailViewerPlug)
  end
end
