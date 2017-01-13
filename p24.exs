defmodule P24 do
  defmodule Maze do
    defstruct [:data, :width, :height]
    def new(data) do
      lines = String.split(data)
      height = Enum.count(lines)
      width = List.first(lines) |> byte_size()
      map = parse(data, %{}, {0, 0})
      struct(__MODULE__, data: map, width: width, height: height)
    end
    def filter_deadends(map) do
      keys = MapSet.new(Map.keys(map))
      keys
      |> Stream.map(&possible_neighbors/1)
      |> Stream.map(&in_map(&1, map))
      |> Stream.zip(keys)
      |> Stream.map(fn {neighbors, point} -> {point, neighbors} end)
      |> Enum.sort_by(fn {_, neighbors} -> length(neighbors) end)
      |> Enum.drop_while(fn {_, neighbors} -> length(neighbors) < 2 end)
    end
    defp in_map(positions, map), do: Enum.filter(positions, &Map.has_key?(map, &1))
    defp possible_neighbors({x, y}) do
      [{x+1,y}, {x-1, y}, {x, y+1}, {x, y-1}]
    end
    defp parse(<<>>, map, dimensions) do
      map
    end
    defp parse(<<?\n, rest::binary>>, map, {_x, y}) do
      parse(rest, map, {0, y+1})
    end
    defp parse(<<?., rest::binary>>, map, {x, y}) do
      parse(rest, Map.put(map, {x, y}, :empty), {x+1, y})
    end
    defp parse(<<?#, rest::binary>>, map, {x, y}) do
      parse(rest, map, {x+1, y})
    end
    defp parse(<<digit, rest::binary>>, map, {x, y}) when digit in ?0..?9 do
      parse(rest, Map.put(map, {x, y}, digit - ?0), {x+1, y})
    end
  end
end

defmodule Heap do
  def new() do
  end
  def insert(heap, item) do
  end
  def peek_min(heap) do
  end
  def remove_min(heap) do
  end
end

defmodule FibonacciHeap do
  def new() do
    :empty
  end
  defp value_node(value) do
    {:value, value}
  end
  def insert({:tree, :empty}, value) do
    {:tree, value_node(value)}
  end
end
defmodule Stack do
  def new() do
    
  end
end

defmodule FingerTreeSequence do
  @type t :: any
  @type node(x) :: {x, x} | {x, x, x}
  @type affix :: [t]
  @type tree(t) :: :empty | {:single, t} | {:deep, affix, tree(node(t)), affix}
  def node(a, b, c) do
    {a, b, c}
  end
  def node(a, b) do
    {a, b}
  end
  def to_list(:empty), do: []
  def to_list({:single, x}), do: [x]
  def to_list({:deep, prefix, deeper, suffix}) do
    prefix ++ to_list(deeper) ++ suffix
  end
  def prepend(:empty, x) do
    {:single, x}
  end
  def prepend({:single, y}, x) do
    {:deep, [x], :empty, [y]}
  end
  def prepend({:deep, [a,b,c,d] = _pre, deeper, suf}, x) do
    {:deep, [x, a], prepend(deeper, node(b, c, d)), suf}
  end
  def prepend({:deep, pre, deeper, suf}, x) do
    {:deep, [x | pre], deeper, suf}
  end
  def append(:empty, x) do
    {:single, x}
  end
  def append({:single, y}, x) do
    {:deep, [y], :empty, [x]}
  end
  def append({:deep, pre, deeper, [a, b, c, d] = _suf}, x) do
    {:deep, pre, append(deeper, node(a, b, c)), [d, x]}
  end
  def append({:deep, pre, deeper, suf}, x) do
    {:deep, pre, deeper, suf ++ [x]}
  end
  # pop left - returns a tuple {leftmost element, remainder of list}
  def popl(:empty), do: {[], :empty}
  def popl({:single, x}), do: {x, :empty}
  def popl({:deep, [x], :empty, [y]}) do
    {x, {:single, y}}
  end
  def popl({:deep, [x], :empty, [y | suf_rest]}) do
    {x, {:deep, [y], :empty, suf_rest}}
  end
  def popl({:deep, [x | rest], :empty, suf}) do
    {x, {:deep, rest, :empty, suf}}
  end
  def popl({:deep, [x | rest], deeper, suf}) do
    remainder =
      if Enum.empty?(rest) do
        {prefix_node, new_deeper} = popl(deeper)
        {:deep, Tuple.to_list(prefix_node), new_deeper, suf}
      else
        {:deep, rest, deeper, suf}
      end
    {x, remainder}
  end

  # pop right - returns a tuple {rightmost element, remainder of list} or nil if list is empty
  def popr(:empty), do: {[], :empty}
  def popr({:single, x}), do: {x, :empty}
  def popr({:deep, [y], :empty, [x]}) do
    {x, {:single, y}}
  end
end

defmodule Fn do
  @doc "Returns the input function (of arity-2), with its arguments flipped."
  def flip(func), do: &func.(&2, &1)
  def curry_l(func, arg) do
    {_, _, arity} = :erlang.fun_info_mfa(func)
  end
end

defmodule UnionFind do
  def new(), do: %{}
  def new_set(uf, x), do: Map.put(uf, x, {0, x})
  defp find(uf, x) do
    {rank, parent} = uf[x]
    if parent == x do
      {uf, {rank, parent}}
    else
      {new_uf, root} = find(uf, parent)
      {Map.put(new_uf, x, root), root}
    end
  end
  def union(uf, x, y) do
    {uf, {rank_x, root_x}} = find(uf, x)
    {uf, {rank_y, root_y}} = find(uf, y)
    cond do
      root_x == root_y ->
        uf
      rank_x < rank_y ->
        Map.put(uf, y, {rank_x, root_x})
      rank_x > rank_y ->
        Map.put(uf, x, {rank_y, root_y})
      rank_x == rank_y ->
        Map.put(uf, root_x, {rank_y+1, root_y})
    end
  end
  def connected?(uf, x, y) do
    {_, root_x} = find(uf, x)
    {_, root_y} = find(uf, y)
    root_x == root_y
  end
end

# skew heap
defmodule PriorityQueue do
  def new, do: :empty
  def new(items) do
    Enum.reduce(items, :empty, &merge(&2, mknode(&1)))
  end
  def insert(queue, item, priority) do
    merge(queue, mknode(item, priority))
  end

  defp mknode(item), do: mknode(item, item)
  defp mknode(item, priority), do: {{priority, item}, :empty, :empty}
  defp merge(:empty, tree), do: tree
  defp merge(tree, :empty), do: tree
  defp merge(tree1, tree2) do
    {p_root, p_left, p_right} = min(tree1, tree2)
    q = max(tree1, tree2)
    {p_root, merge(p_right, q), p_left}
  end
  def peek(:empty), do: nil
  def peek({{_, item}, _, _}), do: item
  def pop(:empty), do: {nil, :empty}
  def pop({{_, item}, left, right}) do
    {item, merge(left, right)}
  end
  def to_list(:empty), do: []
  def to_list(queue) do
    {item, rest} = pop(queue)
    [item | to_list(rest)]
  end
end
