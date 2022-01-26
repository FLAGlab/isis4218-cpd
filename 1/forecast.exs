defmodule Temp do
  def converter(forecast, day) do
  case day do
    :Monday -> %{:Monday => c} = forecast; %{forecast | :Monday => c * 1.8 + 32}
    :Tuesday -> %{:Tuesday => c} = forecast; %{forecast | :Tuesday => c * 1.8 + 32}
    :Wednesday -> %{:Wednesday => c} = forecast; %{forecast | :Wednesday => c * 1.8 + 32}
    :Thursday -> %{:Thursday => c} = forecast; %{forecast | :Thursday => c * 1.8 + 32}
    :Friday -> %{:Friday => c} = forecast; %{forecast | :Friday => c * 1.8 + 32}
    :Saturday -> %{:Saturday => c} = forecast; %{forecast | :Saturday => c * 1.8 + 32}
    :Sunday -> %{:Sunday => c} = forecast; %{forecast | :Sunday => c * 1.8 + 32}
  end
end
end
