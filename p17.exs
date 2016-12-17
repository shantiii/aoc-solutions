defmodule P17 do
  @part 2
  def solve(input) do
    bfs(input, [{{0, 0}, [], MapSet.new()}])
  end
  def bfs(_input, [], max_len), do: max_len
  def bfs(input, [{pos, path, parents} | queue], max_len \\ 0) do
    if at_goal?(pos) do
      if @part == 1 do
        path
      else
        bfs(input, queue, max(length(path), max_len))
      end
    else
      new_parents = MapSet.put(parents, pos)
      moves =
        moves(pos, input, path)
        |> Enum.map(fn {dir, new_loc} -> {new_loc, path ++ [dir], new_parents} end)
      bfs(input, queue ++ moves, max_len)
    end
  end
  def moves({x, y}, term, path) do
    rejected = exclude(x, y)
    opened(term <> to_string(path))
    |> Enum.reject(&Enum.member?(rejected, &1))
    |> Enum.map(&apply_move({x, y}, &1))
  end
  def apply_move({x, y}, ?D), do: {?D, {x, y+1}}
  def apply_move({x, y}, ?U), do: {?U, {x, y-1}}
  def apply_move({x, y}, ?L), do: {?L, {x-1, y}}
  def apply_move({x, y}, ?R), do: {?R, {x+1, y}}
  def opened(term) do
    dirs =
    Base.encode16(:crypto.md5(term))
    |> String.to_charlist()
    |> Enum.take(4)
    |> Enum.map(fn x -> x in ?B..?F end)
    
    [?U, ?D, ?L, ?R]
    |> Enum.zip(dirs)
    |> Enum.filter(fn {_, x} -> x end)
    |> Enum.map(fn {x, _} -> x end)
  end
  def at_goal?({3, 3}), do: true
  def at_goal?({3, 3}), do: true
  def at_goal?(_), do: false
  def exclude(0, y), do: [?L | exclude(-1, y)]
  def exclude(x, 0), do: [?U | exclude(x, -1)]
  def exclude(x, 3) when x < 3, do: [?D | exclude(x, -1)]
  def exclude(3, y) when y < 3, do: [?R | exclude(-1, y)]
  def exclude(x, y) do
    []
  end
  def path()
end
