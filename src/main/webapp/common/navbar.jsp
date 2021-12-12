<%@page import="semi.vo.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" >
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
<style>
	#navbar-1 {
		font-size: 13px;
	}
	
	#navbar-2 > ul > li > a.nav-link {
		color: black;
		font-weight: normal;
		font-size: 15px;
		min-width: 70px;
	}
	#navbar-2 > ul > li.nav-item {
		margin: 3px;
	}
	
	.dropdown:hover .dropdown-menu {
    	display: block;
    	margin-top: 0;
	}
</style>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");
	User adminUserInfo = (User)session.getAttribute("ADMIN_USER_INFO");
%>
<!-- 맨 위 navbar -->
<nav class="navbar navbar-expand-lg navbar-light border-bottom" style="font-weight: bold; background-color: #FFFAFA;">
	<div class="container-fluid p-4">
		<!-- login bar -->
		<div id="left-bar">
			<button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbar-1">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbar-1">
				<ul class="navbar-nav me-auto mb-1 mb-lg-0">
<%
	if (loginUserInfo == null) {
%>
					<li class="nav-item"><a href="/shopingMall/loginform.jsp" class="nav-link">LOGIN</a></li>
					<li class="nav-item"><a href="/shopingMall/joinForm.jsp" class="nav-link">JOIN US</a></li>
<%
	} else {
%>
					<li class="nav-item"><a href="/shopingMall/logout.jsp" class="nav-link">LOGOUT</a></li>
					<li class="nav-item dropdown">
				    	<a class="nav-link dropdown-toggle" href="/shopingMall/user/mypage.jsp" role="button">MY PAGE</a>
				        <ul class="dropdown-menu">
				        	<li><a class="dropdown-item" href="/shopingMall/user/orderList.jsp">주문조회</a></li>
				            <li><a class="dropdown-item" href="/shopingMall/user/modifyForm.jsp">회원정보수정</a></li>
				            <li><a class="dropdown-item" href="/shopingMall/user/point/pointHistory.jsp">적립금</a></li>
				            <li><a class="dropdown-item" href="/shopingMall/user/reviewList.jsp">나의게시물</a></li>
				        </ul>
        			</li>
<%
	}
%>
				</ul>
	  		</div>
		</div>
		<!-- logo bar -->
		<div id="#logoImg">
	  		<a href="/semi-project/index.jsp"><img alt="" src="/shopingMall/resources/images/home/vin.png" style="width: 302px;"></a>
		</div>
		<!-- right side bar-->
		<div style="overflow: hidden;">
			<form class="d-none d-md-flex mt-2" style="float: left;" method="get" action="/shopingMall/product/search.jsp">
				<input class="form-control form-control-sm" type="search" aria-label="Search" name="keyword">
			    <button class="btn btn-secondary btn-sm opacity-75" type="submit"><i class="bi bi-search"></i></button>
   			</form>
   			<a href="/semi-project/user/cart/cartList.jsp">
		  		<i class="bi bi-cart text-dark opacity-75 p-3" style="font-size: 30px;"></i>
   			</a>
		</div>
	</div>
</nav>
<!-- product list navbar -->
<nav class="navbar navbar-expand navbar-light mb-3 border-bottom" style="font-weight: bold;" id="nav">
	<div class="container">
	    <!-- Collapsible wrapper -->
		<div class="collapse navbar-collapse justify-content-center" id="navbar-2">
	      <!-- Left links -->
			<ul class="navbar-nav mb-2 mb-lg-0">
	        <!-- Navbar dropdown -->
	        	<li class="nav-item"><a class="nav-link" href="/shopingMall/product/list.jsp?category=OUTER">OUTER</a></li>
	        	<li class="nav-item"><a class="nav-link" href="/shopingMall/product/list.jsp?category=TOP">TOP</a></li>
	        	<li class="nav-item"><a class="nav-link" href="/shopingMall/product/list.jsp?category=SHIRT">SHIRT&amp;BLOUSE</a></li>
	        	<li class="nav-item"><a class="nav-link" href="/shopingMall/product/list.jsp?category=DRESS">DRESS</a></li>
	        	<li class="nav-item"><a class="nav-link" href="/shopingMall/product/list.jsp?category=SKIRT">SKIRT</a></li>
	        	<li class="nav-item"><a class="nav-link" href="/shopingMall/product/list.jsp?category=PANTS">PANTS</a></li>
	        	<li class="nav-item"><a class="nav-link" href="/shopingMall/product/list.jsp?category=전체상품">전체상품</a></li>
			</ul>
			<ul class="navbar-nav mb-2 mb-lg-0">
				<li class="nav-item dropdown">
	          		<a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">COMMUNITY</a>
				    <ul class="dropdown-menu">
						<li><a class="dropdown-item" href="#">NOTICE</a></li>
			            <li><a class="dropdown-item" href="/shopingMall/inquiry/list.jsp">Q&amp;A</a></li>
			            <li><a class="dropdown-item" href="#">REVIEW</a></li>
			        </ul>
				</li>
			</ul>	
	      <!-- Left links -->
		</div>
    <!-- Collapsible wrapper -->
  </div>
</nav>