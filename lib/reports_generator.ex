defmodule ReportsGenerator do
  def build(filename) do
    "reports/#{filename}"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, file_content}), do: file_content
  defp handle_file({:error, _reason}), do: "Error while opening file!"
end

# def build(filename) do
#   case File.read("reports/#{filename}") do
#     {:ok, result} -> result
#     {:error, result} -> result
#   end
# end
