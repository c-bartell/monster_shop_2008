class OrdersController <ApplicationController

  def new

  end

  def index
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])
    order.update(status: "Cancelled")
    order.item_orders.each do |item_order|
      item_order.update(status: "unfulfilled")
    end
    flash[:notice] = "Your order has been cancelled."
    redirect_to "/profile/orders/#{order.id}"
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
