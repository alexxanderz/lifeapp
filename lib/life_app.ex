defmodule LifeApp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts "> App started"

    children = [
      supervisor(LifeApp.Endpoint, []),
      supervisor(Registry, [:unique, CellRegistry]),
      supervisor(BoardSupervisor, []),
      worker(Sim, [])
    ]

    opts = [strategy: :one_for_one, name: LifeApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    LifeApp.Endpoint.config_change(changed, removed)
    :ok
  end
end