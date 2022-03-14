defmodule StateMachine do
  def s1() do
    receive do
      :a -> s2()
      :c -> s3()
    end
  end
  def s2() do
    receive do
      :x -> s3()
      :h -> s4()
    end
  end
  def s3() do
    receive do
      :b -> s1()
      :y -> s4()
    end
  end
  def s4() do
    receive do
      i -> s3()
    end
  end
end
