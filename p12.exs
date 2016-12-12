defmodule P12 do
  def solve(input) do
    File.stream!(input)
    |> Enum.to_list()
    |> run(%{:pc => 0, "a" => 0, "b" => 0, "c" => 1, "d" => 0})
  end
  def run(list, %{pc: pc} = state) do
    require Logger
    case Enum.at(list, pc) do
      "cpy " <> rest ->
        {val, dst} =
          case Integer.parse(rest) do
          :error ->
            <<src_reg::bytes-1, ?\s, dst_reg::bytes-1, ?\n>> = rest
            {state[src_reg], dst_reg}
          {val, <<?\s, dst_reg::bytes-1, ?\n>>} ->
            {val, dst_reg}
          end
        run(list, %{state | :pc => state.pc + 1, dst => val})
      "inc " <> <<reg::bytes-1, ?\n>> ->
        run(list, %{state | :pc => state.pc + 1, reg => state[reg] + 1})
      "dec " <> <<reg::bytes-1, ?\n>> ->
        run(list, %{state | :pc => state.pc + 1, reg => state[reg] - 1})
      "jnz " <> <<test::bytes-1, ?\s, rest::bytes>> ->
        if state[test] !== 0 do
          {offset, "\n"} = Integer.parse rest
          run(list, %{state | pc: state.pc + offset})
        else
          run(list, %{state | pc: state.pc + 1})
        end
      nil ->
        state
    end
  end
end
