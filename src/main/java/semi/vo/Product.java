package semi.vo;

import java.util.Date;

public class Product {

	private int no;
	private int categoryNo;
	private String name;
	private int price;
	private int discountPrice;
	private Date discountFromDate;
	private Date discountToDate;
	private Date createdDate;
	private Date updatedDate;
	private String onSale;
	private String detail;
	private String thumbnailUrl;
	
	public Product() {}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public int getCategoryNo() {
		return categoryNo;
	}

	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getDiscountPrice() {
		return discountPrice;
	}

	public void setDiscountPrice(int discountPrice) {
		this.discountPrice = discountPrice;
	}

	public Date getDiscountFromDate() {
		return discountFromDate;
	}

	public void setDiscountFromDate(Date discountFromDate) {
		this.discountFromDate = discountFromDate;
	}

	public Date getDiscountToDate() {
		return discountToDate;
	}

	public void setDiscountToDate(Date discountToDate) {
		this.discountToDate = discountToDate;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public Date getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(Date updatedDate) {
		this.updatedDate = updatedDate;
	}

	public String getOnSale() {
		return onSale;
	}

	public void setOnSale(String onSale) {
		this.onSale = onSale;
	}

	public String getDetail() {
		return detail;
	}

	public void setDetail(String detail) {
		this.detail = detail;
	}

	public String getThumbnailUrl() {
		return thumbnailUrl;
	}

	public void setThumbnailUrl(String thumbnailUrl) {
		this.thumbnailUrl = thumbnailUrl;
	}
	
}
