defmodule Directorytree do

    def fetch(dir \\ ".") do
        IO.puts dir
        fetch_recursive(dir)
    end

    defp fetch_recursive(dir, depth \\ 1) do
        Enum.each(File.ls!(dir), fn file ->
            fname = "#{dir}/#{file}"
            IO.puts build_line(depth) <> "#{file}"
            if File.dir?(fname), do: fetch_recursive(fname, depth + 1)
        end)
    end

    defp build_line(depth) when depth == 1 do
        "    "
    end

    defp build_line(depth) do
        "    " <> build_line(depth - 1)
    end
end
