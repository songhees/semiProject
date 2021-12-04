<%@page import="semi.vo.Address"%>
<%@page import="semi.dao.AddressDao"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="semi.vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int addressNo = NumberUtils.toInt(request.getParameter("no"));

	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");

// 로그인되어 있지 않는 유저일 경우
/* 	if (loginUserInfo == null) {
	response.sendRedirect("../loginform.jsp");		
	return;
} */
	AddressDao addressDao = AddressDao.getInstance();
	Address address = new Address();
	
	User user = new User(); //지울것
	user.setNo(10000);	// 지울것
	/* 로그인 페이지 만든 후 user ->  loginUserInfo 로 수정*/
	address.setUser(user);
	address.setAddressNo(addressNo);
	address.setAddressName(request.getParameter("addressName"));
	address.setPostalCode(request.getParameter("postcode"));
	address.setBaseAddress(request.getParameter("baseAddress"));
	address.setDetail(request.getParameter("addressDetail"));
	
	String isDefault = request.getParameter("isDefault");
	System.out.println("default값" + isDefault);
	if (isDefault == null) {
		address.setAddressDefault("N");
	} else {
		address.setAddressDefault("Y");
		/*10000 -> loginUserInfo.getNo() */
		addressDao.updateDefaultToN(10000);		
	}

	if (addressNo == 0) {
		addressDao.insertAddress(address);
	} else {
		addressDao.updateAddress(address);
	}
	
	response.sendRedirect("addressList.jsp");
%>