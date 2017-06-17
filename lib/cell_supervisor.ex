defmodule CellSupervisor do
    use Supervisor

    def start(_type, _args) do
        start_link()
    end

    def start_link() do
        IO.puts "CellSupervisor started"
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_) do
        children = [worker(Cell, [])]
        supervise(children, strategy: :simple_one_for_one, restart: :transient)
    end
end