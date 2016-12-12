defmodule P2 do
  def solve(input) do
    data = File.read!(input)
    parse(data)
  end

  def parse(binary) do
    do_parse(binary, {1, 1}, "")
  end

  def do_parse(<<char, rest::binary>>, {x, y}, acc) do
    case char do
      ?L -> do_parse(rest, trim({x-1, y}), acc)
      ?R -> do_parse(rest, trim({x+1, y}), acc)
      ?D -> do_parse(rest, trim({x, y+1}), acc)
      ?U -> do_parse(rest, trim({x, y-1}), acc)
      ?\n -> do_parse(rest, {x, y}, acc <> digit(x, y))
    end
  end
  def do_parse(<<>>, {_x, _y}, acc) do
    acc
  end

  def digit(col, row) do
    to_string(3 * row + col + 1)
  end

  def trim({x, y}) do
    {max(0, min(2, x)), max(0, min(2, y))}
  end
end

defmodule P2.P2 do
  def solve(input) do
    data = File.read!(input)
    parse(data)
  end

  def parse(binary) do
    do_parse(binary, {0, 2}, [])
  end

  def do_parse(<<>>, {_x, _y}, acc) do
    acc
  end
  def do_parse(<<?\n, rest::binary>>, {x, y}, acc) do
    do_parse(rest, {x, y}, acc ++ [digit(x, y)])
  end
  def do_parse(<<char, rest::binary>>, {x, y} = pos, acc) when char in [?L, ?R, ?U, ?D] do
    candidate =
      case char do
        ?L -> {x-1, y}
        ?R -> {x+1, y}
        ?D -> {x, y+1}
        ?U -> {x, y-1}
      end
    new_pos =
      if is_valid?(candidate) do
        candidate
      else
        pos
      end
    do_parse(rest, new_pos, acc)
  end
  def do_parse(<<_, rest::binary>>, pos, acc) do
    do_parse(rest, pos, acc)
  end

  def is_valid?({x, y}) do
    (x + y in 2..6) and abs(x - y) in 2..0
  end

  def digit(2, 0), do: ?1
  def digit(1, 1), do: ?2
  def digit(2, 1), do: ?3
  def digit(3, 1), do: ?4
  def digit(0, 2), do: ?5
  def digit(1, 2), do: ?6
  def digit(2, 2), do: ?7
  def digit(3, 2), do: ?8
  def digit(4, 2), do: ?9
  def digit(1, 3), do: ?A
  def digit(2, 3), do: ?B
  def digit(3, 3), do: ?C
  def digit(2, 4), do: ?D
  def digit(_x, _y) do
    raise "fuck"
  end

end
