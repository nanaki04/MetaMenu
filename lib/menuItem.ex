defmodule MetaMenu.Item do
  @moduledoc """
  Data structure representing a single menu item

  index:        The index is intended to be usable as a visible identifier to the user, and thus will start counting at 1, instead of 0
  text:         The text associated with the menu item. ex. "Start Game"
  on_select:    The function to be executed when the item is selected
  on_select_arguments: Arguments passed to the on select function
  custom_data:  a map to be used freely by the user to set values not supported out of the box by this module. ex. "%{image_id: 2, color: :red}%
  """

  defstruct index: 1, text: "ambiguous menu item", on_select: &__MODULE__.on_unset_select/1, custom_data: %{}, select_arguments: []

  def set_item_index(item, index) do
    %MetaMenu.Item{item | index: index}
  end

  def set_item_text(item, text) do
    %MetaMenu.Item{item | text: text}
  end

  def set_on_select(item, callback) do
    %MetaMenu.Item{item | on_select: callback}
  end

  def set_select_arguments(item, select_arguments) do
    %MetaMenu.Item{item | select_arguments: select_arguments}
  end

  def update_custom_data(item, update_lambda) do
    %MetaMenu.Item{item | custom_data: update_lambda.(item.custom_data)}
  end

  def get_item_index(item) do
    {:ok, item.index}
  end

  def get_item_text(item) do
    {:ok, item.text}
  end

  def get_custom_data(item) do
    {:ok, item.custom_data}
  end

  def on_select(item, meta_menu) do
    item.on_select.(meta_menu, item.select_arguments)
  end

  def on_unset_select(_, _), do: {:error, :no_selection_callback_set}

end
