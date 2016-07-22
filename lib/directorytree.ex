defmodule Directorytree do

    def lstat(dir \\ ".") do
        if !File.dir?(dir) do
            IO.puts "#{dir} is not a directory"
        else
            map = lstat_recursive(dir)
            IO.puts "Directories: #{Map.get(map, :d)}, Files: #{Map.get(map, :f)}"
        end

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

    def stat(dir \\ ".", map \\ %{d: 0, f: 0}) do
        IO.puts "Getting stat for #{dir}"
        map = Enum.reduce(File.ls!(dir), map, fn (file, acc) ->
            fullname = "#{dir}/#{file}"
            if File.dir?(fullname), do: {old, map} = get_and_update(acc, :d), else: {old, map} = get_and_update(acc, :f)
            map
        end)

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
