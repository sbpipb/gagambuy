defmodule PriceSpider.BasicSpider do
  @moduledoc """
  This module is to crawl maap products for update archive sale prices
  """
  use Crawly.Spider
  @impl Crawly.Spider

  def base_url(), do: "https://maap.cc"

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        "https://maap.cc/collections/archive-sale-man",
        "https://maap.cc/collections/archive-sale-woman"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # url = "https://maap.cc/collections/archive-sale-man"
    # response = Crawly.fetch url
    
    products = response.body |> Floki.parse_document |> elem(1) |> Floki.find(".product_card > .productDetails > .productMeta > a")

    items = products |> Enum.map(fn product -> 
      url = product |> elem(1) |> List.last |> elem(1)
      [product_name, price] = product |> Floki.text |> String.split("Now")
      [sale_price, original_price] = price |> String.split(" AUD", trim: true)

      %{url: url,
        name: product_name,
        price: sale_price,
        og_price: original_price}
    end)

    %Crawly.ParsedItem{
      :items => items,
      :requests => []
    }
  end
end

