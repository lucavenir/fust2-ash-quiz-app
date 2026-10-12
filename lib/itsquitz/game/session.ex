defmodule Itsquitz.Game.Session do
  use GenServer

  def init(_arg) do
    {:ok, %{players: []}}
  end
end
