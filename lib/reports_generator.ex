defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["users", "foods"]

  # teste no iex com time
  # iex(8)> :timer.tc(fn -> ReportsGenerator.build("report_complete.csv")  end)
  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of strings"}
  end

  # teste no iex
  # ReportsGenerator.build_from_many(["report_1.csv", "report_2.csv", "report_3.csv"])
  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(&build/1)
      |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)

    {:ok, result}
  end

  # teste no iex
  # "report_complete.csv" |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost("users")
  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  def fetch_higher_cost(_report, _option), do: {:error, "Invalid option!"}

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods}) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    build_report(users, foods)
  end

  defp sum_reports(%{"users" => users1, "foods" => foods1}, %{
         "users" => users2,
         "foods" => foods2
       }) do
    users = merge_maps(users1, users2)
    foods = merge_maps(foods1, foods2)

    build_report(users, foods)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  defp report_acc do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@available_foods, %{}, &{&1, 0})

    build_report(users, foods)
  end

  defp build_report(users, foods), do: %{"users" => users, "foods" => foods}
end
