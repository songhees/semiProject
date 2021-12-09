package semi.dao;

import static util.ConnectionUtil.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import semi.vo.OrderItem;

public class OrderItemDao {
	private static OrderItemDao self = new OrderItemDao();
	private OrderItemDao() {}
	public static OrderItemDao getinstance() {
		return self;
	}
	
	public void insertOrderItem(OrderItem orderItem) throws SQLException {
		String sql = "INSERT INTO SEMI_ORDER_ITEM (ORDER_NO, PRODUCT_ITEM_NO, ORDER_PRODUCT_PRICE, \r\n"
				+ "            ORDER_PRODUCT_QUANTITY) \r\n"
				+ "VALUES (?, ?, ?, ?)";

		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, orderItem.getOrder().getNo());
		pstmt.setInt(2, orderItem.getProductItem().getNo());
		pstmt.setLong(3, orderItem.getOrderProductPrice());
		pstmt.setInt(4, orderItem.getOrderProductQuantity());

		pstmt.executeUpdate();

		pstmt.close();
		connection.close();
	}
}
