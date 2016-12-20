defmodule P20 do
  def merge({a, b}, []) do
    [{a, b}]
  end
  def merge({a, b}, [{x, y}|rest]) do
    if a <= y+1 do
      [{x, max(b, y)}|rest]
    else
      IO.inspect y+1
      [{a, b}, {x, y} |rest]
    end
  end
  def solve input do
    File.stream!( "Downloads/p20input")
    |> Enum.map(&parse/1)
    |> Enum.sort()
    |> Enum.reduce([], &merge/2)
    |> Enum.reduce(0, fn {x, y}, acc -> acc + (y - x + 1) end)
  end
  def parse line do
    {a, "-" <> rest} = Integer.parse line
    {b, _} = Integer.parse rest
    {a, b}
  end
end
