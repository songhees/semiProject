<%@page import="semi.vo.User"%>
<%@page import="semi.vo.Address"%>
<%@page import="semi.dao.AddressDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String[] nums = request.getParameterValues("no");

	// 로그인되어 있지 않는 유저일 경우
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");
	if (loginUserInfo == null) {
		response.sendRedirect("../../loginform.jsp");		
		return;
	} 
	
	AddressDao addressDao = AddressDao.getInstance();

	/*	로그인한 유저가 해당 주소 데이터의 유저 정보가 아닌경우 */
	for (String num : nums) {
		int no = Integer.parseInt(num);
		
		Address address = addressDao.getAddressByNo(no);
		
		if (loginUserInfo.getNo() != address.getUser().getNo()) {
			response.sendRedirect("addressList.jsp?error=deny-delete");
			return;
		}
		addressDao.deleteAddress(no);
	}
	
	response.sendRedirect("addressList.jsp");
%>