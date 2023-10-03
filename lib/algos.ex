defmodule Algos do
  @moduledoc """
  Documentation for `Algos`.
  """

  @doc """
  Joe's naive Erlang bookish one.

  ## Examples

  iex> Algos.quicksort_naive([4,3,6,1,5,2])
  [1,2,3,4,5,6]

  """
  def quicksort_naive([]), do: []

  def quicksort_naive([pivot | tail]) do
    left = quicksort_naive(for x <- tail, x < pivot, do: x)
    left |> IO.inspect(label: :left)
    right = quicksort_naive(for x <- tail, x >= pivot, do: x)
    right |> IO.inspect(label: :right)
    rc = left ++ [pivot] ++ right
    rc |> IO.inspect(label: :rc)
    rc
  end

  @doc """
  with some random pivot

  ## Examples

  iex> Algos.quicksort_random([4,3,6,1,5,2])
  [1,2,3,4,5,6]
  """
  def quicksort_random([]), do: []

  def quicksort_random(list) do
    list |> IO.inspect(label: :rc)

    list
    |> List.pop_at(random_position_in(list))
    |> quicksort_random_()
  end

  defp quicksort_random_({nil, _}), do: []
  defp quicksort_random_({pivot, []}), do: [pivot]

  defp quicksort_random_({pivot, sublist}) do
    pivot |> IO.inspect(label: :pivot)
    sublist |> IO.inspect(label: :tail)
    smaller_elements = for x <- sublist, x < pivot, do: x
    larger_elements = for x <- sublist, x >= pivot, do: x

    rc =
      quicksort_random_(
        List.pop_at(
          smaller_elements,
          random_position_in(smaller_elements)
        )
      ) ++
        [pivot] ++
        quicksort_random_(
          List.pop_at(
            larger_elements,
            random_position_in(larger_elements)
          )
        )

    rc |> IO.inspect(label: :rc)
    rc
  end

  defp random_position_in(list) when length(list) > 1, do: :rand.uniform(length(list) - 1)
  defp random_position_in(_), do: 0

  @doc """
  Median pivot
  """
  def quicksort_median([]), do: []

  def quicksort_median(list) do
    list
    |> List.pop_at(index_of_median_of_three_random_elements_from(list))
    |> quicksort_median_()
  end

  defp quicksort_median_({nil, _}), do: []
  defp quicksort_median_({pivot, []}), do: [pivot]

  defp quicksort_median_({pivot, sublist}) do
    smaller_elements = for x <- sublist, x < pivot, do: x
    larget_elements = for x <- sublist, x >= pivot, do: x

    quicksort_median_(
      List.pop_at(
        smaller_elements,
        index_of_median_of_three_random_elements_from(smaller_elements)
      )
    ) ++
      [pivot] ++
      quicksort_median_(
        List.pop_at(
          larget_elements,
          index_of_median_of_three_random_elements_from(larget_elements)
        )
      )
  end

  defp index_of_median_of_three_random_elements_from(list) when length(list) < 3, do: 0

  defp index_of_median_of_three_random_elements_from(list = [_ | _]) do
    median =
      list
      |> Enum.take_random(3)
      |> case do
        [a, b, c] when (a >= b and a <= c) or (a <= b and a >= c) -> a
        [a, b, c] when (b >= a and b <= c) or (b <= a and b >= c) -> b
        [_, _, c] -> c
      end

    Enum.find_index(list, fn x -> x == median end)
  end

  @doc """
  merge_sort

  ## Examples

  iex> Algos.merge_sort([4,3,6,1,5,2])
  [1,2,3,4,5,6]

  """
  def merge_sort([one]), do: [one]

  def merge_sort(list) do
    {left, right} = :lists.split(length(list) |> div(2), list)
    merge(merge_sort(left), merge_sort(right))
  end

  defp merge(l1, l2), do: merge(l1, l2, [])
  defp merge([], l2, acc), do: acc ++ l2
  defp merge(l1, [], acc), do: acc ++ l1
  defp merge([h1 | t1], [h2 | t2], acc) when h2 >= h1, do: merge(t1, [h2 | t2], acc ++ [h1])
  defp merge([h1 | t1], [h2 | t2], acc) when h1 > h2, do: merge([h1 | t1], t2, acc ++ [h2])

  @doc """
  binary_search

  ## Examples

  iex> Algos.binary_search([1,2,3,4,5,6], 4)
  3

  iex> Algos.binary_search([1,2,3,4,5,6], 7)
  :not_found
  """

  def binary_search(list, value),
    do: binary_search(List.to_tuple(list), value, 0, length(list) - 1)

  def binary_search(_tuple, _value, low, high) when high < low, do: :not_found

  def binary_search(tuple, value, low, high) do
    mid = (low + high) |> div(2)
    midval = elem(tuple, mid)

    cond do
      value < midval -> binary_search(tuple, value, low, mid - 1)
      value > midval -> binary_search(tuple, value, mid + 1, high)
      value == midval -> mid
    end
  end

  require Explorer.DataFrame, as: DF

  def nx_test do
    iris = Explorer.Datasets.iris()

    normalized_iris =
      DF.mutate(
        iris,
        for col <- across(~w(sepal_width sepal_length petal_length petal_width)) do
          {col.name, (col - mean(col)) / variance(col)}
        end
      )

    shuffled_normalized_iris = DF.shuffle(normalized_iris)
    "---------> " |> IO.inspect()
    train_df = DF.slice(shuffled_normalized_iris, 0..119)
    test_df = DF.slice(shuffled_normalized_iris, 120..149)
    test_df |> Explorer.DataFrame.shape() |> IO.inspect(label: :test)
    train_df |> Explorer.DataFrame.shape() |> IO.inspect(label: :train)
    feature_columns = ["sepal_length", "sepal_width", "petal_length", "petal_width"]
    # label_column = "species"
    x_train = Nx.stack(train_df[feature_columns], axis: 1)
    train_categories = train_df["species"] |> Explorer.Series.cast(:category)
    y_train = train_categories |> Nx.stack(axis: -1) |> Nx.equal(Nx.iota({1, 3}, axis: -1))
    x_test = Nx.stack(test_df[feature_columns], axis: 1)
    test_categories = test_df["species"] |> Explorer.Series.cast(:category)
    y_test = test_categories |> Nx.stack(axis: -1) |> Nx.equal(Nx.iota({1, 3}, axis: -1))
    model = Axon.input("iris_features") |> Axon.dense(3, activation: :softmax)
    # Axon.Display.as_graph(model, Nx.template({1, 4}, :f32))
    data_stream = Stream.repeatedly(fn -> {x_train, y_train} end)

    trained_model_state =
      model
      |> Axon.Loop.trainer(:categorical_cross_entropy, :sgd)
      |> Axon.Loop.metric(:accuracy)
      |> Axon.Loop.run(data_stream, %{}, iterations: 500, epochs: 10)

    #
    data = [{x_test, y_test}]

    # data = [{x_train, y_train}]
    model
    |> Axon.Loop.evaluator()
    |> Axon.Loop.metric(:accuracy)
    |> Axon.Loop.run(data, trained_model_state)
  end

  def tensors do
    tensor = Nx.random_uniform({1_000_1000})

    Benchee.run(
      %{
        "JIT with EXLA" => fn -> apply(EXLA.jit(&Softmax.softmax/1), [tensor]) end,
        "Regular Elixir" => fn -> Softmax.softmax(tensor) end
      },
      time: 20
    )
  end

  def sigils_test do
    import Nx
    m= ~M(1 2
          3 4)
    w= ~M[10 20
          30 40]
    Nx.weighted_mean(m, w, axes: [1])
  end
end
