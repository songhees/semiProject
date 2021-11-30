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
	public List<OrderItemDto> getOrderItemListByUserId(OrderItemCriteria criteria) throws SQLException {
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
				+ "			from semi_user u, semi_order o, semi_order_item i, semi_product_item t, semi_product p, semi_product_thumbnail_image s "
				+ "			where u.user_id = ? ";
		if ("cancel".equals(criteria.getStatus())) {
			sql += "			and o.order_status in ('취소', '반품', '교환') ";
		} else {
			sql += "			and o.order_status = '주문완료' ";
		}
		    sql += "         and o.order_created >= ? and o.order_created < ? "
		    	+ "			and s.thumbnail_image_url=p.product_no || '_1.jpg' "
				+ "			and u.user_no=o.user_no "
				+ "			and o.order_no=i.order_no "
				+ "			and i.product_item_no=t.product_item_no "
				+ "			and p.product_no=t.product_no "
				+ "			and s.product_no=p.product_no) "
				+ "where rn >= ? and rn <= ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, criteria.getUserId());
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
	 * 주문상태 날짜 유저아이디에 대한 주문 검색건수 조회
	 * @param criteria 주문상태 날짜 유저아이디
	 * @return 주문 검색건수
	 * @throws SQLException
	 */
	public int getTotalRecords(OrderItemCriteria criteria) throws SQLException {
		int totalRecords = 0;
		String sql = "select count(*) cnt "
				+ "from semi_user u, semi_order o, semi_order_item i "
				+ "where user_id = ? ";
		if ("cancel".equals(criteria.getStatus())) {
			sql += "and o.order_status in ('취소', '반품', '교환') ";
		} else {
			sql += "and o.order_status = '주문완료' ";
		}
		    sql += "and o.order_created >= ? and o.order_created < ? "
		    	+ "and u.user_no=o.user_no "
				+ "and o.order_no=i.order_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, criteria.getUserId());
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
		String sql = "select o.order_no, "
				+ "     i.order_product_price, i.order_product_quantity, "
				+ "		t.product_item_no, t.product_color, t.product_size, "
				+ "		p.product_no, p.product_name, "
				+ "		s.thumbnail_image_url "
				+ "from semi_order o, semi_order_item i, semi_product_item t, semi_product p, semi_product_thumbnail_image s "
				+ "where o.order_no = ? "
				+ "and s.thumbnail_image_url = p.product_no || '_1.jpg' "
				+ "and o.order_no = i.order_no "
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
			itemsInfo.add(item);
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return itemsInfo;
	}
	
	/**
	 * 유저 아이디와 주문 번호에 해당하는 주문정보 조회
	 * @param userId 유저 아이디
	 * @param orderNo 주문 번호
	 * @return 주문정보
	 * @throws SQLException
	 */
	public Map<String, Object> getOrderInfo(String userId, int orderNo) throws SQLException {
		Map<String, Object> orderDetail = new HashMap<>();
		String sql = "select u.user_id, u.user_name, u.user_tel, "
				+ "o.order_no, o.total_price, o.order_status, o.order_created, o.payment_method, "
				+ "o.order_postal_code, o.address_detail "
				+ "from semi_user u, semi_order o "
				+ "where u.user_id = ? "
				+ "and o.order_no = ? "
				+ "and u.user_no=o.user_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, userId);
		pstmt.setInt(2, orderNo);
		
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			orderDetail.put("userid", rs.getString("user_id"));
			orderDetail.put("userName", rs.getString("user_name"));
			orderDetail.put("userTel", rs.getString("user_tel"));
			orderDetail.put("orderNo", rs.getInt("order_no"));
			orderDetail.put("totalPrice", rs.getLong("total_price"));
			orderDetail.put("status", rs.getString("order_status"));
			orderDetail.put("createdDate", rs.getDate("order_created"));
			orderDetail.put("paymentMethod", rs.getString("payment_method"));
			orderDetail.put("postalCode", rs.getString("order_postal_code"));
			orderDetail.put("addressDetail", rs.getString("address_detail"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return orderDetail;
	}
	
}
