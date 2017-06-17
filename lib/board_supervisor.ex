defmodule BoardSupervisor do
    use Supervisor

    def start(_type, _args) do
        start_link()
    end

    def start_link() do
        IO.puts "Board supervisor started"
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_) do
        children = [
            worker(Board, []),
            supervisor(CellSupervisor, [])
        ]
        supervise(children, strategy: :one_for_one)
    end
end