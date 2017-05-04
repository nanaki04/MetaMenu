defmodule MetaMenu.Menu do
  @moduledoc """
  Data structure representing a single menu
  """

  defstruct items: [], meta_data: %{}

  def push_menu_item(menu, menu_item) do
    %MetaMenu.Menu{menu | items: [menu_item | menu.items]}
  end

  def set_title(menu, title) do
    %MetaMenu.Menu{menu | meta_data: Map.put(menu.meta_data, :title, title)}
  end

  def get_title(%{meta_data: %{title: title}}), do: {:ok, title}
  def get_title(_), do: {:error, :no_title_set}

  def set_request_text(menu, request_text) do
    %MetaMenu.Menu{menu | meta_data: Map.put(menu.meta_data, :request_text, request_text)}
  end

  def get_request_text(%{meta_data: %{request_text: request_text}}), do: {:ok, request_text}
  def get_request_text(_), do: {:error, :no_request_text_set}

  def get_item_length(menu) do
    {:ok, length(menu.items)}
  end

  def get_menu_item(menu, item_index) do
    with :index_out_of_range<- Enum.at(menu.items, item_index, :index_out_of_range) do
      {:errpr, :index_out_of_range}
    else
      menu_item -> {:ok, menu_item}
    end
  end
end
