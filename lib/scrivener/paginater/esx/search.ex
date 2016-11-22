defimpl Scrivener.Paginater, for: ESx.Model.Search do
  alias Scrivener.{Config, Page}
  import Access

  @moduledoc false

  @spec paginate(ESx.Model.Search.t, Scrivener.Config.t) :: Scrivener.Page.t
  def paginate(search, %Config{page_size: page_size, page_number: page_number, module: model}) do
    model = Map.get search, :__model__, model
    search = pager_condition(search, page_number, page_size)

    {entries, total_entries} =
      if model.repo do
        rsp = model.records search
        {rsp.records, rsp.total}
      else
        rsp = model.results search
        {rsp.hits, rsp.total}
      end

    %Page{
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

end
