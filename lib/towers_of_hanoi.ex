defmodule TowersOfHanoi do
  @moduledoc """
  Erlang source
  move(1, F, T, _V) -> 
     io:format("Move from ~p to ~p~n", [F, T]);
  move(N, F, T, V) -> 
     move(N-1, F, V, T), 
     move(1  , F, T, V),
     move(N-1, V, T, F).
  """

  def move(disks_total, from \\1, to \\3, aux \\2)

  def move(1, from, to, _aux) do
    IO.puts("Move one from #{from} to #{to}")
  end

  def move(ndisks, from, to, aux) do
    IO.puts("-- Called for disks #{ndisks}: #{from} -> #{to} over #{aux}")
    # IO.puts("-- 1. calling move for disks #{ndisks-1}: #{start_peg} -> #{ 6 - start_peg - end_peg}")
    move(ndisks - 1, from, aux, to)
    move(1, from, to, aux)

    # IO.puts("-- 2. calling move for disks #{ndisks-1}: #{ 6 - start_peg - end_peg} -> #{end_peg}")
    move(ndisks - 1, aux, to, from)
  end
end
