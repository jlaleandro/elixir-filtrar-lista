defmodule Desafio do
  # lista =  ["1", "3", "6", "43", "banana", "6", "abc"]
  # retorna lista com restos div/2 [1,1,0,1,0]
  def list_filter(lista) do
    result =
      Enum.flat_map(lista, fn string ->
        case Integer.parse(string) do
          {int, _rest} -> [rem(int, 2)]
          :error -> []
        end
      end)

    qtdimpar(result, 0)
  end

  defp qtdimpar([], impar), do: impar

  defp qtdimpar([head | tail], impar) do
    impar = if head != 0, do: impar + 1, else: impar
    qtdimpar(tail, impar)
  end

  # ou
  # impar = evaluate_head(head, impar)

  # defp evaluate_head(0, impar), do: impar
  # defp evaluate_head(_, impar), do: impar + 1
end
