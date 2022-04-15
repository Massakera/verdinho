defmodule VerdinhoWeb.PageController do
  use VerdinhoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
