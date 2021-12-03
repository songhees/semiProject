<%@page import="semi.vo.User"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="semi.dao.AddressDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String menu = request.getParameter("menu");
	int addressNo = NumberUtils.toInt(request.getParameter("no"), 0);
	
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");
	

	// 로그인되어 있지 않는 유저일 경우
/* 	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	} */
	
	AddressDao addressDao = AddressDao.getInstance();
	
	/* 사용자가 고정 버튼을 누를 경우 
		모든 배송지의 기본값 여부는 N이되고 버튼을 누른 addressNo의 배송지만 Y로 변경한다.
	*/
	if ("fix".equals(menu)) {
		/* 로그인폼 완성 후 loginUserInfo.getNo넣기 */
		// 사용자의 모든 배송지의 기본값을 N으로 바꾼다.
		addressDao.updateDefaultToN(10000);		
		// 배송지번호에 해당하는 배송지의 기본값을 Y로 바꾼다.
		addressDao.updateDefault(addressNo, "Y");
	}
	
	/* 사용자가 해제 버튼을 누를 경우
		배송지번호에 해당하는 배송지의 기본값을 N으로 바꾼다.
	*/
	if ("release".equals(menu)) {
		addressDao.updateDefault(addressNo, "N");
	}
	
	response.sendRedirect("addressList.jsp");
%>