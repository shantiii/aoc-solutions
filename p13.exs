defmodule P13 do
  def solve() do
    points =
      for x <- 0..32, y <- 0..40, do: {x, y}
    locations = Map.new(points, fn {x, y} -> {{x, y}, ! is_wall?(x, y)} end)
    points = Enum.sort_by(points, fn {x, y} -> x+y end)
    init = Map.put(locations, {1,1}, 0)
    res = IO.inspect explore(init, [{1,1}])
  end
  def is_wall?(x, y) do
    require Integer
    number = (x + 3) * x + (2*x + y + 1) * y + 1358
    Integer.digits(number, 2)
    |> Enum.sum()
    |> Integer.is_odd()
  end
  def explore(locations, []), do: locations
  def explore(locations, [curr | rest] = unvisited) do
    require Logger
    Logger.debug "exploring #{inspect curr}"
    case locations[curr] do
      number when is_integer(number) ->
        n = neighbors(locations, curr)
        new_n = Map.new(n, fn neighbor -> {neighbor, number + 1} end)
        if curr == {31, 39} do
          locations
        else
        explore(Map.merge(locations, new_n), rest ++ n)
        end
    end
  end
  def neighbors(locations, {x, y}) do
    [{x+1, y}, {x-1, y}, {x, y-1}, {x, y+1}]
    |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 end)
    |> Enum.filter(fn {x, y} -> not is_wall?(x, y) and not is_integer(locations[{x, y}])end)
  end
end
