<%@page import="semi.dao.UserDao"%>
<%@page import="semi.vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");

	// 로그인되어 있지 않는 유저일 경우
	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	}
	UserDao userDao = UserDao.getInstance();
	
	userDao.deleteUser(loginUserInfo.getNo());
	
	response.sendRedirect("../logout.jsp");
%>