package semi.dao;

import static util.ConnectionUtil.getConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import semi.dto.CartItemDto;

public class CartDao {
	
	private static CartDao self = new CartDao();
	private CartDao() {}
	public static CartDao getInstance() {
		return self;
	}
	
	/**
	 * 유저 번호에 해당하는 cart에 담은 상품정보를 조회
	 * @param userNo 유저 번호
	 * @return 상품정보
	 * @throws SQLException
	 */
	public List<CartItemDto> getCartItemList(int userNo) throws SQLException {
		List<CartItemDto> items = new ArrayList<CartItemDto>();
		String sql = "select c.user_no, c.product_item_no, c.cart_product_quantity, "
				+ "        i.product_size, i.product_color, i.product_no, i.product_stock, "
				+ "        p.product_name, p.product_price, p.product_discount_price, "
				+ "		   p.product_discount_from, p.product_discount_to, p.product_on_sale, "
				+ "        t.thumbnail_image_url "
				+ "from semi_cart_item c, semi_product_item i, semi_product p, semi_product_thumbnail_image t "
				+ "where user_no = ? "
				+ "and t.thumbnail_image_url=p.product_no || '_1.jpg' "
				+ "and c.product_item_no = i.product_item_no "
				+ "and i.product_no = p.product_no "
				+ "and p.product_no = t.product_no ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			CartItemDto item = new CartItemDto();
			item.setUserNo(rs.getInt("user_no"));
			item.setQuantity(rs.getInt("cart_product_quantity"));
			item.setProductItemNo(rs.getInt("product_item_no"));
			item.setStock(rs.getInt("product_stock"));
			item.setSize(rs.getString("product_size"));
			item.setColor(rs.getString("product_color"));
			item.setProductNo(rs.getInt("product_no"));
			item.setName(rs.getString("product_name"));
			item.setPrice(rs.getLong("product_price"));
			item.setDiscountPrice(rs.getLong("product_discount_price"));
			item.setDiscountFrom(rs.getDate("product_discount_from"));
			item.setDiscountTo(rs.getDate("product_discount_to"));
			item.setOnSale(rs.getString("product_on_sale"));
			item.setThumbnailUrl(rs.getString("thumbnail_image_url"));
			items.add(item);
		}
		rs.close();
		pstmt.close();
		connection.close();
		return items;
	}
	
	/**
	 *  유저 번호에 해당하는 장바구니에 담긴 상품수량을 변경
	 * @param amount 수량
	 * @param userNo 유저 번호
	 * @throws SQLException
	 */
	public void updateCartItem(CartItemDto item) throws SQLException {
		String sql = "update semi_cart_item "
				+ "set "
				+ "	cart_product_quantity = ? "
				+ "where user_no = ? "
				+ "and product_item_no = ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, item.getQuantity());
		pstmt.setInt(2, item.getUserNo());
		pstmt.setInt(3, item.getProductItemNo());
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
	/**
	 * 장바구니에 들어있는 상품정보 삭제
	 * @param userNo 유저 번호
	 * @param itemNo 상품 번호
	 * @throws SQLException
	 */
	public void deleteCartItem(int userNo, int itemNo) throws SQLException {
		String sql = "delete from semi_cart_item "
				+ "where user_no = ? "
				+ "and product_item_no = ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		pstmt.setInt(2, itemNo);
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
	/**
	 * 장바구니에 상품정보 등록
	 * @param itemDto 유저가 선택한 상품정보
	 * @throws SQLException
	 */
	public void insertCartItem(CartItemDto itemDto) throws SQLException {
		String sql = "insert into semi_cart_item "
				+ "(user_no, product_item_no, cart_product_quantity) "
				+ "values "
				+ "(?, ?, ?) ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, itemDto.getUserNo());
		pstmt.setInt(2, itemDto.getProductItemNo());
		pstmt.setInt(3, itemDto.getQuantity());
		
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
}
