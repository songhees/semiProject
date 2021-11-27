package semi.vo;

public class Address {
	private int addressNo;
	private User user;
	private String orderAddressName;
	private String orderPostalCode;
	private String addressDefault;
	private String addressDetail;
	
	public Address() {}

	public int getAddressNo() {
		return addressNo;
	}

	public void setAddressNo(int addressNo) {
		this.addressNo = addressNo;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getOrderAddressName() {
		return orderAddressName;
	}

	public void setOrderAddressName(String orderAddressName) {
		this.orderAddressName = orderAddressName;
	}

	public String getOrderPostalCode() {
		return orderPostalCode;
	}

	public void setOrderPostalCode(String orderPostalCode) {
		this.orderPostalCode = orderPostalCode;
	}

	public String getAddressDefault() {
		return addressDefault;
	}

	public void setAddressDefault(String addressDefault) {
		this.addressDefault = addressDefault;
	}

	public String getAddressDetail() {
		return addressDetail;
	}

	public void setAddressDetail(String addressDetail) {
		this.addressDetail = addressDetail;
	}
	
}
