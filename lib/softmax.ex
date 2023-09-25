defmodule Softmax do
  import Nx.Defn
  defn(softmax(n), do: Nx.exp(n) / Nx.sum(Nx.exp(n)))
end
