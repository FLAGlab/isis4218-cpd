defmodule Person do
  defstruct name: "", age: 0, gender: :NONE, country: "Afganistan"

  #@spec can_drink?(Person) :: Boolean
  @doc """
  Country	On_Premise_Purchase_Age
  Afghanistan	Total ban
  Albania	18
  Algeria	18
  Andorra	18
  Angola	18
  Antigua and Barbuda	10
  Argentina	18
  Armenia	18
  Australia	18
  Austria	16
  Azerbaijan	18
  Bahamas	18
  Bahrain	Illegal (18 for non-Muslims)
  Bangladesh	Total ban
  Barbados	18
  Belarus	18
  Belgium	16
  Belize	18
  Benin	No age minimum
  Bhutan	18
  Bolivia	No age minimum
  Bosnia and Herzegovina	18
  Botswana	18
  Brazil	18
  Brunei Darussalam	Total ban
  Bulgaria	18
  Burkina Faso	No age minimum
  Burundi	18
  Cambodia	No age minimum
  Cameroon	No age minimum
  Canada	19
  Cape Verde	18
  Central African Republic	15
  Chad	18
  Chile	18
  China	No age minimum
  Colombia	18
  Comoros	18
  Congo	16
  Costa Rica	18
  Côte d'Ivoire	21
  Croatia	18
  Cuba	18
  Cyprus	17
  Czech Republic	18
  """
  def can_drink?(p, nac) do
    {err, n} = Map.fetch(nac, p.country)
    case err do
      :ok -> p.age >= n
      _ -> false
    end
  end



end
