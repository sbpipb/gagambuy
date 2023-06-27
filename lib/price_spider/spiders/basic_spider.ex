defmodule PriceSpider.BasicSpider do
  use Crawly.Spider
  @impl Crawly.Spider

  def base_url do
    # "https://www.rapha.cc"
        "https://maap.cc"
  end

  @impl Crawly.Spider
  def init() do
    [
      start_urls: [
        # "https://www.rapha.cc/rd/en/archive-sale/category/archive?q=size:X-Small:gender:Mens&sort=price-desc&"
        "https://maap.cc/collections/archive-sale-man"
      ]
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # url = "https://maap.cc/collections/archive-sale-man"
    # response = Crawly.fetch url
    
    {:ok, document} =
       response.body
       |> Floki.parse_document


    products =
      document
      |> Floki.find(".product_card > .productDetails > .productMeta > a")

    {"a", url, product} = List.first products

    {"href", product_link } = List.last(url)

    [product_name, price] = product
                            |> Floki.text
                            |> String.split("Now")

    [sale_price, original_price] = price
      |> String.split(" AUD", trim: true)

    %Crawly.ParsedItem{
      :items => [
        %{"product_link"=> product_link,
        "name" => product_name,
        "price" => sale_price,
        "og_price" => original_price}
        ],
        :requests => []
      }
  end
end

