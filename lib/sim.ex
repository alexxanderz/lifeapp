defmodule Sim do
    use GenServer

    @simtime 150

    defp print(cells, generation) do
        Util.Printer.print(cells, generation)
    end

    def start_link do
        IO.puts "Sim started"
        GenServer.start_link(__MODULE__, {}, name: __MODULE__)
    end

    def start_sim do
        start_link()
        start()
    end

    def start do
        GenServer.call(__MODULE__, {:start})
    end
    def stop do
        GenServer.call(__MODULE__, {:stop})
    end

    def tick do
        GenServer.call(__MODULE__, {:tick})
    end

    def do_tick do
        tick()
    end

    def handle_call({:start}, {from_pid, _}, {}) do
        {:ok, tref} = :timer.apply_interval(@simtime, __MODULE__, :do_tick, [])
        {:reply, :started, {tref, 0, from_pid}}
    end

    def handle_call({:tick}, _from, {tref, generation, owner}) do
        Board.tick()
        cells = Board.cells

        #print(cells, generation)
        send(owner, {:cells, %{cells: cells, gen: generation}})

        {:reply, :ok, {tref, generation + 1, owner}}
    end

    def handle_call({:stop}, _from, {tref, _, _owner}) do
        :timer.cancel(tref)
        {:reply, :ok, {}}
    end

    # test patterns
    def p1, do: Util.Patterns.p1()
    def p2, do: Util.Patterns.p2()
    def p3, do: Util.Patterns.p3()
    def p4, do: Util.Patterns.p4()
    def p5, do: Util.Patterns.p5()
    def p6, do: Util.Patterns.p6()
    def p7, do: Util.Patterns.p7()
    def p8, do: Util.Patterns.p8()
    def p9, do: Util.Patterns.p9()
    def p10, do: Util.Patterns.p10()
end