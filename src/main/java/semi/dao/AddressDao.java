package semi.dao;

import static util.ConnectionUtil.getConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import semi.vo.Address;
import semi.vo.User;

public class AddressDao {
	
	private static AddressDao self = new AddressDao();
	private AddressDao() {}
	public static AddressDao getInstance() {
		return self;
	}
	
	/**
	 * 사용자 번호에 해당하는 주소록 조회
	 * @param userNo 사용자 번호
	 * @return 주소목록
	 * @throws SQLException
	 */
	public List<Address> getAllAddressByNo(int userNo) throws SQLException {
		List<Address> addressList = new ArrayList<Address>();
		String sql = "select address_no, user_no, address_name, postal_code, address_default, "
				+ "address_detail, base_address "
				+ "from semi_user_address "
				+ "where user_no = ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		ResultSet rs = pstmt.executeQuery();
		
		while (rs.next()) {
			Address address = new Address();
			User user = new User();
			user.setNo(rs.getInt("user_no"));
			
			address.setUser(user);
			
			address.setAddressNo(rs.getInt("address_no"));
			address.setName(rs.getString("address_name"));
			address.setPostalCode(rs.getString("postal_code"));
			address.setAddressDefault(rs.getString("address_default"));
			address.setDetail(rs.getString("address_detail"));
			address.setBaseAddress(rs.getString("base_address"));
			
			addressList.add(address);
		}
		rs.close();
		pstmt.close();
		connection.close();
		return addressList;		
	}
	
	/**
	 * 유저 번호에 해당하는 대표 주소조회
	 * @param userNo 유저 번호
	 * @return 대표 주소
	 * @throws SQLException
	 */
	public Address getRepresentativeAddressByNo (int userNo) throws SQLException {
		Address address = null;
		String sql = "select address_no, user_no, address_name, postal_code, address_default, "
				+ "address_detail, base_address "
				+ "from semi_user_address "
				+ "where user_no = ? "
				+ "and address_default = 'Y' ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, userNo);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			address = new Address();
			User user = new User();
			user.setNo(rs.getInt("user_no"));
			address.setUser(user);
			address.setAddressNo(rs.getInt("address_no"));
			address.setName(rs.getString("address_name"));
			address.setPostalCode(rs.getString("postal_code"));
			address.setAddressDefault(rs.getString("address_default"));
			address.setDetail(rs.getString("address_detail"));
			address.setBaseAddress(rs.getString("base_address"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		return address;
	}
	
	/**
	 * 주소번호에 해당한는 주소지 검색
	 * @param no 주소번호
	 * @return 주소지
	 * @throws SQLException
	 */
	public Address getAddressByNo(int no) throws SQLException {
		Address address = null;
		String sql = "select address_no, user_no, address_name, postal_code, address_default, "
				+ "address_detail, base_address "
				+ "from semi_user_address "
				+ "where address_no = ? "
				+ "and address_default = 'Y' ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, no);
		ResultSet rs = pstmt.executeQuery();
		
		if (rs.next()) {
			address = new Address();
			User user = new User();
			user.setNo(rs.getInt("user_no"));
			address.setUser(user);
			address.setAddressNo(rs.getInt("address_no"));
			address.setName(rs.getString("address_name"));
			address.setPostalCode(rs.getString("postal_code"));
			address.setAddressDefault(rs.getString("address_default"));
			address.setDetail(rs.getString("address_detail"));
			address.setBaseAddress(rs.getString("base_address"));
		}
		rs.close();
		pstmt.close();
		connection.close();
		return address;
	}
	
	/**
	 * 유저 번호에 해당하는 주소정보를 수정
	 * @param address 주소정보
	 * @throws SQLException
	 */
	public void updateAddress(Address address) throws SQLException {
		String sql = "update semi_user_address "
				+ "set "
				+ "    address_name = ?, "
				+ "    postal_code = ?, "
				+ "    address_default = ?, "
				+ "    address_detail = ?, "
				+ "	   base_address = ? "
				+ "where user_no = ? ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setString(1, address.getName());
		pstmt.setString(2, address.getPostalCode());
		pstmt.setString(3, address.getAddressDefault());
		pstmt.setString(4, address.getDetail());
		pstmt.setString(5, address.getBaseAddress());
		pstmt.setInt(6, address.getUser().getNo());
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
	
	/**
	 * 사용자 주소 등록
	 * @param address 사용자 주소
	 * @throws SQLException
	 */
	public void insertAddress(Address address) throws SQLException {
		String sql = "insert into semi_user_address "
				+ "(user_no, address_name, postal_code, address_default, address_detail, base_address) "
				+ "values "
				+ "(?, ?, ?, ?, ?, ?) ";
		Connection connection = getConnection();
		PreparedStatement pstmt = connection.prepareStatement(sql);
		pstmt.setInt(1, address.getUser().getNo());
		pstmt.setString(2, address.getName());
		pstmt.setString(3, address.getPostalCode());
		pstmt.setString(4, address.getAddressDefault());
		pstmt.setString(5, address.getDetail());
		pstmt.setString(6, address.getBaseAddress());
		pstmt.executeUpdate();
		
		pstmt.close();
		connection.close();
	}
}
