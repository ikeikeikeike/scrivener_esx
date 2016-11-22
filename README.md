# Scrivener.ESx

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `scrivener_esx` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:scrivener_esx, "~> 0.1.0"}]
    end
    ```

  2. Ensure `scrivener_esx` is started before your application:

    ```elixir
    def application do
      [applications: [:scrivener_esx]]
    end
    ```

## Usage

```elixir
defmodule MyApp.ESx do
  use ESx.Model.Base, app: :my_app
  use Scrivener, page_size: 10
end
```

```elixir

defmodule MyApp.Blog do
  use MyApp.Web, :model
  use ESx.Schema

  schema "blogs" do
    field :title, :string
    field :content, :string
    field :publish, :boolean

    timestamps
  end

  mapping do
    indexes :title, type: "string"
    indexes :content, type: "string"
    indexes :publish, type: "boolean"
  end
```

```elixir
def index(conn, params) do
  page =
    MyApp.Blog
    |> MyApp.ESx.search(%{query: %{match: %{title: "foo"}}})
    |> MyApp.ESx.paginate(params)

  render conn, :index,
    people: page.entries,
    page_number: page.page_number,
    page_size: page.page_size,
    total_pages: page.total_pages,
    total_entries: page.total_entries
end
```

```elixir
page =
  MyApp.Blog
  |> MyApp.ESx.search(%{query: %{match: %{title: "foo"}}})
  |> MyApp.ESx.paginate(page: 2, page_size: 5)
```
