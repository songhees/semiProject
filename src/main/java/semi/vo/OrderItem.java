package semi.vo;

public class OrderItem {
	private Order order;
	private long orderProductPrice;
	private int orderProductQuantity;
	private ProductItem productItem;
	
	public OrderItem() {}

	public Order getOrder() {
		return order;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public long getOrderProductPrice() {
		return orderProductPrice;
	}

	public void setOrderProductPrice(long orderProductPrice) {
		this.orderProductPrice = orderProductPrice;
	}

	public int getOrderProductQuantity() {
		return orderProductQuantity;
	}

	public void setOrderProductQuantity(int orderProductQuantity) {
		this.orderProductQuantity = orderProductQuantity;
	}

	public ProductItem getProductItem() {
		return productItem;
	}

	public void setProductItem(ProductItem productItem) {
		this.productItem = productItem;
	}
}
