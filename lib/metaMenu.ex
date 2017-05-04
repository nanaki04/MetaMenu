defmodule MetaMenu do
  @moduledoc """
  A module for handling menu states, and adjusting data behind menu interfaces,
  allowing to move back and forth between menus easily.
  """

  defstruct history_list: [], forward_list: []
  alias MetaMenu.Menu, as: Menu

  def push_menu(meta_menu) do
    %MetaMenu{meta_menu | history_list: [%MetaMenu.Menu{} | meta_menu.history_list]}
  end

  def get_current_menu(%{history_list: []}), do: {:error, :no_current_menu}
  def get_current_menu(meta_menu) do
    {:ok, hd meta_menu.history_list}
  end

  def push_menu_item(meta_menu, menu_item) do
    with {:ok, menu} <- get_current_menu(meta_menu) do
      menu
      |> Menu.push_menu_item(menu_item)
      |> update_current_menu(meta_menu)
    end
  end

  def set_current_menu_title(meta_menu, title) do
    with {:ok, menu} <- get_current_menu(meta_menu) do
      menu
      |> Menu.set_title(title)
      |> update_current_menu(meta_menu)
    end
  end

  def get_current_menu_title(meta_menu) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_title()
  end

  def set_current_menu_request_text(meta_menu, request_text) do
    with {:ok, menu} <- get_current_menu(meta_menu) do
      menu
      |> Menu.set_request_text(request_text)
      |> update_current_menu(meta_menu)
    end
  end

  def get_current_menu_request_text(meta_menu) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_request_text()
  end

  def get_menu_item(meta_menu, item_index) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_menu_item(item_index)
  end

  def get_current_menu_item_length(%{history_list: []}), do: {:ok, 0}
  def get_current_menu_item_length(meta_menu) do
    with {:ok, menu} <- get_current_menu(meta_menu), do:
      menu |> Menu.get_item_length()
  end

  def go_back(%{history_list: []} = meta_menu), do: meta_menu
  def go_back(meta_menu) do
    meta_menu = %MetaMenu{meta_menu | forward_list: [hd(meta_menu.history_list) | meta_menu.forward_list]}
    %MetaMenu{meta_menu | history_list: tl(meta_menu.history_list)}
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

  defp update_current_menu(menu, meta_menu), do: 
    %MetaMenu{meta_menu | history_list: [menu | tl(meta_menu.history_list)]}

end
