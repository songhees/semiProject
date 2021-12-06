package semi.dto;

import java.util.Date;

public class CartItemDto {
	private int userNo;
	private int quantity;
	// ProductItem
	private int stock;
	private int productItemNo;
	private String size;
	private String color;
	// Product
	private int productNo;
	private String name;
	private long price;
	private long discountPrice;
	private Date discountFrom;
	private Date discountTo;
	private String onSale;
	private String thumbnailUrl;
	
	public CartItemDto() {}

	public int getUserNo() {
		return userNo;
	}

	public void setUserNo(int userNo) {
		this.userNo = userNo;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getPrice() {
		return price;
	}

	public void setPrice(long price) {
		this.price = price;
	}

	public long getDiscountPrice() {
		return discountPrice;
	}

	public void setDiscountPrice(long discountPrice) {
		this.discountPrice = discountPrice;
	}

	public Date getDiscountFrom() {
		return discountFrom;
	}

	public void setDiscountFrom(Date discountFrom) {
		this.discountFrom = discountFrom;
	}

	public Date getDiscountTo() {
		return discountTo;
	}

	public void setDiscountTo(Date discountTo) {
		this.discountTo = discountTo;
	}

	public String getOnSale() {
		return onSale;
	}

	public void setOnSale(String onSale) {
		this.onSale = onSale;
	}

	public String getThumbnailUrl() {
		return thumbnailUrl;
	}

	public void setThumbnailUrl(String thumbnailUrl) {
		this.thumbnailUrl = thumbnailUrl;
	}

	public long getRealPrice(CartItemDto item) {
		long productPrice = 0;
		
		if (item.getDiscountFrom() != null && item.getDiscountTo() != null) {
			long now = System.currentTimeMillis();
			
			if (item.getDiscountFrom().getTime() <= now && now <= item.getDiscountTo().getTime()) {
				productPrice = item.getDiscountPrice();
			} else {
				productPrice = item.getPrice();
			}
			
		} else {
			productPrice = item.getPrice();
		}
		return productPrice;
	}
}
