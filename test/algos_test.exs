defmodule AlgosTest do
  use ExUnit.Case
  doctest Algos

  test "quicksort_naive long" do
    assert Algos.quicksort_naive([100, 200, 300]) == [100, 200, 300]
  end

  test "quicksort_random long" do
    assert Algos.quicksort_naive([100, 200, 300]) == [100, 200, 300]
  end
  test "quicksort_median_ " do
    assert Algos.quicksort_median([700,400, 100, 200, 300]) == [100, 200, 300, 400, 700]
  end

  test "merge_sort" do
    assert Algos.merge_sort([700,400, 100, 200, 300]) == [100, 200, 300, 400, 700]
  end
end
