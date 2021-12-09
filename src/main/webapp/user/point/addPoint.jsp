<%@page import="semi.vo.User"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="semi.dao.PointDao"%>
<%@page import="semi.vo.Point"%>
<%@page import="semi.dao.UserDao"%>
<%@page import="semi.dao.OrderDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");

	// 로그인되어 있지 않는 유저일 경우
	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	}	
	
	String[] points = request.getParameterValues("point");
	int orderNo = NumberUtils.toInt(request.getParameter("orderNo"));
	String[] statuses = request.getParameterValues("status");
	
	Point inputsPoint = new Point();
	PointDao pointDao = PointDao.getInstance();
	for (int i=0; i<points.length; i++) {
		inputsPoint.setUserNo(loginUserInfo.getNo());
		inputsPoint.setPoint(Integer.parseInt(points[i]));
		inputsPoint.setStatus(statuses[i]);
		inputsPoint.setOrderNo(orderNo);
		
		pointDao.insertOrderPoint(inputsPoint);
	}
	
	/*  주문진행 후 
		주문과 관련된 값들을 SEMI_ORDER 테이블에 대입 후 
		주문한 총 금액을 조회하여 사용자의 등급을 조정  
	*/
	OrderDao orderDao = OrderDao.getinstance();
	int totalAmount = orderDao.getTotalAmount(loginUserInfo.getNo())[0];
	UserDao userDao = UserDao.getInstance();
	loginUserInfo.setGradeCode(userDao.getGrade(totalAmount));
	
	// point 조정
	int depositPoint = 0;
	for (int i=0; i<points.length; i++) {
		if ("add".equals(statuses[i])) {
			depositPoint += Integer.parseInt(points[i]);
		} else {
			depositPoint -= Integer.parseInt(points[i]);
		}
	}
	loginUserInfo.setPoint(loginUserInfo.getPoint() + depositPoint);
	
	userDao.updateUser(loginUserInfo);
%>