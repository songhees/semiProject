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
			sql += "								(order by p.product_price desc) rn, ";
				} else if ("favor".equals(criteria.getOrderBy())) {
			sql += "								(order by p.product_total_sale_count desc) rn, ";
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
				if ("product_name".equals(criteria.getSearchType())) {
			sql	+= "and p.product_name like '%' || ? || '%' ";
				} else if ("product_code".equals(criteria.getSearchType())) {
			sql	+= "and p.product_no = ? ";
				} 
			sql	+= "		and s.product_no=p.product_no"
				+ "			and r.product_no(+)=p.product_no) a "
				+ "where rn >= ? and rn <= ? " ;
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		int i = 0;
		pstmt.setLong(++i, criteria.getFromPrice());

		if (criteria.getToPrice() != 0) {
			pstmt.setLong(++i, criteria.getToPrice());
		}

		if (criteria.getCategoryNo() != 0) {
			pstmt.setInt(++i, criteria.getCategoryNo());
		} 
		
		if (criteria.getSearchType() != null) {
			pstmt.setString(++i, criteria.getKeyword());
		}
		
		pstmt.setInt(++i, criteria.getBegin());
		pstmt.setInt(++i, criteria.getEnd());
		
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
			if (rs.getString("colors") != null) {
				List<String> colors = Arrays.asList(rs.getString("colors").split(", "));
				product.setColors(colors);
			}
			products.add(product);
		}
		rs.close();
		pstmt.close();
		connection.close();
		return products;
	}
	
	
	public int getRecordSearchProduct(ProductCriteria criteria) throws SQLException {
		int totalRecord = 0;
		String sql = "select count(*) cnt "
				+ "from semi_product p "
				+ "where p.product_on_sale = 'Y' ";
		if ("product_name".equals(criteria.getSearchType())) {
			sql	+= "and p.product_name like '%' || ? || '%' ";
		} else if ("product_code".equals(criteria.getSearchType())) {
			sql	+= "and p.product_no = ? ";
		} 
			sql += "and p.product_price >= ? ";
		if (criteria.getToPrice() != 0 ) {
			sql += "and p.product_price <= ? ";
		}
		if (criteria.getCategoryNo()!=0) {
			sql	+= "and p.category_no = ? ";
		}
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		int i = 0;
		if (criteria.getSearchType() != null) {
			pstmt.setString(++i, criteria.getKeyword());
			System.out.println("1: " + i);
		}
		
		pstmt.setLong(++i, criteria.getFromPrice());
		System.out.println("2: " + i);
		
		if (criteria.getToPrice() != 0) {
			pstmt.setLong(++i, criteria.getToPrice());
			System.out.println("3: " + i);
			
		}
		if (criteria.getCategoryNo() != 0) {
			pstmt.setInt(++i, criteria.getCategoryNo());
			System.out.println("4: " + i);
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
