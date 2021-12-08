package semi.dao;

import static util.ConnectionUtil.getConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import semi.criteria.ProductItemCriteria;
import semi.vo.Product;
import semi.vo.ProductCategory;
import semi.vo.ProductItem;

public class ProductItemDao {
	
	private static ProductItemDao self = new ProductItemDao();
	private ProductItemDao() {}
	public static ProductItemDao getInstance() {
		return self;
	}
	
	public List<ProductItem> getProductItemListByProductNo(int productNo) throws SQLException {
		String sql = "SELECT I.PRODUCT_ITEM_NO, I.PRODUCT_NO, I.PRODUCT_SIZE, I.PRODUCT_COLOR, I.PRODUCT_STOCK, \r\n"
				+ "       I.PRODUCT_SALE_COUNT \r\n"
				+ "FROM SEMI_PRODUCT_ITEM I, SEMI_PRODUCT P \r\n"
				+ "WHERE I.PRODUCT_NO = P.PRODUCT_NO \r\n"
				+ "      AND P.PRODUCT_NO = ?;";
		
		List<ProductItem> productItems = new ArrayList<>();
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, productNo);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next()) {
			ProductItem productItem = new ProductItem();
			Product product = new Product();
			
			productItem.setNo(rs.getInt("PRODUCT_ITEM_NO"));
			productItem.setSize(rs.getString("PRODUCT_SIZE"));
			productItem.setColor(rs.getString("PRODUCT_COLOR"));
			productItem.setStock(rs.getInt("PRODUCT_STOCK"));
			productItem.setSaleCount(rs.getInt("PRODUCT_SALE_COUNT"));
			
			product.setNo(rs.getInt("PRODUCT_NO"));
			productItem.setProduct(product);
			
			productItems.add(productItem);
		}
		
		rs.close();
		pstmt.close();
		connection.close();
		
		return productItems;
	}
	
	public ProductItem getProductItemByProductItemNo(int productItemNo) throws SQLException {
		String sql = "SELECT I.PRODUCT_ITEM_NO, I.PRODUCT_SIZE, I.PRODUCT_COLOR, I.PRODUCT_STOCK, I.PRODUCT_SALE_COUNT, \r\n"
				+ "       P.PRODUCT_NO, P.PRODUCT_NAME, P.PRODUCT_PRICE, P.PRODUCT_DISCOUNT_PRICE, \r\n"
				+ "       P.PRODUCT_DISCOUNT_FROM, P.PRODUCT_DISCOUNT_TO, P.PRODUCT_CREATED_DATE, P.PRODUCT_UPDATED_DATE, \r\n"
				+ "       P.PRODUCT_ON_SALE, P.PRODUCT_DETAIL, P.PRODUCT_TOTAL_SALE_COUNT, P.PRODUCT_TOTAL_STOCK, \r\n"
				+ "       P.PRODUCT_AVERAGE_REVIEW_RATE, C.CATEGORY_NO, C.CATEGORY_NAME \r\n"
				+ "FROM SEMI_PRODUCT_ITEM I, SEMI_PRODUCT P, SEMI_PRODUCT_CATEGORY C \r\n"
				+ "WHERE I.PRODUCT_NO = P.PRODUCT_NO AND P.CATEGORY_NO = C.CATEGORY_NO \r\n"
				+ "      AND I.PRODUCT_ITEM_NO = ?";
		
		ProductItem productItem = null;
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, productItemNo);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			productItem = new ProductItem();
			
			productItem.setNo(rs.getInt("PRODUCT_ITEM_NO"));
			productItem.setSize(rs.getString("PRODUCT_SIZE"));
			productItem.setColor(rs.getString("PRODUCT_COLOR"));
			productItem.setStock(rs.getInt("PRODUCT_STOCK"));
			productItem.setSaleCount(rs.getInt("PRODUCT_SALE_COUNT"));
			
			Product product = toProductVo(rs);
			productItem.setProduct(product);
		}
		
		rs.close();
		pstmt.close();
		connection.close();
		
		return productItem;
	}
	
	public ProductItem getProductItemByProductItemCriteria(ProductItemCriteria criteria) throws SQLException {
	      String sql = "SELECT I.PRODUCT_ITEM_NO, I.PRODUCT_SIZE, I.PRODUCT_COLOR, I.PRODUCT_STOCK, I.PRODUCT_SALE_COUNT, \r\n"
	            + "       P.PRODUCT_NO, P.PRODUCT_NAME, P.PRODUCT_PRICE, P.PRODUCT_DISCOUNT_PRICE, \r\n"
	            + "       P.PRODUCT_DISCOUNT_FROM, P.PRODUCT_DISCOUNT_TO, P.PRODUCT_CREATED_DATE, P.PRODUCT_UPDATED_DATE, \r\n"
	            + "       P.PRODUCT_ON_SALE, P.PRODUCT_DETAIL, P.PRODUCT_TOTAL_SALE_COUNT, P.PRODUCT_TOTAL_STOCK, \r\n"
	            + "       P.PRODUCT_AVERAGE_REVIEW_RATE, C.CATEGORY_NO, C.CATEGORY_NAME \r\n"
	            + "FROM SEMI_PRODUCT_ITEM I, SEMI_PRODUCT P, SEMI_PRODUCT_CATEGORY C \r\n"
	            + "WHERE I.PRODUCT_NO = P.PRODUCT_NO AND P.CATEGORY_NO = C.CATEGORY_NO \r\n"
	            + "      AND P.PRODUCT_NO = ? AND I.PRODUCT_SIZE = ? AND I.PRODUCT_COLOR = ?";
	      
	      ProductItem productItem = null;
	      
	      Connection connection = getConnection();
	      PreparedStatement pstmt = connection.prepareStatement(sql);
	      pstmt.setInt(1, criteria.getProductNo());
	      pstmt.setString(2, criteria.getSize());
	      pstmt.setString(3, criteria.getColor());
	      ResultSet rs = pstmt.executeQuery();
	      
	      if (rs.next()) {
	         productItem = new ProductItem();
	         
	         productItem.setNo(rs.getInt("PRODUCT_ITEM_NO"));
	         productItem.setSize(rs.getString("PRODUCT_SIZE"));
	         productItem.setColor(rs.getString("PRODUCT_COLOR"));
	         productItem.setStock(rs.getInt("PRODUCT_STOCK"));
	         productItem.setSaleCount(rs.getInt("PRODUCT_SALE_COUNT"));
	         
	         Product product = toProductVo(rs);
	         productItem.setProduct(product);
	      }
	      
	      rs.close();
	      pstmt.close();
	      connection.close();
	      
	      return productItem;
	}
	
	/**
	 * ResultSet에서 데이터를 꺼내 productVo에 저장해서 반환한다.
	 * @param rs product 정보가 들어있는 ResultSet
	 * @return product 정보가 들어있는 productVo
	 * @throws SQLException
	 */
	private Product toProductVo(ResultSet rs) throws SQLException {
		Product product = new Product();
		ProductCategory productCategory = new ProductCategory();
		
		product.setNo(rs.getInt("PRODUCT_NO"));
		product.setName(rs.getString("PRODUCT_NAME"));
		product.setPrice(rs.getLong("PRODUCT_PRICE"));
		product.setDiscountPrice(rs.getLong("PRODUCT_DISCOUNT_PRICE"));
		product.setDiscountFrom(rs.getDate("PRODUCT_DISCOUNT_FROM"));
		product.setDiscountTo(rs.getDate("PRODUCT_DISCOUNT_TO"));
		product.setCreatedDate(rs.getDate("PRODUCT_CREATED_DATE"));
		product.setUpdatedDate(rs.getDate("PRODUCT_UPDATED_DATE"));
		product.setOnSale(rs.getString("PRODUCT_ON_SALE"));
		product.setDetail(rs.getString("PRODUCT_DETAIL"));
		product.setTotalSaleCount(rs.getInt("PRODUCT_TOTAL_SALE_COUNT"));
		product.setTotalStock(rs.getInt("PRODUCT_TOTAL_STOCK"));
		product.setAverageReviewRate(rs.getDouble("PRODUCT_AVERAGE_REVIEW_RATE"));
		
		productCategory.setNo(rs.getInt("CATEGORY_NO"));
		productCategory.setName(rs.getString("CATEGORY_NAME"));
		
		product.setProductCategory(productCategory);
		
		return product;
	}
}
