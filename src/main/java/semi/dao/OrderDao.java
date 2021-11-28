package semi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import static util.ConnectionUtil.*;
import semi.vo.Order;
import semi.vo.OrderItem;
import semi.vo.Product;
import semi.vo.ProductItem;

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
	 * 지정된 사용자의 주문 목록
	 * @param userId
	 * @return
	 * @throws SQLException
	 */
	public List<OrderItem> getOrderItemListByUserId(String userId, int begin, int end) throws SQLException {
		List<OrderItem> orderItemList = new ArrayList<>();
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
				+ "			where u.user_id = ? "
				+ "			and u.user_no=o.user_no "
				+ "			and o.order_no=i.order_no "
				+ "			and i.product_item_no=t.product_item_no "
				+ "			and p.product_no=t.product_no "
				+ "			and s.product_no=p.product_no) "
				+ "where rn >= ? and rn <= ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, userId);
		pstmt.setInt(2, begin);
		pstmt.setInt(3, end);
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()) {
			Order order = new Order();
			OrderItem item = new OrderItem();
			ProductItem productItem = new ProductItem();
			Product product = new Product();
			
			order.setNo(rs.getInt("order_no"));
			order.setTotalPrice(rs.getInt("total_price"));
			order.setStatus(rs.getString("order_status"));
			order.setCreatedDate(rs.getDate("order_created"));
			
			product.setNo(rs.getInt("product_no"));
			product.setName(rs.getString("product_name"));
			product.setThumbnailUrl(rs.getString("thumbnail_image_url"));
			
			productItem.setNo(rs.getInt("product_item_no"));
			productItem.setColor(rs.getString("product_color"));
			productItem.setSize(rs.getString("product_size"));
			productItem.setProduct(product);
			
			item.setOrder(order);
			item.setOrderProductPrice(rs.getInt("order_product_price"));
			item.setOrderProductQuantity(rs.getInt("order_product_quantity"));
			item.setProductItem(productItem);
			orderItemList.add(item);
		}
		rs.close();
		pstmt.close();
		connection.close();
		return orderItemList;
	}
	
	
	public int getTotalRecords(String userId) throws SQLException {
		int totalRecords = 0;
		String sql = "select count(*) cnt "
				+ "from semi_user u, semi_order o, semi_order_item i "
				+ "where user_id = ? "
				+ "and u.user_no=o.user_no "
				+ "and o.order_no=i.order_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, userId);
		
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		totalRecords = rs.getInt("cnt");
		
		rs.close();
		pstmt.close();
		connection.close();
		return totalRecords;
	}
}
