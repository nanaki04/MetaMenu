defmodule MetaMenuTest do
  use ExUnit.Case
  doctest MetaMenu

  test "push_menu" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    assert {:ok, _} = MetaMenu.get_current_menu(meta_menu)
  end

  test "get_current_menu fail" do
    meta_menu = %MetaMenu{}
    assert {:error, :no_current_menu} = MetaMenu.get_current_menu(meta_menu)
  end

  test "get_current_menu" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    assert {:ok, _} = MetaMenu.get_current_menu(meta_menu)
  end

  test "push_menu_item" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu_item(:menu_item)
    assert {:ok, _menu_item} = MetaMenu.get_menu_item(meta_menu, 0)
  end

  test "set_current_menu_title" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Mock Menu")
    assert {:ok, "Mock Menu"} = MetaMenu.get_current_menu_title(meta_menu)
  end

  test "set_current_menu_request_text" do
    request_text = "Select the menu item of your choice.\nNo Cheating!"
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_request_text(request_text)
    assert {:ok, ^request_text} = MetaMenu.get_current_menu_request_text(meta_menu)
  end

  test "get_current_menu_item_length 0" do
    meta_menu = %MetaMenu{}
    assert {:ok, 0} = MetaMenu.get_current_menu_item_length(meta_menu)
  end

  test "get_current_menu_item_length" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu_item(:item_1)
    |> MetaMenu.push_menu_item(:item_2)
    assert {:ok, 2} = MetaMenu.get_current_menu_item_length(meta_menu)
  end

  test "go_back" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Menu 1")
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Menu 2")
    |> MetaMenu.go_back()
    assert {:ok, "Menu 1"} = MetaMenu.get_current_menu_title(meta_menu)
  end

  test "go_forward" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Menu 1")
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Menu 2")
    |> MetaMenu.go_back()
    |> MetaMenu.go_forward()
    assert {:ok, "Menu 2"} = MetaMenu.get_current_menu_title(meta_menu)
  end

  test "can_go_forward? no" do
    meta_menu = %MetaMenu{}
    assert false === MetaMenu.can_go_forward?(meta_menu)
  end

  test "can_go_forward? yes" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu()
    |> MetaMenu.go_back()
    assert MetaMenu.can_go_forward?(meta_menu)
  end

  test "can_go_backward? no" do
    meta_menu = %MetaMenu{}
    assert false === MetaMenu.can_go_backward?(meta_menu)
  end

  test "can_go_backward? yes" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu()
    assert MetaMenu.can_go_backward?(meta_menu)
  end
end
