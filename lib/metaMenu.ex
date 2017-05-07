defmodule MetaMenu do
  @moduledoc """
  A module for handling menu states, and adjusting data behind menu interfaces,
  allowing to move back and forth between menus easily.

  history_list: A list of menus the user has been navigating through, up to the currently displaying, or most recently pushed menu.
  forward_list: A list of menus the user has been displaying, but navigated away from using the go back functionality. The user can return to the menus in the forward list using the go forward functionality. On pushing a new menu, the forward list will be cleared.
  """

  defstruct history_list: [], forward_list: []
  alias MetaMenu.Menu, as: Menu

  def push_menu(meta_menu), do: push_menu(meta_menu, %MetaMenu.Menu{})
  def push_menu(meta_menu, menu) do
    %MetaMenu{meta_menu | history_list: [menu | meta_menu.history_list], forward_list: []}
  end

  def push_menu_item(meta_menu), do: push_menu_item(meta_menu, %MetaMenu.Item{})
  def push_menu_item(meta_menu, menu_item) do
    apply_update_on_current_menu(meta_menu, :push_menu_item, [menu_item])
  end

  def pop_menu(%{history_list: []} = meta_menu), do: meta_menu
  def pop_menu(meta_menu) do
    %MetaMenu{meta_menu | history_list: tl(meta_menu.history_list)}
  end

  def set_current_menu_title(meta_menu, title) do
    apply_update_on_current_menu(meta_menu, :set_title, [title])
  end

  def set_current_menu_description(meta_menu, description) do
    apply_update_on_current_menu(meta_menu, :set_description, [description])
  end

  def update_current_menu_custom_data(meta_menu, update_lambda) do
    apply_update_on_current_menu(meta_menu, :update_custom_data, [update_lambda])
  end

  def set_last_menu_item_index(meta_menu) do
    with {:ok, count} <- get_current_menu_item_count(meta_menu), do:
      set_last_menu_item_index(meta_menu, count)
  end
  def set_last_menu_item_index(meta_menu, index) do
    apply_update_on_current_menu(meta_menu, :set_last_menu_item_index, [index])
  end

  def set_last_menu_item_text(meta_menu, item_text) do
    apply_update_on_current_menu(meta_menu, :set_last_menu_item_text, [item_text])
  end

  def set_last_menu_item_select_callback(meta_menu, on_select) do
    apply_update_on_current_menu(meta_menu, :set_last_menu_item_select_callback, [on_select])
  end

  def set_last_menu_item_select_arguments(meta_menu, select_arguments) do
    apply_update_on_current_menu(meta_menu, :set_last_menu_item_select_arguments, [select_arguments])
  end

  def update_last_menu_item_custom_data(meta_menu, update_lambda) do
    apply_update_on_current_menu(meta_menu, :update_last_menu_item_custom_data, [update_lambda])
  end

  def select_menu_item(meta_menu, item_index) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> MetaMenu.Menu.select_menu_item(item_index, meta_menu)
  end

  @doc """
  Loops through all the menu items of the current menu. The second argument is a callback function which will be passed the following arguments:
  1. item_index, the number associated with the item in relation to other menu items. ex. "1."
  2. item_text, the text associated with the menu item. ex. "Start Game"
  3. Custom_data, a map to be used freely by the user to set values not supported out of the box by this module. ex. "%{image_id: 2, color: :red}%
  """
  def read_each_current_menu_item(meta_menu, lambda) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> MetaMenu.Menu.read_each_menu_item(lambda)
  end

  def get_current_menu(%{history_list: []}), do: {:error, :no_current_menu}
  def get_current_menu(meta_menu) do
    {:ok, hd meta_menu.history_list}
  end

  def get_menu_item(meta_menu, item_index) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_menu_item(item_index)
  end

  def get_current_menu_title(meta_menu) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_title()
  end

  def get_current_menu_description(meta_menu) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_description()
  end

  def get_current_menu_custom_data(meta_menu) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_custom_data()
  end

  def get_current_menu_item_count(%{history_list: []}), do: {:ok, 0}
  def get_current_menu_item_count(meta_menu) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_item_count()
  end

  def go_back(%{history_list: []} = meta_menu), do: meta_menu
  def go_back(meta_menu) do
    %MetaMenu{meta_menu | forward_list: [hd(meta_menu.history_list) | meta_menu.forward_list]}
    |> pop_menu()
  end

  def go_forward(%{forward_list: []} = meta_menu), do: meta_menu
  def go_forward(meta_menu) do
    meta_menu = %MetaMenu{meta_menu | history_list: [hd(meta_menu.forward_list) | meta_menu.history_list]}
    %MetaMenu{meta_menu | forward_list: tl(meta_menu.forward_list)}
  end

  def can_go_forward?(meta_menu) do
    length(meta_menu.forward_list) > 0
  end

  def can_go_backward?(meta_menu) do
    length(meta_menu.history_list) > 1
  end

  defp apply_update_on_current_menu(meta_menu, method, args) do
    with {:ok, menu} <- get_current_menu(meta_menu) do
      apply(MetaMenu.Menu, method, [menu | args])
      |> update_current_menu(meta_menu)
    end
  end

  defp update_current_menu(menu, meta_menu), do: 
    %MetaMenu{meta_menu | history_list: [menu | tl(meta_menu.history_list)]}

end
