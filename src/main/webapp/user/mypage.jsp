<%@page import="java.text.DecimalFormat"%>
<%@page import="semi.dao.OrderDao"%>
<%@page import="semi.dao.UserDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
   <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" >
    <title>빈스데이</title>
<style type="text/css">
	li.breadcrumb-item, .breadcrumb-item a, a.nav-link, li.breadcrumb-item a:hover{
		text-decoration: none;
		color: #757575;
		font-size: 14px;
	}
	
	strong.data {
		text-align: right;
		float: right;
	    width: 47%;
	    padding: 0 10px;
	}
	ul.state li {
		list-style: none;
		float: left;
		width: 25%;
		border-right: 1px dotted #c9c7ca;
		font-weight: bold;
	}

	ul.state li a {
		text-decoration: none;
		color: #383838;
		font-size: 24px;
	}
	
	ul.point li.title {	
		color: #404040;
		padding: 15px 80px;
		border: 1px solid #ebebeb;
		list-style: none;
		font-size: 13px;
		float: left;
		width: 50%;
	}
	
	ul.state, ul.point {
		 padding-left: 0;
	}
	
	div.order {
		border: 1px solid black;
		height: 170px;
	}
	
	 ul.state strong {
		display: block;
		margin: 2px 0 7px;
	 }
	 
	 div.card-body i.bi::before {
	 	font-size: 50px;
	 	stroke-width: 1px;
	 }
	 
	 .card-text a, .card-text span, .card-title a{
	 	text-decoration: none;
	 	font-size: 12px;
	 	color: #8f8f8f;
	 }
	 
	 .card-title a {
	 	color: #383838;
	 }
	 
	 div.card-body {
	 	padding: 40px 30px;
	 }
	 
	 div.card {
	 	width: 240px;
	 	margin: 0 1% 2%;
	 }
	 .card-title a strong {
	 	font-size: 15px;
	 }
	 
	 a[href]:hover {
		color: #d9d7d7;
	}
</style>
</head>
<body>
<%@ include file="../../common/navbar.jsp" %>
<%
	/* 로그인 없이 이 페이지에 접근하는 경우 */
	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	} 

	UserDao userDao = UserDao.getInstance();
	OrderDao orderDao = OrderDao.getinstance();
	
	int[] totalAmount = orderDao.getTotalAmount(loginUserInfo.getNo());
	DecimalFormat df = new DecimalFormat("##,###");
%>
<div class="container">    
	<div class="row">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<div>
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
				  <ol class="breadcrumb justify-content-end">
				    <li class="breadcrumb-item"><a href="../index.jsp">HOME</a></li>
				    <li class="breadcrumb-item active" aria-current="page" style="font-weight: bold;">MY PAGE</li>
				  </ol>
				</nav>
			</div>
			<!-- 제목 -->
			<div class="text-center my-5">
				<h5><strong>MY PAGE</strong></h5>
			</div>
		</div>
	</div>
	<div class="row mb-4">
		<div class="col">
			<ul class="point">
				<li class="title"><span>총 적립금</span>
					<strong class="data"><%=df.format(loginUserInfo.getPoint()) %>원</strong>
				</li>
				<li class="title"><span >총 주문</span>
					<strong class="data"><%=df.format(totalAmount[0]) %>원 (<%=totalAmount[1] %>회)</strong>
				</li>
			</ul>
		</div>
	</div>
	<div class="row mb-5">
		<div class="col">
			<div class="order">
				<div class="border-bottom" style="padding: 11px 21px; background: #fafafa;">
					<strong>나의 주문처리 현황</strong>
					<span><small>(최근 3개월 기준)</small></span>
				</div>
				<div style="padding: 19px 0;">
					<ul class="state text-center">
						<li><strong>주문완료</strong>
							<!--10000 -> loginUserInfo.getNo() -->
							<a href="orderList.jsp?subMenu=order"><%=orderDao.getOrderItemAmount(loginUserInfo.getNo(), "주문완료") %></a>
						</li>
						<li><strong>교환</strong>
							<a href="orderList.jsp?subMenu=exchange"><%=orderDao.getOrderItemAmount(loginUserInfo.getNo(), "교환") %></a>
						</li>
						<li><strong>취소</strong>
							<a href="orderList.jsp?subMenu=cancel"><%=orderDao.getOrderItemAmount(loginUserInfo.getNo(), "취소") %></a>
						</li>
						<li><strong>반품</strong>
							<a href="orderList.jsp?subMenu=return"><%=orderDao.getOrderItemAmount(loginUserInfo.getNo(), "반품") %></a>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="row mb-3 grid">
		<div class="col">
			<div class="card">
				<div class="card-body">
					<div class="text-center">
						<i class="bi bi-file-earmark-text"></i>
						<div class="card-title py-2">
							<a class="card-title" href="orderList.jsp"><strong>ORDER</strong>
							<span style="display: block;">주문내역 조회</span>
							</a>
						</div>
						<p class="card-text text-muted">
							<a href="orderList.jsp">고객님께서 주문하신 상품의 주문내역을 확인하실 수 있습니다.</a>
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="col">
			<div class="card">
				<div class="card-body">
					<div class="text-center">
						<i class="bi bi-credit-card"></i>
						<div class="card-title py-2">
							<a class="card-title" href="modifyForm.jsp"><strong>PROFILE</strong>
							<span style="display: block;">회원 정보</span>
							</a>
						</div>
						<p class="card-text text-muted">
							<a href="modifyForm.jsp">회원이신 고객님의 개인정보를 관리하는 공간입니다.</a>
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="col">
			<div class="card">
				<div class="card-body">
					<div class="text-center">
						<i class="bi bi-piggy-bank"></i>
						<div class="card-title py-2">
							<a class="card-title" href="point/pointHistory.jsp"><strong>MILEAGE</strong>
							<span style="display: block;">적립금</span>
							</a>
						</div>
						<p class="card-text text-muted">
							<a href="point/pointHistory.jsp">적립금은 상품 구매 시 사용하실 수 있습니다.</a>
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="col">
			<div class="card">
				<div class="card-body">
					<div class="text-center">
						<i class="bi bi-house"></i>
						<div class="card-title py-2">
							<a class="card-title" href="address/addressList.jsp"><strong>ADDRESS</strong>
							<span style="display: block;">배송 주소록 관리</span>
							</a>
						</div>
						<p class="card-text text-muted">
							<a href="address/addressList.jsp">자주 사용하는 배송지를 등록하고 관리하실 수 있습니다.</a>
						</p>
					</div>
				</div>
			</div>
		</div>
		<div class="col">
			<div class="card">
				<div class="card-body">
					<div class="text-center">
						<i class="bi bi-pencil-square"></i>
						<div class="card-title py-2">
							<a class="card-title" href="#"><strong>BOARD</strong>
							<span style="display: block;">게시물 관리</span>
							</a>
						</div>
						<p class="card-text text-muted">
							<a href="#">고객님께서 작성하신 게시물을 관리하는 공간입니다.</a>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>