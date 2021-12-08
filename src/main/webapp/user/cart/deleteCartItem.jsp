<%@page import="semi.vo.User"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="semi.dao.CartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");
	//로그인되어 있지 않는 유저일 경우
 	if (loginUserInfo == null) {
		response.sendRedirect("../../loginform.jsp");		
		return;
	}

	int itemNo = NumberUtils.toInt(request.getParameter("no"));
	
	CartDao cartDao = CartDao.getInstance();
	cartDao.deleteCartItem(loginUserInfo.getNo(), itemNo);

	response.sendRedirect("cartList.jsp");
%>