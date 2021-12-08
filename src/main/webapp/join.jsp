<%@page import="semi.dao.PointDao"%>
<%@page import="semi.vo.Point"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.apache.commons.codec.StringDecoder"%>
<%@page import="semi.vo.User"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@page import="semi.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");
	
	// 로그인되어 있지 않는 유저일 경우
	if (loginUserInfo != null) {
		response.sendRedirect("index.jsp");		
		return;
	}
	
	UserDao userDao = UserDao.getInstance();
	// 폼으로 부터 받아온 data
	String userId = request.getParameter("userId");
	String[] phoneNumber = request.getParameterValues("userTel");
	String tel = String.join("-", phoneNumber);
	String email = request.getParameter("userEmail");
	// 회원가입할 유저와 기존 유저의 아이디와 핸드폰 이메일 일치 여부 판정
	if (userDao.getUserByEmail(email) != null) {
		response.sendRedirect("joinForm.jsp?error=email-exists");	
		return;
	}
	if (userDao.getUserByTel(tel) != null) {
		response.sendRedirect("joinForm.jsp?error=tel-exists");	
		return;
	}
	if (userDao.getUserById(userId) != null) {
		response.sendRedirect("joinForm.jsp?error=id-exists");	
		return;
	}
	
	String password = DigestUtils.sha256Hex(request.getParameter("userPassword"));
	String name = request.getParameter("name");
	String smsSubscription = StringUtils.defaultString(request.getParameter("smsSubscription"), "N");
	String emailSubscription = StringUtils.defaultString(request.getParameter("emailSubscription"), "N");
	
	if (smsSubscription != "N") {
		smsSubscription = "Y";
	} 
	if (emailSubscription != "N") {
		emailSubscription = "Y";
	} 
	int userNo = userDao.getUserNo();
	
	loginUserInfo = new User();
	loginUserInfo.setNo(userNo);
	loginUserInfo.setId(userId);
	loginUserInfo.setPassword(password);
	loginUserInfo.setName(name);
	loginUserInfo.setTel(tel);
	loginUserInfo.setEmail(email);
	loginUserInfo.setSmsSubscription(smsSubscription);
	loginUserInfo.setEmailSubscription(emailSubscription);
	
 	userDao.insertUser(loginUserInfo);
	
	response.sendRedirect("index.jsp");
%>