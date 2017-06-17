defmodule LifeApp.PageController do
  use LifeApp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end