defmodule Util.Printer do
    def print(cells, generation_counter, start_x \\ -10, start_y \\ 40, x_size \\ 130, y_size \\ 40, x_padding \\ 5, y_padding \\ 5) do
        alive_counter = length(cells)

        {:ok, out_pid} = StringIO.open("")

        end_x = start_x + x_size
        end_y = start_y - y_size
        x_range = start_x..end_x
        y_range = start_y..end_y

        for y <- y_range, x <- x_range do
            # draw y axis
            if x == start_x do
            IO.write out_pid, (y
            |> Integer.to_string
            |> String.rjust(y_padding)) <> "| "
        end

        cell_ch = if Enum.member?(cells, {x, y}), do: "O", else: ","
        IO.write(out_pid, cell_ch)
        if x == end_x, do: IO.puts out_pid, ""
        end

        # draw x axis
        IO.write out_pid, String.rjust("| ", y_padding + 2)
        x_length = (round((end_x-start_x)/2))
        for _x <- 0..x_length, do: IO.write out_pid, "_ "
        IO.puts out_pid, ""
        IO.write out_pid, String.rjust("/  ", y_padding + 2)
        for x <- x_range do
            if rem(x, x_padding) == 0 do
                IO.write out_pid, (x
                |> Integer.to_string
                |> String.ljust(x_padding))
            end
        end
        IO.puts out_pid, ""
        IO.puts out_pid, "Generation: #{generation_counter}"
        IO.puts out_pid, "Alive cells: #{alive_counter}"

        {_inb, outb} = StringIO.contents(out_pid)
        IO.write(outb)

        StringIO.close(out_pid)
    end
end