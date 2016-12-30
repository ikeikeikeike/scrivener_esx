defimpl Scrivener.Paginater, for: ESx.Model.Search do
  @moduledoc false

  defmodule Page do
    @moduledoc false

    defstruct [:entries, :page_number, :page_size, :total_entries, :total_pages, :expand]

    @type t :: %__MODULE__{}

    defimpl Enumerable, for: Page do
      def count(_page), do: {:error, __MODULE__}

      def member?(_page, _value), do: {:error, __MODULE__}

      def reduce(%Page{entries: entries}, acc, fun) do
        Enumerable.reduce(entries, acc, fun)
      end
    end
  end

  alias Scrivener.Config

  @spec paginate(ESx.Model.Search.t, Scrivener.Config.t) :: Page.t
  def paginate(search, %Config{page_size: page_size, page_number: page_number, module: model}) do
    model = Map.get search, :__model__, model
    search = pager_condition(search, page_number, page_size)

    {rsp, entries, total_entries} =
      if model.repo do
        rsp = model.records search
        {rsp.records, rsp.total}
      else
        rsp = model.results search
        {rsp.hits, rsp.total}
      end

    %Page{
      expand: rsp,
      page_size: page_size,
      page_number: page_number,
      entries: entries,
      total_entries: total_entries,
      total_pages: total_pages(total_entries, page_size)
    }
  end

  def distance(%Page{} = page) do
    %{
      prev_page: page.page_number - 1,
      next_page: page.page_number + 1,
      has_prev: page.page_number > 1,
      has_next: page.page_number < page.total_pages
    }
  end

  defp pager_condition(%{args: args} = search, page_number, page_size) do
    body = Map.merge(args[:body], %{
      size: page_size,
      from: page_size * (page_number - 1)
    })

    put_in search, [key(:args), key(:body)], body
  end

  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end

  # For elixir 1.2
  # https://github.com/elixir-lang/elixir/blob/146f14ff6966e5bb5e85ea0ad61b959aeee91f7f/lib/elixir/lib/access.ex#L400
  defp key(key, default \\ nil) do
    fn
      :get, data, next ->
        next.(Map.get(data, key, default))
      :get_and_update, data, next ->
        value = Map.get(data, key, default)
        case next.(value) do
          {get, update} -> {get, Map.put(data, key, update)}
          :pop -> {value, Map.delete(data, key)}
        end
    end
  end

end
