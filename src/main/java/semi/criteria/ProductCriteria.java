package semi.criteria;

public class ProductCriteria {
	private int begin;
	private int end;
	private int categoryNo;
	private String searchType;
	private String keyword;
	private long fromPrice;
	private long toPrice;
	private String orderBy;
	
	public ProductCriteria() {}
	
	public int getBegin() {
		return begin;
	}
	public void setBegin(int begin) {
		this.begin = begin;
	}
	public int getEnd() {
		return end;
	}
	public void setEnd(int end) {
		this.end = end;
	}
	public int getCategoryNo() {
		return categoryNo;
	}
	public void setCategoryNo(int categoryNo) {
		this.categoryNo = categoryNo;
	}
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
	public long getFromPrice() {
		return fromPrice;
	}

	public void setFromPrice(long fromPrice) {
		this.fromPrice = fromPrice;
	}

	public long getToPrice() {
		return toPrice;
	}

	public void setToPrice(long toPrice) {
		this.toPrice = toPrice;
	}

	public String getOrderBy() {
		return orderBy;
	}
	public void setOrderBy(String orderBy) {
		this.orderBy = orderBy;
	}
	
}
