<%@page import="semi.dao.CartDao"%>
<%@page import="semi.dto.CartItemDto"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인되어 있지 않는 유저일 경우
/* 	if (loginUserInfo == null) {
	response.sendRedirect("../loginform.jsp");		
	return;
} */

	int itemNo = NumberUtils.toInt(request.getParameter("no"));
	int amount = NumberUtils.toInt(request.getParameter("amount"));
	
	CartItemDto item = new CartItemDto();
	/* 10000 => loginUserInfo.getNo()  */
	item.setUserNo(10000);
	item.setProductItemNo(itemNo);
	item.setQuantity(amount);
	
	CartDao cartDao = CartDao.getInstance();
	cartDao.updateCartItem(item);
	
	response.sendRedirect("cartList.jsp");

%>