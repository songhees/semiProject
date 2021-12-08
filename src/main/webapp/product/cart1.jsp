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
	String[] productNums = request.getParameterValues("no");
	String[] colors = request.getParameterValues("color");
	String[] sizes = request.getParameterValues("size");
	String[] amounts = request.getParameterValues("amount");
	
	ProductItemCriteria criteria = new ProductItemCriteria();
	ProductItemDao itemDao = ProductItemDao.getInstance();
	CartDao cartDao = CartDao.getInstance();
	ProductItem item = null;
	CartItemDto itemDto = new CartItemDto();
	
	for (int i=0; i<productNums.length; i++) {
		int itemNo = Integer.parseInt(productNums[i]);
		
		criteria.setProductNo(itemNo);
		criteria.setColor(colors[i]);
		criteria.setSize(sizes[i]);
		item = itemDao.getProductItemByProductItemCriteria(criteria);
		
		if (item.getStock() == 0) {
			response.sendRedirect("detail.jsp?no=" + itemNo);
			return;
		}
		
		itemDto.setUserNo(loginUserInfo.getNo());
		itemDto.setProductItemNo(item.getNo());
		itemDto.setQuantity(Integer.parseInt(amounts[i]));
		
		cartDao.insertCartItem(itemDto);
	}
	
	response.sendRedirect("../user/cart/cartList.jsp");
%>