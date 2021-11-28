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
</style>
<%
	User loginUserInfo = (User)session.getAttribute("LOGIN_USER_INFO");
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
					<li class="nav-item"><a href="#" class="nav-link">LOGIN</a></li>
					<li class="nav-item"><a href="#" class="nav-link">JOIN US</a></li>
<%
	} else {
%>
					<li class="nav-item"><a href="#" class="nav-link">LOGOUT</a></li>
					<li class="nav-item dropdown">
				    	<a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">MY PAGE</a>
				        <ul class="dropdown-menu">
				        	<li><a class="dropdown-item" href="#">주문조회</a></li>
				            <li><a class="dropdown-item" href="#">회원정보수정</a></li>
				            <li><a class="dropdown-item" href="#">관심상품</a></li>
				            <li><a class="dropdown-item" href="#">적립금</a></li>
				            <li><a class="dropdown-item" href="#">나의게시물</a></li>
				            <li><a class="dropdown-item" href="#">최근본상품</a></li>
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
	  		<a href="#"><img alt="" src="/semi-project/resources/images/home/vin.png" style="width: 302px;"></a>
		</div>
		<!-- right side bar-->
		<div style="overflow: hidden;">
			<form class="d-none d-md-flex mt-2"  style="float: left;">
				<input class="form-control form-control-sm" type="search" aria-label="Search">
			    <button class="btn btn-secondary btn-sm opacity-75" type="submit"><i class="bi bi-search"></i></button>
   			</form>
   			<a href="#">
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
				<li class="nav-item"><a class="nav-link fw-bold" href="#">BEST</a></li>
	      		<li class="nav-item"><a class="nav-link fw-bold" href="#">NEW<code class="text-danger">5%</code></a></li>
	        <!-- Navbar dropdown -->
	        	<li class="nav-item"><a class="nav-link" href="#">남녀공용</a></li>
	        	<li class="nav-item"><a class="nav-link" href="#">베스트재진행</a></li>
	        	<li class="nav-item"><a class="nav-link" href="#">OUTER</a></li>
	        	<li class="nav-item"><a class="nav-link" href="#">SHIRT&amp;BLOUSE</a></li>
	        	<li class="nav-item"><a class="nav-link" href="#">DRESS</a></li>
	        	<li class="nav-item"><a class="nav-link" href="#">SKIRT</a></li>
	        	<li class="nav-item"><a class="nav-link" href="#">PANTS</a></li>
	        	<li class="nav-item"><a class="nav-link" href="#">전체상품</a></li>
			</ul>
			<ul class="navbar-nav mb-2 mb-lg-0">
				<li class="nav-item dropdown">
	          		<a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">COMMUNITY</a>
				    <ul class="dropdown-menu">
						<li><a class="dropdown-item" href="#">NOTICE</a></li>
			            <li><a class="dropdown-item" href="#">Q&amp;A</a></li>
			            <li><a class="dropdown-item" href="#">REVIEW</a></li>
			        </ul>
				</li>
			</ul>
	      <!-- Left links -->
		</div>
    <!-- Collapsible wrapper -->
  </div>
</nav>