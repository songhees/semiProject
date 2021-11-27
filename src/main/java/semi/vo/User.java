package semi.vo;

import java.util.Date;

public class User {

	private int no;
	private String gradeCode;
	private String id;
	private String password;
	private String name;
	private String tel;
	private String email;
	private String emailSubscription;
	private String smsSubscription;
	private int point;
	private String admin;
	private Date deletedDate;
	private Date updatedDate;
	private Date createdDate;
	
	public User () {}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public String getGradeCode() {
		return gradeCode;
	}

	public void setGradeCode(String gradeCode) {
		this.gradeCode = gradeCode;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEmailSubscription() {
		return emailSubscription;
	}

	public void setEmailSubscription(String emailSubscription) {
		this.emailSubscription = emailSubscription;
	}

	public String getSmsSubscription() {
		return smsSubscription;
	}

	public void setSmsSubscription(String smsSubscription) {
		this.smsSubscription = smsSubscription;
	}

	public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}

	public String getAdmin() {
		return admin;
	}

	public void setAdmin(String admin) {
		this.admin = admin;
	}

	public Date getDeletedDate() {
		return deletedDate;
	}

	public void setDeletedDate(Date deletedDate) {
		this.deletedDate = deletedDate;
	}

	public Date getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(Date updatedDate) {
		this.updatedDate = updatedDate;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}
	
}
