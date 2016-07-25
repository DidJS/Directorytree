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
        {[dir: dir], _, _} = OptionParser.parse(args)
        dir
    end

    defp lstat_recursive(fname, map \\ %{d: 0, f: 0}, depth \\ 1) do
        Enum.reduce(File.ls!(fname), map, fn (file, acc) ->
            fullname = "#{fname}/#{file}"
            IO.puts build_line(depth) <> "#{file}"
            if File.dir?(fullname), do: acc = lstat_recursive(fullname, acc, depth + 1)

            update(File.dir?(fullname), acc)
        end)
    end

    defp update(isdir, map) when isdir do
        {_old, map} = get_and_update(map, :d)
        map
    end

    defp update(_isdir, map) do
        {_old, map} = get_and_update(map, :f)
        map
    end

    defp get_and_update(map, prop) do
        Map.get_and_update(map, prop, fn n -> {n, n + 1} end)
    end

    defp build_line(depth) when depth == 1 do
        "|__ "
    end

    defp build_line(depth) do
        "    " <> build_line(depth - 1)
    end


end
