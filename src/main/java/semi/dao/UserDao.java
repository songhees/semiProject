package semi.dao;

import static util.ConnectionUtil.getConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import semi.vo.User;

public class UserDao {

	// 싱글턴 사용하기
	private UserDao() {}	
	private static UserDao me = new UserDao();
	public static UserDao getInstance() {
		return me;
	}
	
	/**
	 * 지정된 사용자 번호에 해당하는 사용자 정보를 반환한다.
	 * @param no 사용자번호
	 * @return 사용자정보
	 * @throws SQLException
	 */
	public User getUserByNo(int no) throws SQLException {
		String sql = "select * from semi_user where user_no = ? ";
		User user = null;
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			user = new User();
			user.setNo(rs.getInt("user_no"));
			user.setGradeCode(rs.getString("grade_code"));
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setTel(rs.getString("user_tel"));
			user.setEmail(rs.getString("user_email"));
			user.setEmailSubscription(rs.getString("user_email_subscription"));
			user.setSmsSubscription(rs.getString("user_sms_subscription"));
			user.setPoint(rs.getInt("user_point"));
			user.setDeleted(rs.getString("user_deleted"));
			user.setDeletedDate(rs.getDate("user_deleted_date"));
			user.setUpdatedDate(rs.getDate("user_updated_date"));
			user.setCreatedDate(rs.getDate("user_created_date"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return user;
	}
	
	public User getUserByEmail(String email) throws SQLException {
		User user = null;
		String sql = "select * from semi_user where user_email = ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, email);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			user = new User();
			user.setNo(rs.getInt("user_no"));
			user.setGradeCode(rs.getString("grade_code"));
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setTel(rs.getString("user_tel"));
			user.setEmail(rs.getString("user_email"));
			user.setEmailSubscription(rs.getString("user_email_subscription"));
			user.setSmsSubscription(rs.getString("user_sms_subscription"));
			user.setPoint(rs.getInt("user_point"));
			user.setDeleted(rs.getString("user_deleted"));
			user.setDeletedDate(rs.getDate("user_deleted_date"));
			user.setUpdatedDate(rs.getDate("user_updated_date"));
			user.setCreatedDate(rs.getDate("user_created_date"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return user;		
	}
	
	public User getUserByTel(String tel) throws SQLException {
		User user = null;
		String sql = "select * from semi_user where user_tel = ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, tel);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			user = new User();
			user.setNo(rs.getInt("user_no"));
			user.setGradeCode(rs.getString("grade_code"));
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setTel(rs.getString("user_tel"));
			user.setEmail(rs.getString("user_email"));
			user.setEmailSubscription(rs.getString("user_email_subscription"));
			user.setSmsSubscription(rs.getString("user_sms_subscription"));
			user.setPoint(rs.getInt("user_point"));
			user.setDeleted(rs.getString("user_deleted"));
			user.setDeletedDate(rs.getDate("user_deleted_date"));
			user.setUpdatedDate(rs.getDate("user_updated_date"));
			user.setCreatedDate(rs.getDate("user_created_date"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return user;		
	}
	
	/**
	 * 지정된 사용자 아이디에 해당하는 사용자 정보를 반환한다.
	 * @param id 사용자 아이디
	 * @return 사용자정보
	 * @throws SQLException
	 */
	public User getUserById(String id) throws SQLException {
		String sql = "select * from semi_user where user_id = ? ";
		User user = null;
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, id);
		ResultSet rs = pstmt.executeQuery();
		if (rs.next()) {
			user = new User();
			user.setNo(rs.getInt("user_no"));
			user.setGradeCode(rs.getString("grade_code"));
			user.setId(rs.getString("user_id"));
			user.setPassword(rs.getString("user_password"));
			user.setName(rs.getString("user_name"));
			user.setTel(rs.getString("user_tel"));
			user.setEmail(rs.getString("user_email"));
			user.setEmailSubscription(rs.getString("user_email_subscription"));
			user.setSmsSubscription(rs.getString("user_sms_subscription"));
			user.setPoint(rs.getInt("user_point"));
			user.setDeleted(rs.getString("user_deleted"));
			user.setDeletedDate(rs.getDate("user_deleted_date"));
			user.setUpdatedDate(rs.getDate("user_updated_date"));
			user.setCreatedDate(rs.getDate("user_created_date"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		
		return user;
	}
	
	/**
	 * 수정된 정보가 포함된 사용자정보를 테이블에 반영한다.
	 * @param user 사용자정보
	 * @throws SQLException
	 */
	public void updateUser(User user) throws SQLException {
		String sql = "update semi_user "
				   + "set "
				   + "	grade_code = ?, "
				   + "	user_password = ?, "
				   + "	user_name = ?, "
				   + "	user_tel = ?, "
				   + "	user_email = ?, "
				   + "	user_email_subscription = ?, "
				   + "	user_sms_subscription = ?, "
				   + "	user_point = ?, "
				   + "	user_updated_date = sysdate "
				   + "where"
				   + "	user_no = ? ";
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, user.getGradeCode());
		pstmt.setString(2, user.getPassword());
		pstmt.setString(3, user.getName());
		pstmt.setString(4, user.getTel());
		pstmt.setString(5, user.getEmail());
		pstmt.setString(6, user.getEmailSubscription());
		pstmt.setString(7, user.getSmsSubscription());
		pstmt.setInt(8, user.getPoint());
		pstmt.setInt(9, user.getNo());
		
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
	/**
	 * 지정한 사용자번호의 사용자정보를 삭제처리한다.
	 * @param no 사용자번호
	 * @throws SQLException
	 */
	public void deleteUser(int no) throws SQLException {
		String sql = "update semi_user "
				   + "set "
				   + "	user_deleted = 'Y', "
				   + "	user_deleted_date = sysdate, "
				   + "	user_updated_date = sysdate "
				   + "where user_no = ? ";
		
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, no);
		
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
	public int getUserNo () throws SQLException {
		String sql = "select user_seq.nextval no "
				+ "from dual ";
		int userNo = 0;
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		userNo = rs.getInt("no");

		rs.close();
		pstmt.close();
		connection.close();
		
		return userNo;
	}
	
	/**
	 * 지정된 사용자정보를 테이블에 저장한다.
	 * @param user
	 * @throws SQLException
	 */
	public void insertUser(User user) throws SQLException {
		String sql = "insert into semi_user"
				+ "(user_no, user_id, user_password, user_name, user_tel, user_email, "
				+ "user_created_date, user_email_subscription, user_sms_subscription, grade_code, user_point) "
				+ "values "
				+ "(?, ?, ?, ?, ?, ?, sysdate, ?, ?, '브론즈', ?) ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, user.getNo());
		pstmt.setString(2, user.getId());
		pstmt.setString(3, user.getPassword());
		pstmt.setString(4, user.getName());
		pstmt.setString(5, user.getTel());
		pstmt.setString(6, user.getEmail());
		pstmt.setString(7, user.getEmailSubscription());
		pstmt.setString(8, user.getSmsSubscription());
		pstmt.setInt(9, user.getPoint());
		
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
	public String getGrade(int totalAmount) throws SQLException {
		String sql = "select grade_code "
				+ "from semi_user_grade "
				+ "where ? >= min_accumulated_amount and ? <= max_accumulated_amount ";
		String grade = null;
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, totalAmount);
		pstmt.setInt(2, totalAmount);
		
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		grade = rs.getString("grade_code");

		rs.close();
		pstmt.close();
		connection.close();
		return grade;
	}
}
