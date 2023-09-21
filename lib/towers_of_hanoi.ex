defmodule TowersOfHanoi do
  # plates size in reverse order - bottom is on the right
  _state =
    %{a: [1, 2, 3, 4, 5, 6], b: [], c: []}

  def move(ndisks, start_peg \\ 1, end_peg \\ 3)

  def move(ndisks, start_peg, end_peg) when ndisks > 0 do
    IO.puts("-- Called for disks #{ndisks}: #{start_peg} -> #{end_peg}")
    IO.puts("-- 1. calling move for disks #{ndisks-1}: #{start_peg} -> #{ 6 - start_peg - end_peg}")
    move(ndisks - 1, start_peg, 6 - start_peg - end_peg)
    IO.puts("Move disk #{ndisks} from peg #{start_peg} to peg #{end_peg}")
    IO.puts("-- 2. calling move for disks #{ndisks-1}: #{ 6 - start_peg - end_peg} -> #{end_peg}")
    move(ndisks - 1, 6 - start_peg - end_peg, end_peg)
  end

  def move(ndisks, _start_peg, _end_peg) when ndisks == 0 do
    IO.puts("^-- zero disks --^")
  end
end
