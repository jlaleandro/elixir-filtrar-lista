defmodule Desafio do
  # lista =  ["1", "3", "6", "43", "banana", "6", "abc"]

  def list_filter(lista) do
    result =
      Enum.flat_map(lista, fn string ->
        case Integer.parse(string) do
          # transform to integer
          {int, _rest} -> [rem(int, 2)]
          # skip the value
          :error -> []
        end
      end)

    length(result, 0)
  end

  defp length([], impar), do: impar

  defp length([head | tail], impar) do
    IO.inspect(head)

    if head != 0 do
      impar + 1

      # the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
    else
      impar
    end

    length(tail, impar)
  end
end