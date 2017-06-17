defmodule Board do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def cells do
        GenServer.call(__MODULE__, {:cells})
    end
    
    def tick do
        GenServer.call(__MODULE__, {:tick})
    end

    def handle_call({:tick}, _from, state) do
        get_cells_pids()
        |> tick_each
        |> await_all
        |> reduce_results
        |> kill_and_create

        {:reply, :ok, state}
    end
    def handle_call({:cells}, _from, state) do
        cells = 
        get_cells_pids()
        |> Enum.map(&Cell.pos/1)
        {:reply, cells, state}
    end

    defp get_cells_pids do
        Supervisor.which_children(CellSupervisor)
        |> Enum.map(fn {_, pid, _, _} -> pid end)
    end

    defp tick_pid(pid) do
        Task.async(fn -> Cell.tick(pid) end)
    end
    defp tick_each(pids) do
        pids |> Enum.map(&tick_pid/1)
    end
    defp await_all(asyncs) do
        asyncs |> Enum.map(&Task.await/1)
    end

    defp reduce_results(results) do
        results
        |> Enum.reduce({[], []}, &acc_cells/2)
    end
    defp acc_cells({to_kill, to_create}, {acc_kill, acc_create}) do
        {acc_kill ++ to_kill, acc_create ++ to_create}
    end

    defp kill_and_create({to_kill, to_create}) do
        to_kill |> Enum.map(&Cell.kill/1)
        to_create |> Enum.map(&Cell.new/1)
    end
end