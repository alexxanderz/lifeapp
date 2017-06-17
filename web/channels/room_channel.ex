defmodule LifeApp.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    send(self(), {:after_join, message})
    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  def handle_info({:cells, cells_data}, socket) do
    push socket, "update:cells", cells_data
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", msg, socket) do
    IO.puts inspect msg

    cmd = msg["body"]
    case cmd do
      "sim:start" ->
        IO.puts "Starting simulation"
        Sim.start()

      "sim:p1" ->
        IO.puts "Pattern p1"
        Sim.p1()

      "sim:p2" ->
        IO.puts "Pattern p2"
        Sim.p2()

      "sim:p3" ->
        IO.puts "Pattern p3"
        Sim.p3()

      "sim:p4" ->
        IO.puts "Pattern p4"
        Sim.p4()

      "sim:p5" ->
        IO.puts "Pattern p5"
        Sim.p5()

      "sim:p6" ->
        IO.puts "Pattern p6"
        Sim.p6()

      "sim:p7" ->
        IO.puts "Pattern p7"
        Sim.p7()

      "sim:p8" ->
        IO.puts "Pattern p8"
        Sim.p8()

      "sim:p9" ->
        IO.puts "Pattern p9"
        Sim.p9()

      "sim:p10" ->
        IO.puts "Pattern p10"
        Sim.p10()

      _ ->
        IO.puts "command #{cmd}"
    end

    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end
end