package semi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import static util.ConnectionUtil.getConnection;
import semi.criteria.ProductCriteria;
import semi.vo.Product;

public class ProductDao {
	
	private static ProductDao self = new ProductDao();
	private ProductDao() {}
	public static ProductDao getInstance() {
		return self;
	}
	
	public List<Product> getProductBySearch(ProductCriteria criteria) throws SQLException {
		List<Product> products = new ArrayList<Product>();
		String sql ="select  product_no, product_name, product_price, product_discount_price, product_discount_from, "
				+ "        product_discount_to, product_created_date, product_total_stock, "
				+ "        category_no, regexp_replace((select listagg(product_color, ', ') within group(order by product_item_no) "
				+ "                            from semi_product_item i "
				+ "                            where i.product_no = a.product_no "
				+ "                            group by product_no), '([^,]+)(,\\1)+', '\\1') colors, cnt, "
				+ "        thumbnail_image_url "
				+ "from (select row_number() over ";
				if (criteria.getOrderBy().isBlank()) {
			sql += "								(order by p.product_no) rn, ";
				} else if ("recent".equals(criteria.getOrderBy())) {
			sql += "								(order by p.product_created_date) rn, ";
				} else if ("priceasc".equals(criteria.getOrderBy())) {
			sql += "								(order by p.product_price asc) rn, ";
				} else if ("pricedesc".equals(criteria.getOrderBy())) {
			sql += "								(order by p.product_price) rn, ";
				} else if ("favor".equals(criteria.getOrderBy())) {
			sql += "								(order by p.product_total_sale_count) rn, ";
				} else if ("review".equals(criteria.getOrderBy())) {
			sql += "								(order by r.cnt desc nulls last) rn, ";
				}
			sql	+= "		p.product_no, p.product_name, p.product_price, p.product_discount_price, p.product_discount_from, "
				+ "         p.product_discount_to, p.product_created_date, p.product_total_stock, "
				+ "         p.category_no, "
				+ "			s.thumbnail_image_url, r.cnt "
				+ "			from semi_product p, semi_product_thumbnail_image s, (select product_no, count(*) cnt "
				+ "                                                                from semi_product_review "
				+ "                                                                group by product_no) r "
				+ "			where s.thumbnail_image_url=p.product_no || '_1.jpg' "
				+ "			and p.product_on_sale = 'Y' "
				+ "			and p.product_price >= ? ";
				if (criteria.getToPrice() != 0) {
			sql += "		and p.product_price <= ? ";
				}
				if (criteria.getCategoryNo()!=0) {
			sql	+= "		and p.category_no = ? ";
				}
				if (!criteria.getKeyword().isBlank()) {
			sql	+= "		and p.product_name like '%' || ? || '%' ";
				}
			sql	+= "		and s.product_no=p.product_no"
				+ "			and r.product_no(+)=p.product_no) a "
				+ "where rn >= ? and rn <= ? " ;
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setLong(1, criteria.getFromPrice());
		if (criteria.getToPrice() != 0 && criteria.getCategoryNo() != 0 && !criteria.getKeyword().isBlank()) {
			pstmt.setLong(2, criteria.getToPrice());
			pstmt.setInt(3, criteria.getCategoryNo());
			pstmt.setString(4, criteria.getKeyword());
			pstmt.setInt(5, criteria.getBegin());
			pstmt.setInt(6, criteria.getEnd());

		} else if (criteria.getCategoryNo() != 0 && criteria.getToPrice() != 0) {
			pstmt.setLong(2, criteria.getToPrice());
			pstmt.setInt(3, criteria.getCategoryNo());
			pstmt.setInt(4, criteria.getBegin());
			pstmt.setInt(5, criteria.getEnd());
		
		} else if (criteria.getCategoryNo() != 0 && !criteria.getKeyword().isBlank()) {
			pstmt.setInt(2, criteria.getCategoryNo());
			pstmt.setString(3, criteria.getKeyword());
			pstmt.setInt(4, criteria.getBegin());
			pstmt.setInt(5, criteria.getEnd());
		
		} else if (criteria.getToPrice() != 0 && !criteria.getKeyword().isBlank()) {
			pstmt.setLong(2, criteria.getToPrice());
			pstmt.setString(3, criteria.getKeyword());
			pstmt.setInt(4, criteria.getBegin());
			pstmt.setInt(5, criteria.getEnd());
			
		} else if (!criteria.getKeyword().isBlank()) {
			pstmt.setInt(2, criteria.getCategoryNo());
			pstmt.setInt(3, criteria.getBegin());
			pstmt.setInt(4, criteria.getEnd());
		
		} else if (criteria.getToPrice() != 0) {
			pstmt.setLong(2, criteria.getToPrice());
			pstmt.setInt(3, criteria.getBegin());
			pstmt.setInt(4, criteria.getEnd());
			
		} else if (criteria.getCategoryNo() != 0) {
			pstmt.setInt(2, criteria.getCategoryNo());
			pstmt.setInt(3, criteria.getBegin());
			pstmt.setInt(4, criteria.getEnd());
			
		} else {
			pstmt.setInt(2, criteria.getBegin());
			pstmt.setInt(3, criteria.getEnd());
		}
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()) {
			Product product = new Product();
			product.setNo(rs.getInt("product_no"));
			product.setName(rs.getString("product_name"));
			product.setPrice(rs.getLong("product_price"));
			product.setDiscountPrice(rs.getLong("product_discount_price"));
			product.setDiscountFrom(rs.getDate("product_discount_from"));
			product.setDiscountTo(rs.getDate("product_discount_to"));
			product.setCreatedDate(rs.getDate("product_created_date"));
			product.setTotalStock(rs.getInt("product_total_stock"));
			product.setThumbnailUrl(rs.getString("thumbnail_image_url"));
			product.setReviewCount(rs.getInt("cnt"));
			List<String> colors = Arrays.asList(rs.getString("colors").split(", "));
			product.setColors(colors);
			
			products.add(product);
		}
		rs.close();
		pstmt.close();
		connection.close();
		return products;
	}
	
	
	public int getRecordSearchProduct(ProductCriteria criteria) throws SQLException {
		int totalRecord = 0;
		String sql = "select count(*) cnt,"
				+ "from semi_product p "
				+ "where p.product_price >= ? ";
		if (criteria.getToPrice() != 0) {
			sql += "and p.product_price <= ? ";
		}
		if (criteria.getCategoryNo()!=0) {
			sql	+= "and p.category_no = ? ";
		}
		if (!criteria.getKeyword().isBlank()) {
			sql	+= "and p.product_name like '%' || ? || '%' ";
		}
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		if (criteria.getToPrice() != 0 && criteria.getCategoryNo() != 0 && !criteria.getKeyword().isBlank()) {
			pstmt.setLong(1, criteria.getFromPrice());
			pstmt.setLong(2, criteria.getToPrice());
			pstmt.setInt(3, criteria.getCategoryNo());
			pstmt.setString(4, criteria.getKeyword());
		
		} else if (criteria.getCategoryNo() != 0 && !criteria.getKeyword().isBlank()) {
			pstmt.setLong(1, criteria.getFromPrice());
			pstmt.setInt(2, criteria.getCategoryNo());
			pstmt.setString(3, criteria.getKeyword());
		
		} else if (criteria.getToPrice() != 0 && !criteria.getKeyword().isBlank()) {
			pstmt.setLong(1, criteria.getFromPrice());
			pstmt.setLong(2, criteria.getToPrice());
			pstmt.setString(3, criteria.getKeyword());
			
		} else if (criteria.getCategoryNo() != 0 && criteria.getToPrice() != 0) {
			pstmt.setLong(1, criteria.getFromPrice());
			pstmt.setLong(2, criteria.getToPrice());
			pstmt.setInt(3, criteria.getCategoryNo());
		
		} else if (!criteria.getKeyword().isBlank()) {
			pstmt.setLong(1, criteria.getFromPrice());
			pstmt.setInt(2, criteria.getCategoryNo());
		
		} else if (criteria.getToPrice() != 0) {
			pstmt.setLong(1, criteria.getFromPrice());
			pstmt.setLong(2, criteria.getToPrice());
			
		} else if (criteria.getCategoryNo() != 0) {
			pstmt.setLong(1, criteria.getFromPrice());
			pstmt.setInt(2, criteria.getCategoryNo());
		} else {
			pstmt.setLong(1, criteria.getFromPrice());
		}
		
		ResultSet rs = pstmt.executeQuery();
		
		rs.next();
		totalRecord = rs.getInt("cnt");
		
		rs.close();
		pstmt.close();
		connection.close();
		return totalRecord;
	}
}
