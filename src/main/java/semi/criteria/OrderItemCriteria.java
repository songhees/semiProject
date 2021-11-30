package semi.criteria;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class OrderItemCriteria {

	private String userId;
	private String beginDate;
	private String endDate;
	private int begin;
	private int end;
	private String status;
	
	public OrderItemCriteria() {}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	/*
	 * 날짜별 검색 조건
	 */
	public String[] getPeriod(int day) {
		String[] period = new String[2]; 

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		Calendar cal = Calendar.getInstance();
		// 끝 날짜
		cal.add(Calendar.DATE, +1);
		period[1] = dateFormat.format(cal.getTime());
		
		cal.add(Calendar.MONTH, -day);
		cal.add(Calendar.DATE, -1);
		// 시작 날짜
		period[0] = dateFormat.format(cal.getTime());
		
		return period;
	}
}