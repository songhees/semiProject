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
	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	}
	AddressDao addressDao = AddressDao.getInstance();
	Address address = new Address();
	
	address.setUser(loginUserInfo);
	address.setAddressNo(addressNo);
	address.setAddressName(request.getParameter("addressName"));
	address.setPostalCode(request.getParameter("postcode"));
	address.setBaseAddress(request.getParameter("baseAddress"));
	address.setDetail(request.getParameter("addressDetail"));
	
	String isDefault = request.getParameter("isDefault");
	if (isDefault == null) {
		address.setAddressDefault("N");
	} else {
		address.setAddressDefault("Y");
		addressDao.updateDefaultToN(loginUserInfo.getNo());		
	}

	if (addressNo == 0) {
		addressDao.insertAddress(address);
	} else {
		addressDao.updateAddress(address);
	}
	
	response.sendRedirect("addressList.jsp");
%>