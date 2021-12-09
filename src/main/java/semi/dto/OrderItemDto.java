package semi.dto;

import java.util.Date;

public class OrderItemDto {
	// Order order
	private int orderNo;
	private long totalPrice;
	private String status;
	private Date orderCreatedDate;
	// OrderItem
	private long orderProductPrice;
	private int orderProductQuantity;
	// ProductItem
	private int productItemNo;
	private String size;
	private String color;
	// Product
	private int productNo;
	private String productName;
	private String thumbnailUrl;
	private long productPrice;
	
	public OrderItemDto() {}

	public long getProductPrice() {
		return productPrice;
	}



	public void setProductPrice(long productPrice) {
		this.productPrice = productPrice;
	}



	public int getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}

	public long getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(long totalPrice) {
		this.totalPrice = totalPrice;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getOrderCreatedDate() {
		return orderCreatedDate;
	}

	public void setOrderCreatedDate(Date orderCreatedDate) {
		this.orderCreatedDate = orderCreatedDate;
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

	public int getProductItemNo() {
		return productItemNo;
	}

	public void setProductItemNo(int productItemNo) {
		this.productItemNo = productItemNo;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public int getProductNo() {
		return productNo;
	}

	public void setProductNo(int productNo) {
		this.productNo = productNo;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getThumbnailUrl() {
		return thumbnailUrl;
	}

	public void setThumbnailUrl(String thumbnailUrl) {
		this.thumbnailUrl = thumbnailUrl;
	}
}
