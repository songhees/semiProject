<%@page import="semi.dao.PointDao"%>
<%@page import="semi.vo.Point"%>
<%@page import="semi.vo.User"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");

	// 로그인되어 있지 않는 유저일 경우
	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	}	

	int point = NumberUtils.toInt(request.getParameter("point"), 0);
	int orderNo = NumberUtils.toInt(request.getParameter("orderNo"));
	String status = request.getParameter("status");
	
	Point inputsPoint = new Point();
	inputsPoint.setUserNo(loginUserInfo.getNo());
	inputsPoint.setPoint(point);
	inputsPoint.setStatus(status);
	inputsPoint.setOrderNo(orderNo);
	
	PointDao pointDao = PointDao.getInstance();
	
%>