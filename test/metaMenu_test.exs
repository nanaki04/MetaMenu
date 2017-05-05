defmodule MetaMenuTest do
  use ExUnit.Case
  doctest MetaMenu

  test "push_menu" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    assert {:ok, _} = MetaMenu.get_current_menu(meta_menu)
  end

  test "push_menu_item" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu_item()
    assert {:ok, _menu_item} = MetaMenu.get_menu_item(meta_menu, 1)
  end

  test "pop_menu" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.pop_menu()
    assert {:error, :no_current_menu} = MetaMenu.get_current_menu(meta_menu)
  end

  test "set_current_menu_title" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Mock Menu")
    assert {:ok, "Mock Menu"} = MetaMenu.get_current_menu_title(meta_menu)
  end

  test "set_current_menu_description" do
    description = "Select the menu item of your choice.\nNo Cheating!"
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_description(description)
    assert {:ok, ^description} = MetaMenu.get_current_menu_description(meta_menu)
  end

  test "set_last_menu_item_index auto" do
    %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu_item()
    |> MetaMenu.set_last_menu_item_index()
    |> MetaMenu.read_each_current_menu_item(fn(index, _text, _custom_data) ->
      assert index === 1
    end)
  end

  test "set_last_menu_item_index" do
    %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu_item()
    |> MetaMenu.set_last_menu_item_index(5)
    |> MetaMenu.read_each_current_menu_item(fn(index, _text, _custom_data) ->
      assert index === 5
    end)
  end

  test "set_last_menu_item_text" do
    %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu_item()
    |> MetaMenu.set_last_menu_item_text("Start Game")
    |> MetaMenu.read_each_current_menu_item(fn(_index, text, _custom_data) ->
      assert text === "Start Game"
    end)
  end

  test "set_last_menu_item_select_callback" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Menu 1")
    |> MetaMenu.push_menu()
    |> MetaMenu.set_current_menu_title("Menu 2")
    |> MetaMenu.push_menu_item()
    |> MetaMenu.set_last_menu_item_index(1)
    |> MetaMenu.set_last_menu_item_select_callback(&MetaMenu.go_back/1)
    |> MetaMenu.select_menu_item(1)
    assert {:ok, "Menu 1"} = MetaMenu.get_current_menu_title(meta_menu)
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

  test "get_current_menu_item_count 0" do
    meta_menu = %MetaMenu{}
    assert {:ok, 0} = MetaMenu.get_current_menu_item_count(meta_menu)
  end

  test "get_current_menu_item_count" do
    meta_menu = %MetaMenu{}
    |> MetaMenu.push_menu()
    |> MetaMenu.push_menu_item()
    |> MetaMenu.push_menu_item()
    assert {:ok, 2} = MetaMenu.get_current_menu_item_count(meta_menu)
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
