package semi.dao;

import static util.ConnectionUtil.getConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import semi.vo.Point;

public class PointDao {
	
	private static PointDao self = new PointDao();
	private PointDao() {}
	public static PointDao getInstance() {
		return self;
	}
	
	/**
	 * 유저 번호에 해당하는 포인트 내역 목록 조회
	 * @param userNo 유저 번호
	 * @return 내역 목록
	 * @throws SQLException
	 */
	public List<Point> getPointHistory(int userNo, int begin, int end) throws SQLException {
		List<Point> pointHistory = new ArrayList<Point>();
		String sql = "select order_no, point, point_status, point_update_date "
				+ "from (select row_number() over (order by point_update_date desc) rn, "
				+ "			order_no, point, point_status, point_update_date "
				+ "			from semi_point_history "
				+ "			where user_no = ?) "
				+ "where rn >= ? and rn <= ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		pstmt.setInt(2, begin);
		pstmt.setInt(3, end);
		
		ResultSet rs = pstmt.executeQuery();
		
		while(rs.next()) {
			Point point = new Point();
			point.setOrderDate(rs.getDate("point_update_date"));
			point.setOrderNo(rs.getInt("order_no"));
			point.setPoint(rs.getInt("point"));
			point.setStatus(rs.getString("point_status"));
			
			pointHistory.add(point);
		}
		rs.close();
		pstmt.close();
		connection.close();
		return pointHistory;
	}
	
	public int getTotalRecords(int userNo) throws SQLException {
		int totalRecords = 0;
		String sql = "select count(*) cnt "
				+ "from semi_point_history "
				+ "where user_no = ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		
		ResultSet rs = pstmt.executeQuery();
		rs.next();
		totalRecords = rs.getInt("cnt");
		
		rs.close();
		pstmt.close();
		connection.close();
		return totalRecords;
	}
	
	
	/**
	 * 포인트 변화 상태를 등록
	 * @param point
	 * @throws SQLException
	 */
	public void insertPoint(Point point) throws SQLException {
		String sql = "insert into semi_point_history "
				+ "(order_no, user_no, point, point_status, point_update_date) "
				+ "values "
				+ "(?, ?, ?, ?, sysdate) ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, point.getOrderNo());
		pstmt.setInt(2, point.getUserNo());
		pstmt.setInt(3, point.getPoint());
		pstmt.setString(4, point.getStatus());
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
}
