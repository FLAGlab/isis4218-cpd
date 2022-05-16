defmodule Reducer do
  import Splitter
  require Stream.Reducers, as: R
  def reduce(collection, acc, reducer, combiner) do
    { :ok, sup } = Task.Supervisor.start_link()
    map_job = &(fn -> Enumerable.reduce(&1, acc, reducer) end)
    reduce_job = &(&1
                    |> Task.await(5000)
                    |> elem(1)
                    |> combiner.(&2))
    collection
      |> Splitter.split()
      |> Enum.map(&(Task.Supervisor.async(sup, map_job.(&1))))
      |> Enum.reduce(acc, reduce_job)
  end



  def reducer_filter(collection, fun) do
    combiner = fn x, {_, acc} -> {:cont, x ++ acc} end
    Reducer.reduce(collection, {:cont, []}, R.filter(fun), combiner)
      |> elem(1)
      |> :lists.reverse()
  end
end
