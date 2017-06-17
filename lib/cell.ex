defmodule Cell do
    use GenServer

    @deltas [
        {-1, 1}, {0, 1}, {1, 1},
        {-1, 0}, {1, 0},
        {-1, -1}, {0, -1}, {1, -1}
    ]

    def start_link(pos) do
        GenServer.start_link(Cell, pos, name:
            {:via, Registry, {CellRegistry, pos}})
    end

    def new(pos) do
        Supervisor.start_child(CellSupervisor, [pos])
    end
    def new_cells(cells) do
        cells
        |> Enum.map(fn pos -> Cell.new(pos) end)
    end

    def find(pos) do
        Registry.lookup(CellRegistry, pos)
        |> Enum.map(&to_pid/1)
        |> Enum.filter(&Process.alive?/1)
        |> List.first
    end
    defp to_pid(entry) do
        case entry do
            {pid, _value} -> pid
            nil -> nil
        end
    end

    def alive?(pos), do: find(pos) != nil
    def dead?(pos), do: !alive?(pos)

    defp keep_alive(positions) do
        positions |> Enum.filter(&alive?/1)
    end
    defp keep_dead(positions) do
        positions |> Enum.filter(&dead?/1)
    end

    def kill({x, y}) do
        find({x, y}) |> kill
    end
    def kill(pid) do
        Supervisor.terminate_child(CellSupervisor, pid)
    end

    defp add({x1, y1}, {x2, y2}) do
        {x1 + x2, y1 + y2}
    end
    defp get_neighboring_pos(pos) do
        @deltas |> Enum.map(fn delta -> add(pos, delta) end)
    end

    defp do_count_neighbours(pos) do
        pos
        |> get_neighboring_pos
        |> keep_alive
        |> length
    end

    defp do_tick(pos) do
        to_kill = if should_kill?(pos), do: [self()], else: []

        to_create = pos
        |> get_neighboring_pos
        |> keep_dead
        |> Enum.filter(&should_create?/1)

        {to_kill, to_create}
    end

    defp should_kill?(pos) do
        case do_count_neighbours(pos) do
            2 -> false
            3 -> false
            _ -> true
        end
    end
    defp should_create?(pos) do
        do_count_neighbours(pos) == 3
    end
    

    def tick(pid) do
        GenServer.call(pid, {:tick})
    end
    def count_neighbours(pid) do
        GenServer.call(pid, {:count_neighbours})
    end
    def pos(pid) do
        GenServer.call(pid, {:pos})
    end

    def handle_call({:tick}, _from, pos) do
        {:reply, do_tick(pos), pos}
    end
    def handle_call({:count_neighbours}, _from, pos) do
        {:reply, do_count_neighbours(pos), pos}
    end
    def handle_call({:pos}, _from, pos) do
        {:reply, pos, pos}
    end
end