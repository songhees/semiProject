package semi.vo;

import java.util.Date;
import java.util.List;

public class Order {
	private int no;
	private User user;
	private int totalPrice;
	private int depositPoint;
	private String status;
	private Date createdDate;
	private Address address;
	private List<OrderItem> items;
	
	public Order() {}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public int getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(int totalPrice) {
		this.totalPrice = totalPrice;
	}

	public int getDepositPoint() {
		return depositPoint;
	}

	public void setDepositPoint(int depositPoint) {
		this.depositPoint = depositPoint;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	public List<OrderItem> getItems() {
		return items;
	}

	public void setItems(List<OrderItem> items) {
		this.items = items;
	}

}
