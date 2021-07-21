defmodule Web.TagController do
  use Web, :controller

  alias SmartNote.Questions

  plug(Web.Plugs.FetchPage)

  def show(conn, %{"id" => tag}) do
    %{page: page, per: per} = conn.assigns
    %{page: questions} = Questions.with_tag(tag, page: page, per: per)

    conn
    |> assign(:questions, questions)
    |> render("show.html")
  end

  def index(conn,_) do

    conn
    |> render("index.html")
  end

end
