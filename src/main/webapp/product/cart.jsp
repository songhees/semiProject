<%@page import="semi.dto.CartItemDto"%>
<%@page import="semi.vo.ProductItem"%>
<%@page import="semi.dao.ProductItemDao"%>
<%@page import="semi.criteria.ProductItemCriteria"%>
<%@page import="semi.vo.User"%>
<%@page import="semi.dao.CartDao"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");

	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	}
	// 세가지 정보로 productItem의 no를 찾기
	int productNo = NumberUtils.toInt(request.getParameter("no"));
	String color = StringUtils.defaultString(request.getParameter("color"));
	String size = StringUtils.defaultString(request.getParameter("size"));
	
	ProductItemCriteria criteria = new ProductItemCriteria();
	criteria.setProductNo(productNo);
	criteria.setColor(color);
	criteria.setSize(size);
	
	ProductItemDao itemDao = ProductItemDao.getInstance();
	ProductItem item = itemDao.getProductItemByProductItemCriteria(criteria);
	
	if (item.getStock() == 0) {
		response.sendRedirect("detail.jsp?no=" + productNo);
		return;
	} 
	int amount = NumberUtils.toInt(request.getParameter("amount"));
	
	CartItemDto itemDto = new CartItemDto();
	itemDto.setUserNo(loginUserInfo.getNo());
	itemDto.setProductItemNo(item.getNo());
	itemDto.setQuantity(amount);
	
	CartDao cartDao = CartDao.getInstance();
	cartDao.insertCartItem(itemDto);	
	
	response.sendRedirect("../user/cart/cartList.jsp");
%>