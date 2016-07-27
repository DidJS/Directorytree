defmodule Directorytree do

    def main(args) do
        args |> parse_args |> lstat
    end

    def lstat(dir \\ ".") do
        if !File.dir?(dir) do
            IO.puts "#{dir} is not a directory"
        else
            map = lstat_recursive(dir)
            IO.puts "Directories: #{Map.get(map, :d)}, Files: #{Map.get(map, :f)}"
        end

    end

    defp parse_args(args) do
        {_, args, _} = OptionParser.parse(args)
        [head] = args
        head
    end

    defp lstat_recursive(fname, map \\ %{d: 0, f: 0}, depth \\ 1) do
        Enum.reduce(File.ls!(fname), map, fn (file, acc) ->
            fullname = "#{fname}/#{file}"
            IO.puts build_line(depth) <> "#{file}"
            if File.dir?(fullname), do: acc = lstat_recursive(fullname, acc, depth + 1)

            {_old, map} =
                if File.dir?(fullname), do: get_and_update(acc, :d), else: get_and_update(acc, :f)

            map
        end)
    end

    defp get_and_update(map, prop), do: Map.get_and_update(map, prop, fn n -> {n, n + 1} end)

    defp build_line(depth, line \\ "")

    defp build_line(depth, line) when depth == 1, do: line <> "|__ "

    defp build_line(depth, line), do: build_line(depth - 1, line <> "    ") # Tail recursive

end
