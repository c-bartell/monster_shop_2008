class CartController < ApplicationController

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    if current_admin?
      render file: "/public/404"
    else
      @items = cart.items
    end
  end

  def destroy
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def increase_item
    item = Item.find(params[:item_id])
    if item.inventory == cart.contents[item.id.to_s]
      flash[:notice] = "There are no more items left in inventory"
    else
      cart.add_item(item.id.to_s)
    end
    redirect_to '/cart'
  end

  def decrease_item
    item = Item.find(params[:item_id])

    cart.remove_item(item.id.to_s)

    redirect_to '/cart'
  end
end
