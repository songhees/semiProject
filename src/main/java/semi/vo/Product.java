package semi.vo;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

public class Product {

	private int no;
	private ProductCategory productCategory;
	private String name;
	private long price;
	private long discountPrice;
	private Date discountFrom;
	private Date discountTo;
	private Date createdDate;
	private Date updatedDate;
	private String onSale;
	private String detail;
	private int totalSaleCount;
	private int totalStock;
	private String thumbnailUrl;
	private int reviewCount;
	private double averageReviewRate;
	// 제품의 색을 담는 리스트
	private List<String> colors;
	// 신상품의 할인율
	private final double newProductDiscountRate = 0.05;
	
	public Product() {}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public ProductCategory getProductCategory() {
		return productCategory;
	}

	public void setProductCategory(ProductCategory productCategory) {
		this.productCategory = productCategory;
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

	public int getTotalSaleCount() {
		return totalSaleCount;
	}

	public void setTotalSaleCount(int totalSaleCount) {
		this.totalSaleCount = totalSaleCount;
	}

	public int getTotalStock() {
		return totalStock;
	}

	public void setTotalStock(int totalStock) {
		this.totalStock = totalStock;
	}
	
	public String getThumbnailUrl() {
		return thumbnailUrl;
	}

	public void setThumbnailUrl(String thumbnailUrl) {
		this.thumbnailUrl = thumbnailUrl;
	}
	
	public int getReviewCount() {
		return reviewCount;
	}

	public void setReviewCount(int reviewCount) {
		this.reviewCount = reviewCount;
	}

	public double getAverageReviewRate() {
		return averageReviewRate;
	}

	public void setAverageReviewRate(double averageReviewRate) {
		this.averageReviewRate = averageReviewRate;
	}

	public List<String> getColors() {
		return colors;
	}
	
	public void setColors(List<String> colors) {
		this.colors = colors;
	}

	@Override
	public String toString() {
		return "Product [no=" + no + ", productCategory=" + productCategory + ", name=" + name + ", price=" + price
				+ ", discountPrice=" + discountPrice + ", discountFrom=" + discountFrom + ", discountTo=" + discountTo
				+ ", createdDate=" + createdDate + ", updatedDate=" + updatedDate + ", onSale=" + onSale + ", detail="
				+ detail + ", totalSaleCount=" + totalSaleCount + ", totalStock=" + totalStock + ", averageReviewRate="
				+ averageReviewRate + ", colors=" + colors + "]";
	}

	/**
	 * 할인기간이 하루일 때의 남은 시간을 구한다.
	 * createdDate(상품이 DB에 입력된 시간)가 현재 시간 이후일 경우 null을 반환한다.
	 * 할인기간이 끝났을 경우 null을 반환한다.
	 * @param millisecond 경과된 millisecond
	 * @return 남은 시간을 "5일 12:05:30"와 같은 String으로 반환된다.
	 */
	public String getRemainTimeInOneDay() throws ParseException {
//		long oneDayMillisecond = 24*60*60*1000;
		// TODO 테스트용 기간
		long oneDayMillisecond = 3*24*60*60*1000 + 20*60*60*1000;
		
		Date currentDate = new Date();
		
		long elapsedMillisecond = currentDate.getTime() - this.createdDate.getTime();
		if (elapsedMillisecond < 0 || elapsedMillisecond > oneDayMillisecond) {
			return null;
		}

		long remainTime = oneDayMillisecond - elapsedMillisecond;
		
		long day = remainTime/(1000*60*60*24);
		long hour = remainTime%(1000*60*60*24)/(1000*60*60);
		long minute = remainTime%(1000*60*60)/(1000*60);
		long second = remainTime%(1000*60)/(1000);
		
		String result = day + "일 "
						+ String.format("%02d", hour) + ":"
						+ String.format("%02d", minute) + ":"
						+ String.format("%02d", second);
		
		return result;
	}
	
	/**
	 * 할인기간의 할인금액을 계산한다.
	 * 할인금액은 일의 자리에서 올림한다.
	 * @return 할인금액
	 */
	public long getDiscountAmount() {
		long result = 0;
		
		double discountDouble = this.price*this.newProductDiscountRate;
		result = (long)(Math.ceil(discountDouble/10)*10);
		
		return result;
	}
}
