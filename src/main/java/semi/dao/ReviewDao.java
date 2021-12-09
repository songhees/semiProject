package semi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import semi.dto.ReviewDto;
import semi.vo.Review;

import static util.ConnectionUtil.getConnection;

public class ReviewDao {
	
	private static ReviewDao self = new ReviewDao();
	private ReviewDao() {}
	public static ReviewDao getInstance() {
		return self;
	}
	
	public int getTotalRecordsByProductNo(int no) throws SQLException {
		String sql = "select count(*) cnt "
				   + "from semi_product_review "
				   + "where product_no = ? ";
		
		int totalRecords = 0;
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		totalRecords = rs.getInt("cnt");
		rs.close();
		pstmt.close();
		connection.close();
		
		return totalRecords;
	}
	
	public List<Review> getReviewList(int no, int begin, int end, String reviewOrderBy) throws SQLException {
		String sql = "";
		if (reviewOrderBy == "최신순") {
			sql = "select review_no, user_no, review_rate, review_content, review_created_date "
			    + "from (select row_number() over (order by review_no desc) rn, "
			    + "      review_no, user_no, review_rate, review_content, review_created_date "
			    + "      from semi_product_review"
			    + "      where product_no = ? "
			    + "      and review_deleted = 'N') "
			    + "where rn >= ? and rn <= ? "
			    + "order by rn ";
		} else {
			sql = "select review_no, user_no, review_rate, review_content, review_created_date "
			    + "from (select row_number() over (order by review_rate desc) rn, "
			    + "      review_no, user_no, review_rate, review_content, review_created_date "
			    + "      from semi_product_review"
			    + "      where product_no = ? "
			    + "      and review_deleted = 'N') "
			    + "where rn >= ? and rn <= ? "
			    + "order by rn ";
		}
		
		List<Review> reviewList = new ArrayList<>();

		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, no);
		pstmt.setInt(2, begin);
		pstmt.setInt(3, end);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			Review review = new Review();
			review.setNo(rs.getInt("review_no"));
			review.setUserNo(rs.getInt("user_no"));
			review.setRate(rs.getInt("review_rate"));
			review.setContent(rs.getString("review_content"));
			review.setCreatedDate(rs.getDate("review_created_date"));
			reviewList.add(review);
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return reviewList;
	}
	
	public List<String> getReviewImageNameListByReviewNo(int reviewNo) throws SQLException {
		String sql = "select review_image_name "
				   + "from semi_review_image "
				   + "where review_no = ? ";
		
		List<String> reviewImageNameList = new ArrayList<>();
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, reviewNo);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			reviewImageNameList.add(rs.getString("review_image_name"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return reviewImageNameList;
	}
	
	public int getReviewNo() throws SQLException {
		String sql = "select review_seq.nextval seq from dual";
		
		int reviewNo = 0;
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		reviewNo = rs.getInt("seq");
		rs.close();
		pstmt.close();
		connection.close();
		
		return reviewNo;
	}
	
	public void insertProductReview(Review review) throws SQLException {
		String sql = "insert into semi_product_review "
				   + "(review_no, user_no, product_no, review_content, review_rate) "
				   + "values (?, ?, ?, ?, ?) ";
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, review.getNo());
		pstmt.setInt(2, review.getUserNo());
		pstmt.setInt(3, review.getProductNo());
		pstmt.setString(4, review.getContent());
		pstmt.setInt(5, review.getRate());
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
	public void insertReviewImage(Review review) throws SQLException {
		String sql = "insert into semi_review_image "
				   + "(review_no, review_image_name) "
				   + "values (?, ?) ";
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, review.getNo());
		pstmt.setString(2, review.getFilename());
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}

	
	/**
	 * 유저 번호에 해당하는 모든 리뷰 목록 조회
	 * @param no 유저 번호
	 * @param begin 
	 * @param end
	 * @return
	 * @throws SQLException
	 */
	public List<ReviewDto> getReviewListByUserNo(int no, int begin, int end) throws SQLException {
		String	sql = "select review_no, product_no, review_rate, review_content, review_created_date, product_name, thumbnail_image_url "
			    + "from (select row_number() over (order by review_no desc) rn, "
			    + "      r.review_no, r.product_no, r.review_rate, r.review_content, r.review_created_date, "
			    + "		 p.product_name, s.thumbnail_image_url "
			    + "      from semi_product_review r, semi_product p, semi_product_thumbnail_image s "
			    + "      where user_no = ? "
			    + "      and review_deleted = 'N' "
			    + "		 and s.thumbnail_image_url=p.product_no || '_1.jpg' "
			    + "		 and r.product_no = p.product_no "
			    + "		 and s.product_no = p.product_no) "
			    + "where rn >= ? and rn <= ? "
			    + "order by rn ";
		
		List<ReviewDto> reviewList = new ArrayList<>();

		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, no);
		pstmt.setInt(2, begin);
		pstmt.setInt(3, end);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()) {
			ReviewDto review = new ReviewDto();
			review.setNo(rs.getInt("review_no"));
			review.setProductNo(rs.getInt("product_no"));
			review.setProductName(rs.getString("product_name"));
			review.setRate(rs.getInt("review_rate"));
			review.setContent(rs.getString("review_content"));
			review.setCreatedDate(rs.getDate("review_created_date"));
			review.setThumbnailUrl(rs.getString("thumbnail_image_url"));
			reviewList.add(review);
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return reviewList;
	}
	
	public int getTotalRecordsByUserNo(int no) throws SQLException {
		String sql = "select count(*) cnt "
				   + "from semi_product_review "
				   + "where user_no = ? ";
		
		int totalRecords = 0;
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		totalRecords = rs.getInt("cnt");
		rs.close();
		pstmt.close();
		connection.close();
		
		return totalRecords;
	}
	
	/**
	 * 회원 번호와 리뷰 번호에 해당하는 리뷰를 삭제
	 * @param userNo 회원 번호
	 * @param reviewNo 리뷰 번호
	 * @throws SQLException
	 */
	public void deleteReview(int userNo, int reviewNo) throws SQLException {
		String sql = "update semi_product_review "
				   + "set "
				   + "	review_deleted = 'y', "
				   + "	review_deleted_date = sysdate "
				   + "where user_no = ? "
				   + "and review_no = ? ";
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		pstmt.setInt(2, reviewNo);
		
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
}
