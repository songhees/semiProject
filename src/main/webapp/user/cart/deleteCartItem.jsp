<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="semi.dao.CartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//로그인되어 있지 않는 유저일 경우
/* 	if (loginUserInfo == null) {
	response.sendRedirect("../loginform.jsp");		
	return;
} */

	int itemNo = NumberUtils.toInt(request.getParameter("no"));

	CartDao cartDao = CartDao.getInstance();
	/* 10000 => loginUserInfo.getNo()  */
	cartDao.deleteCartItem(10000, itemNo);

	response.sendRedirect("cartList.jsp");
%>