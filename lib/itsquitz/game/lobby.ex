defmodule Itsquitz.Game.Lobby do
  use GenServer

  # interface

  def set_code(new_code) when is_binary(new_code) do
    GenServer.cast(__MODULE__, {:set_code, new_code})
  end

  def get_code() do
    GenServer.call(__MODULE__, :get_code)
  end

  def join(params) do
    with {:ok, player} <- Itsquitz.Game.join_lobby(params) do
      GenServer.cast(__MODULE__, {:player_joined, player})
      {:ok, player}
    end
  end

  def create_team() do
  end

  def update_player() do
  end

  def start_game() do
  end

  # impl

  @impl true
  def init(_arg) do
    {:ok, %{players: [], code: "42069"}}
  end

  @impl true
  def handle_cast({:player_joined, %Itsquitz.Game.Player{} = player}, state) do
    if is_nil(player.team) do
      Itsquitz.Game.auto_assign_team(player)
    end

    {:noreply, %{state | players: [player | state.players]}}
  end

  @impl true
  def handle_cast({:set_code, new_code}, state) do
    {:noreply, %{state | code: new_code}}
  end

  @impl true
  def handle_call(:get_code, _from, state) do
    {:reply, state.code, state}
  end
end
