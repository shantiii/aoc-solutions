defmodule P6 do
  def solve(input) do
    initial = Enum.take(Stream.repeatedly(&Map.new/0), 8)
    File.stream!(input)
    |> Stream.map(&:binary.bin_to_list/1)
    |> Stream.scan(initial, fn values, maps ->
      Enum.zip(values, maps)
      |> Enum.map(fn {val, map} -> Map.update(map, val, 1, &(&1+1))end)
    end)
    |> Enum.take(-1)
    |> List.first()
    |> Enum.map(&most_common/1)
  end
  def most_common(map) do
    map
    |> Map.keys()
    |> Enum.sort(&(map[&1] < map[&2]))
    |> List.first()
  end
end
