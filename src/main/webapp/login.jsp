<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="semi.vo.User"%>
<%@page import="semi.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	
	UserDao userDao = UserDao.getInstance();
	User user = userDao.getUserById(id);
	
	String secretPassword = DigestUtils.sha256Hex(password);
	
	if (user == null) {
		response.sendRedirect("loginform.jsp?error=notfound-user");
		return;
	}
	
	if (!secretPassword.equals(user.getPassword())) {
		response.sendRedirect("loginform.jsp?error=mismatch-password");
		return;
	}
	
	if ("Y".equals(user.getDeleted())) {
		response.sendRedirect("loginform.jsp?error=notfound-user");
		return;
	}
	
	session.setAttribute("LOGIN_USER_INFO", user);
	response.sendRedirect("index.jsp?");
%>