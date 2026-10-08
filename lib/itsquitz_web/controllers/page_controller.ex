defmodule ItsquitzWeb.PageController do
  use ItsquitzWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
