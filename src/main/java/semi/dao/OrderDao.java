package semi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static util.ConnectionUtil.*;

import semi.criteria.OrderItemCriteria;
import semi.dto.OrderItemDto;
import semi.vo.Order;

/**
 * 주문 정보를 관리하는 클래스
 * @author song
 *
 */
public class OrderDao {
	private static OrderDao self = new OrderDao();
	private OrderDao() {}
	public static OrderDao getinstance() {
		return self;
	}
	
	/**
	 * 지정된 검색에대한 주문 목록
	 * @param criteria 검색
	 * @return	주문 목록
	 * @throws SQLException 
	 */
	public List<OrderItemDto> getOrderItemListByUserNo(OrderItemCriteria criteria) throws SQLException {
		List<OrderItemDto> orderItemList = new ArrayList<>();
		String sql = "select order_no, total_price, order_status, order_created, "
				+ "		order_product_price, order_product_quantity, "
				+ "		product_item_no, product_color, product_size, "
				+ "		product_no, product_name, "
				+ "		thumbnail_image_url "
				+ "from (select row_number() over (order by o.order_no desc, t.product_item_no asc) rn, "
				+ "			o.order_no, o.total_price, o.order_status, o.order_created, "
				+ "			i.order_product_price, i.order_product_quantity, "
				+ "			t.product_item_no, t.product_color, t.product_size, "
				+ "			p.product_no, p.product_name, "
				+ "			s.thumbnail_image_url "
				+ "			from semi_order o, semi_order_item i, semi_product_item t, semi_product p, semi_product_thumbnail_image s "
				+ "			where o.user_no = ? ";
		if ("change".equals(criteria.getStatus())) {
			sql += "			and o.order_status in ('취소', '반품', '교환') ";
		} else if ("return".equals(criteria.getStatus())) {
			sql += "			and o.order_status = '반품' ";
		} else if ("exchange".equals(criteria.getStatus())) {
			sql += "			and o.order_status = '교환' ";
		} else if ("cancel".equals(criteria.getStatus())) {
			sql += "			and o.order_status = '취소' ";
		} else {
			sql += "			and o.order_status = '주문완료' ";
		}
		    sql += "         and o.order_created >= ? and o.order_created < ? "
		    	+ "			and s.thumbnail_image_url=p.product_no || '_1.jpg' "
				+ "			and o.order_no=i.order_no "
				+ "			and i.product_item_no=t.product_item_no "
				+ "			and p.product_no=t.product_no "
				+ "			and s.product_no=p.product_no) "
				+ "where rn >= ? and rn <= ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, criteria.getUserNo());
		pstmt.setString(2, criteria.getBeginDate());
		pstmt.setString(3, criteria.getEndDate());
		pstmt.setInt(4, criteria.getBegin());
		pstmt.setInt(5, criteria.getEnd());
		
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			OrderItemDto item = new OrderItemDto();
			
			item.setOrderNo(rs.getInt("order_no"));
			item.setTotalPrice(rs.getLong("total_price"));
			item.setStatus(rs.getString("order_status"));
			item.setOrderCreatedDate(rs.getDate("order_created"));
			
			item.setOrderProductPrice(rs.getLong("order_product_price"));
			item.setOrderProductQuantity(rs.getInt("order_product_quantity"));
			
			item.setProductItemNo(rs.getInt("product_item_no"));
			item.setColor(rs.getString("product_color"));
			item.setSize(rs.getString("product_size"));
			
			item.setProductNo(rs.getInt("product_no"));
			item.setProductName(rs.getString("product_name"));
			item.setThumbnailUrl(rs.getString("thumbnail_image_url"));
			orderItemList.add(item);
		}
		rs.close();
		pstmt.close();
		connection.close();
		return orderItemList;
	}
	
	
	/**
	 * 주문상태 날짜 유저번호에 대한 주문 검색건수 조회
	 * @param criteria 주문상태 날짜 유저번호
	 * @return 주문 검색건수
	 * @throws SQLException
	 */
	public int getTotalRecords(OrderItemCriteria criteria) throws SQLException {
		int totalRecords = 0;
		String sql = "select count(*) cnt "
				+ "from semi_order o, semi_order_item i "
				+ "where o.user_no = ? ";
		if ("change".equals(criteria.getStatus())) {
			sql += "and o.order_status in ('취소', '반품', '교환') ";
		} else {
			sql += "and o.order_status = '주문완료' ";
		}
		    sql += "and o.order_created >= ? and o.order_created < ? "
				+ "and o.order_no=i.order_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, criteria.getUserNo());
		pstmt.setString(2, criteria.getBeginDate());
		pstmt.setString(3, criteria.getEndDate());
		
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		totalRecords = rs.getInt("cnt");
		
		rs.close();
		pstmt.close();
		connection.close();
		return totalRecords;
	}
	
	/**
	 * 지정된 주문번호에 해당하는 상품상세정보 목록 조회
	 * @param orderNo 주문번호
	 * @return 상품상세정보 목록
	 * @throws SQLException
	 */
	public List<OrderItemDto> getOrderItemDetail(int orderNo) throws SQLException {
		List<OrderItemDto> itemsInfo = new ArrayList<>();
		String sql = "select i.order_no, "
				+ "     i.order_product_price, i.order_product_quantity, "
				+ "		t.product_item_no, t.product_color, t.product_size, "
				+ "		p.product_no, p.product_name, p.product_price, "
				+ "		s.thumbnail_image_url "
				+ "from semi_order_item i, semi_product_item t, semi_product p, semi_product_thumbnail_image s "
				+ "where i.order_no = ? "
				+ "and s.thumbnail_image_url = p.product_no || '_1.jpg' "
				+ "and i.product_item_no = t.product_item_no "
				+ "and p.product_no = t.product_no "
				+ "and s.product_no = p.product_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, orderNo);
		
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next()) {
			OrderItemDto item = new OrderItemDto();
			item.setOrderNo(rs.getInt("order_no"));
			item.setOrderProductPrice(rs.getLong("order_product_price"));
			item.setOrderProductQuantity(rs.getInt("order_product_quantity"));
			item.setProductItemNo(rs.getInt("product_item_no"));
			item.setColor(rs.getString("product_color"));
			item.setSize(rs.getString("product_size"));
			item.setProductNo(rs.getInt("product_no"));
			item.setProductName(rs.getString("product_name"));
			item.setThumbnailUrl(rs.getString("thumbnail_image_url"));
			item.setProductPrice(rs.getLong("product_price"));
			itemsInfo.add(item);
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return itemsInfo;
	}
	
	/**
	 * 유저 번호와 주문 번호에 해당하는 주문정보 조회
	 * @param userNo 유저 번호
	 * @param orderNo 주문 번호
	 * @return 주문정보
	 * @throws SQLException
	 */
	public Map<String, Object> getOrderInfo(int userNo, int orderNo) throws SQLException {
		Map<String, Object> orderDetail = null;
		String sql = "select u.user_name, u.user_tel, "
				+ "o.order_no, o.total_price, o.order_status, o.order_created, o.payment_method, "
				+ "o.order_postal_code, o.address_detail, o.base_address, o.use_point "
				+ "from semi_user u, semi_order o "
				+ "where u.user_no = ? "
				+ "and o.order_no = ? "
				+ "and u.user_no=o.user_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		pstmt.setInt(2, orderNo);
		
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			orderDetail = new HashMap<>();
			orderDetail.put("userName", rs.getString("user_name"));
			orderDetail.put("userTel", rs.getString("user_tel"));
			orderDetail.put("orderNo", rs.getInt("order_no"));
			orderDetail.put("totalPrice", rs.getLong("total_price"));
			orderDetail.put("status", rs.getString("order_status"));
			orderDetail.put("createdDate", rs.getDate("order_created"));
			orderDetail.put("paymentMethod", rs.getString("payment_method"));
			orderDetail.put("postalCode", rs.getString("order_postal_code"));
			orderDetail.put("addressDetail", rs.getString("address_detail"));
			orderDetail.put("baseAddress", rs.getString("base_address"));
			orderDetail.put("usePoint", rs.getInt("use_point"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return orderDetail;
	}
	
	/**
	 * 유저번호에 해당하는 주문 총 금액과, 주문 수
	 * @param userNo
	 * @return
	 * @throws SQLException
	 */
	public int[] getTotalAmount(int userNo) throws SQLException {
		int[] totalAmount = new int[2];
		String sql = "select sum(total_price) sum, count(*) cnt "
				+ "from semi_order "
				+ "where user_no = ? "
				+ "and order_status = '주문완료' ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			totalAmount[0] = rs.getInt("sum");
			totalAmount[1] = rs.getInt("cnt");
		}
		
		rs.close();
		pstmt.close();
		connection.close();
		
		return totalAmount;
	}
	
	/**
	 * 유저번호와 주문상태에 해당하는 주문상품 개수 조회
	 * @param userNo 유저 번호
	 * @param status 주문 상태
	 * @return 주문 개수
	 * @throws SQLException
	 */
	public int getOrderItemAmount(int userNo, String status) throws SQLException {
		int amount = 0;
		String sql = "select sum(i.order_product_quantity) sum "
				+ "from semi_order o, semi_order_item i "
				+ "where user_no = ? "
				+ "and order_status = ? "
				+ "and o.order_no = i.order_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		pstmt.setString(2, status);
		ResultSet rs = pstmt.executeQuery();
		
		rs.next();
		amount = rs.getInt("sum");
		
		rs.close();
		pstmt.close();
		connection.close();
		
		return amount;
	}
	
	public void insertOrder(Order order) throws SQLException {
		String sql = "INSERT INTO SEMI_ORDER (ORDER_NO, USER_NO, TOTAL_PRICE, DEPOSIT_POINT, ORDER_STATUS, \r\n"
				+ "            ORDER_ADDRESS_NAME, ADDRESS_DETAIL, PAYMENT_METHOD, ORDER_POSTAL_CODE, \r\n"
				+ "            BASE_ADDRESS, USE_POINT) \r\n"
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, order.getNo());
		pstmt.setInt(2, order.getUser().getNo());
		pstmt.setLong(3, order.getTotalPrice());
		pstmt.setInt(4, order.getDepositPoint());
		pstmt.setString(5, order.getStatus());
		pstmt.setString(6, order.getAddress().getAddressName());
		pstmt.setString(7, order.getAddress().getDetail());
		pstmt.setString(8, order.getPaymentMethod());
		pstmt.setString(9, order.getAddress().getPostalCode());
		pstmt.setString(10, order.getAddress().getBaseAddress());
		pstmt.setInt(11, order.getUsePoint());

		pstmt.executeUpdate();

		pstmt.close();
		connection.close();
	}
	
	public int getSequenceNextVal() throws SQLException {
		String sql = "SELECT ORDER_SEQ.NEXTVAL FROM DUAL";
		int result = 0;
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		
		rs.next();
		result = rs.getInt("NEXTVAL");
		
		rs.close();
		pstmt.close();
		connection.close();
		
		return result;
	}
}
