<%@page import="semi.vo.Address"%>
<%@page import="semi.dao.AddressDao"%>
<%@page import="semi.dao.UserDao"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="semi.vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");

	// 로그인되어 있지 않는 유저일 경우
/* 	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	} */

	String userId = request.getParameter("userId");

	// 로그인한 유저와 수정할 유저의 아이디비교
	/* if (userId.equals(loginUserInfo.getId())) {
		response.sendRedirect("../index.jsp");		
	} */
	
	// 폼으로 부터 받아온 data
	String password = DigestUtils.sha256Hex(request.getParameter("userPassword"));
	String name = request.getParameter("name");
	
	String[] phoneNumber = request.getParameterValues("userTel");
	String tel = String.join("-", phoneNumber);
	
	String smsSubscription = request.getParameter("smsSubscription");
	String email = request.getParameter("userEmail");
	String emailSubscription = request.getParameter("emailSubscription");
	
	// id로 부터 유저정보를 불러와 수정된 값을 대입
	UserDao userDao = UserDao.getInstance();
	/* "osh" -> userId 로 고치기 */
	User user = userDao.getUserById("osh");
	
	AddressDao addressDao = AddressDao.getInstance();
	// 가저온 유저정보의 번호에 해당하는 대표 주소를 가져온다.
	Address address = null;
	address = addressDao.getRepresentativeAddressByUserNo(user.getNo());
	
	String postCode = request.getParameter("postcode");
	String baseAddress = request.getParameter("baseAddress");
	String addressDetail = request.getParameter("addressDetail");
	if (address != null) { 
		// 기존에 있던 주소면 update하여 변경
		address.setPostalCode(postCode);
		address.setBaseAddress(baseAddress);
		address.setDetail(addressDetail);
		// 유저 정보의 번호에 해당하는 대표 주소의 번호를 통해 수정한다.
		addressDao.updateAddress(address);
	} else {
		// 기존에 없던 주소면 insert하여 넣는다.
		address = new Address();
		address.setUser(user);
		address.setAddressName("미지정");
		address.setPostalCode(postCode);
		address.setAddressDefault("Y");
		address.setBaseAddress(baseAddress);
		address.setDetail(addressDetail);
		addressDao.insertAddress(address);
	}
	
	user.setPassword(password);
	user.setName(name);
	user.setTel(tel);
	user.setSmsSubscription(smsSubscription);
	user.setEmail(email);
	user.setEmailSubscription(emailSubscription);
	
 	userDao.updateUser(user);
	
	response.sendRedirect("../index.jsp");
%>