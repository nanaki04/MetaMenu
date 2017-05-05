defmodule MetaMenu.Menu do
  @moduledoc """
  Data structure representing a single menu

  items:        a list of menu items that make up the menu
  item_count:   number of items registered to the menu
  title:        the title of the menu
  description:  a more elaborate description, or usage explanation of the menu
  custom_data:  a map to be used freely by the user to set values not supported out of the box by this module. ex. "%{menu_style: :desert}%
  """

  defstruct items: [], item_count: 0, title: "", description: "", custom_data: %{}

  def push_menu_item(menu), do: push_menu_item(menu, %MetaMenu.Item{})
  def push_menu_item(menu, menu_item) do
    %MetaMenu.Menu{menu | items: [menu_item | menu.items]}
    |> increment_item_count()
  end

  def set_title(menu, title) do
    %MetaMenu.Menu{menu | title: title}
  end

  def set_description(menu, description) do
    %MetaMenu.Menu{menu | description: description}
  end

  def update_custom_data(menu, update_lambda) do
    %MetaMenu.Menu{menu | custom_data: update_lambda.(menu.custom_data)}
  end

  def select_menu_item(menu, item_index, meta_menu) do
    with {:ok, menu_item} <- get_menu_item(menu, item_index), do:
      menu_item |> MetaMenu.Item.on_select(meta_menu)
  end

  def get_title(%{title: title}) do 
    {:ok, title}
  end

  def get_description(%{description: description}) do 
    {:ok, description}
  end

  def get_custom_data(%{custom_data: custom_data}) do
    {:ok, custom_data}
  end

  def get_item_count(menu) do
    {:ok, menu.item_count}
  end

  def get_menu_item(menu, item_index) do
    with :index_out_of_range <- Enum.at(menu.items, convert_item_index(menu, item_index), :index_out_of_range) do
      {:error, :index_out_of_range}
    else
      menu_item -> {:ok, menu_item}
    end
  end

  def get_last_menu_item(%{items: []}), do: {:error, :no_menu_items_set}
  def get_last_menu_item(menu) do
    {:ok, hd(menu.items)}
  end

  def set_last_menu_item_index(menu, item_index) do
    apply_update_on_last_menu_item(menu, :set_item_index, [item_index])
  end

  def set_last_menu_item_text(menu, item_text) do
    apply_update_on_last_menu_item(menu, :set_item_text, [item_text])
  end

  def set_last_menu_item_select_callback(menu, on_select) do
    apply_update_on_last_menu_item(menu, :set_on_select, [on_select])
  end

  def update_last_menu_item_custom_data(menu, update_lambda) do
    apply_update_on_last_menu_item(menu, :update_custom_data, [update_lambda])
  end

  def read_each_menu_item(menu, lambda) do
    menu_items = Enum.sort(menu.items, fn(item_1, item_2) -> item_1.index < item_2.index end)
    Enum.each(menu_items, fn(item) ->
      with {:ok, item_index} <- MetaMenu.Item.get_item_index(item),
        {:ok, item_text} <- MetaMenu.Item.get_item_text(item),
        {:ok, custom_data} <- MetaMenu.Item.get_custom_data(item),
      do:
        lambda.(item_index, item_text, custom_data)
    end)
  end

  defp apply_update_on_last_menu_item(menu, method, args) do
    with {:ok, menu_item} <- get_last_menu_item(menu) do
      apply(MetaMenu.Item, method, [menu_item | args])
      |> update_last_menu_item(menu)
    end
  end

  defp update_last_menu_item(menu_item, menu), do:
    %MetaMenu.Menu{menu | items: [menu_item | tl(menu.items)]}

  defp increment_item_count(menu), do:
    %MetaMenu.Menu{menu | item_count: menu.item_count + 1}

  defp convert_item_index(menu, item_index), do:
    menu.item_count - item_index

end
