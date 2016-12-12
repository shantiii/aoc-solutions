defmodule P8 do
  require Logger
  import Kernel, except: [apply: 2]
  def solve(input) do
    state = Map.new(for i <- 0..5, do: {i, Stream.cycle([0]) |> Enum.take(50)})
    data =
      File.stream!(input)
      |> Stream.map(&parse/1)
      |> Enum.reduce(state, &apply/2)
    data |> display()
    data
    |> Map.values()
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end
  def parse(line) do
    case line do
      <<"rect ", rest::binary>> -> parse_rect(rest)
      <<"rotate row y=", rest::binary>> -> parse_rotate(:row, rest)
      <<"rotate column x=", rest::binary>> -> parse_rotate(:column, rest)
    end
  end
  def parse_rect(bin) do
    {x, <<?x, rest::binary>>} = Integer.parse bin
    {y, _} = Integer.parse rest
    {:rect, x, y}
  end
  def parse_rotate(type, bin) do
    {index, " by "<> rest} = Integer.parse bin
    {amount, _} = Integer.parse rest
    {type, index, amount}
  end
  def apply({:rect, w, 0}, state) do
    state
  end
  def apply({:rect, w, h}, state) do
    paint_row = fn row ->
      fill = Enum.take(Stream.cycle([1]), w) ++ Enum.drop(row, w)
    end
    apply({:rect, w, h-1}, Map.update(state, h-1, 0, paint_row))
  end
  def apply({:row, y, amount}, state) do
    {a, b} = Enum.split(state[y], -amount)
    %{state | y => b ++ a}
  end
  def apply({:column, x, amount}, state) do
    new = Enum.map(state, fn {row, data} -> {rem(row + amount, 6), Enum.at(data, x)} end)
    Map.merge(state, Map.new(new), fn _, data, new_bit -> List.replace_at(data, x, new_bit) end)
  end
  def display(state) do
    for y <- 0..5 do
      [?\n | state[y]
      |> Enum.map(fn 1 -> ?#
        0 -> ?.
      end)]
    end
    |> IO.puts()
  end
end
