<%@page import="semi.dao.CartDao"%>
<%@page import="semi.vo.Product"%>
<%@page import="semi.dao.ProductDao"%>
<%@page import="semi.vo.ProductItem"%>
<%@page import="semi.vo.Address"%>
<%@page import="semi.vo.OrderItem"%>
<%@page import="semi.vo.Order"%>
<%@page import="semi.admin.dao.AdminProductItemDao"%>
<%@page import="semi.admin.dao.AdminProductDao"%>
<%@page import="semi.dao.OrderItemDao"%>
<%@page import="semi.dao.OrderDao"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="semi.vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user = (User)session.getAttribute("LOGIN_USER_INFO");
	String from = StringUtils.defaultString(request.getParameter("from"), "");
	
	// 잘못된 접근일 경우
	if (user == null || "orderForm".equals(from)) {
		response.sendRedirect("/semi-project/index.jsp");
	}
	
	String addressName = StringUtils.defaultString(request.getParameter("addressName"), "");
	String postalCode = StringUtils.defaultString(request.getParameter("postalCode"), "");
	String baseAddress = StringUtils.defaultString(request.getParameter("baseAddress"), "");
	String addressDetail = StringUtils.defaultString(request.getParameter("addressDetail"), "");
	String[] productItemNumbers = request.getParameterValues("no");
	String[] productItemQuantities = request.getParameterValues("amount");
	String usingPoint = StringUtils.defaultString(request.getParameter("usingPoint"), "");
	String totalAmount = StringUtils.defaultString(request.getParameter("totalAmount"), "");
	String paymentMethod = StringUtils.defaultString(request.getParameter("paymentMethod"), "");
	String depositBank = StringUtils.defaultString(request.getParameter("depositBank"), "");
	String depositPersonName = StringUtils.defaultString(request.getParameter("depositPersonName"), "");
	String totalPoint = StringUtils.defaultString(request.getParameter("totalPoint"), "");
	
	OrderDao orderDao = OrderDao.getinstance();
	OrderItemDao orderItemDao = OrderItemDao.getinstance();
	AdminProductDao adminProductDao = new AdminProductDao();
	AdminProductItemDao adminProductItemDao = new AdminProductItemDao();
	ProductDao productDao = ProductDao.getInstance();
	CartDao cartDao = CartDao.getInstance();
	
	Order order = new Order();
	Address address = new Address();
	
	int orderNo = orderDao.getSequenceNextVal();
	
	order.setNo(orderNo);
	order.setUser(user);
	order.setTotalPrice(Long.parseLong(totalAmount));
	order.setDepositPoint(Integer.parseInt(totalPoint));
	order.setStatus("주문완료");
	address.setAddressName(addressName);
	address.setPostalCode(postalCode);
	address.setBaseAddress(baseAddress);
	address.setDetail(addressDetail);
	order.setAddress(address);
	order.setPaymentMethod(paymentMethod);
	order.setUsePoint(Integer.parseInt(usingPoint));
	orderDao.insertOrder(order);
	
	int i = 0;
	for (String productItemNo : productItemNumbers) {
		OrderItem orderItem = new OrderItem();
		ProductItem productItem = new ProductItem();
		int productItemQuantity = Integer.parseInt(productItemQuantities[i]);
		
		orderItem.setOrder(order);
		productItem.setNo(Integer.parseInt(productItemNo));
		orderItem.setProductItem(productItem);
		int productNo = adminProductItemDao.getItemByItemNo(Integer.parseInt(productItemNo)).getProduct().getNo();
		Product product = productDao.getProductDetail(productNo);
		orderItem.setOrderProductPrice(product.getPrice());
		orderItem.setOrderProductQuantity(productItemQuantity);
		orderItemDao.insertOrderItem(orderItem);
		
		ProductItem productItem2 = adminProductItemDao.getItemByItemNo(Integer.parseInt(productItemNo));
		productItem2.setStock(productItem2.getStock() - productItemQuantity);
		productItem2.setSaleCount(productItem2.getSaleCount() + productItemQuantity);
		adminProductItemDao.updateItem(productItem2);
		
		product.setTotalStock(product.getTotalStock() - productItemQuantity);
		product.setTotalSaleCount(product.getTotalSaleCount() + productItemQuantity);
		adminProductDao.updateProduct(product);
		
		cartDao.deleteCartItem(user.getNo(), Integer.parseInt(productItemNo));
		
		i++;
	}
	StringBuilder sb = new StringBuilder();
	if (!usingPoint.isEmpty()) {
		sb.append("&status=use");
		sb.append("&point=" + usingPoint);
	}
	
	response.sendRedirect("point.jsp?orderNo=" + orderNo + "&status=add&point=" + totalPoint + sb.toString());
%>