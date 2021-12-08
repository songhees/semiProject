package semi.criteria;

public class ProductItemCriteria {

	private int begin;				// 현재 페이지번호에 해당하는 데이터 조회 시작 순번
	private int end;				// 현재 페이지번호에 해당하는 데이터 조회 끝 순번
	private int productNo;			// 상품번호
	private String size;			// 사이즈
	private String color;			// 색
	
	public ProductItemCriteria() {}

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

	public int getProductNo() {
		return productNo;
	}

	public void setProductNo(int productNo) {
		this.productNo = productNo;
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

	@Override
	public String toString() {
		return "ProductItemCriteria [begin=" + begin + ", end=" + end + ", productNo=" + productNo + ", size=" + size
				+ ", color=" + color + "]";
	}

	
	
}
