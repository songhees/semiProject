<%@page import="semi.criteria.ProductCriteria"%>
<%@page import="semi.vo.Product"%>
<%@page import="java.util.List"%>
<%@page import="semi.dao.ProductDao"%>
<%@page import="semi.vo.Pagination"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
   <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" >
    <title></title>
<style type="text/css">
	li.breadcrumb-item, .breadcrumb-item a, .breadcrumb-item a:hover , a.nav-link, a.nav-link:hover, a.hover {
		text-decoration: none;
		color: #757575;
		font-size: 14px;
	}
	
	form div.search {
		width: 486px;
	    margin: 8px 0 0;
	}
	
	form#search_info {
		width: 580px;
	    margin: 0 auto;
	    padding: 50px 47px;
	    font-size: 12px;
	}
	div.search label {
		float: left;
	    width: 85px;
	    padding: 5px 10px 0 0;
	    font-weight: bold;
	}
	div.search select, div.search input{
		height: 30px;
		border-radius: 0;
		border: 1px solid #e3e3e3;
	}
</style>
</head>
<body>
<%@ include file="../common/navbar.jsp" %>
<%
	String pageNo = StringUtils.defaultString(request.getParameter("pageNo"), "1");
	int categoryNo = NumberUtils.toInt(request.getParameter("category_no"), 0);
	String searchType = StringUtils.defaultString(request.getParameter("search_type"), "product_name");
	String keyword = StringUtils.defaultString(request.getParameter("keyword"));
	long fromPrice = NumberUtils.toInt(request.getParameter("from_price"), 0);
	long toPrice = NumberUtils.toInt(request.getParameter("to_price"), 0);
	String orderBy = StringUtils.defaultString(request.getParameter("order_by"));
	
	Pagination pagination = new Pagination(pageNo, 10, 5, 5);
	ProductDao productDao = ProductDao.getInstance();
	ProductCriteria criteria = new ProductCriteria();
	
	
	criteria.setCategoryNo(categoryNo);
	criteria.setSearchType(searchType);
	criteria.setKeyword(keyword);
	criteria.setFromPrice(fromPrice);
	criteria.setToPrice(toPrice);
	criteria.setOrderBy(orderBy);
	
	List<Product> productList = productDao.getProductBySearch(criteria);
%>
<div class="container">    
	<!-- 브레드크럼 breadcrumb -->
	<div>
		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb justify-content-end">
		    <li class="breadcrumb-item"><a href="../index.jsp">HOME</a></li>
		    <li class="breadcrumb-item active" aria-current="page" style="font-weight: bold;">SEARCH</li>
		  </ol>
		</nav>
	</div>
	<!-- 제목 -->
	<div class="text-center my-5">
		<h5><strong>SEARCH</strong></h5>
	</div>
	<!-- 검색 -->
	<div style="border: 1px solid #e3e3e3;">
		<form action="search.jsp" method="post" id="search_info">
			<input type="hidden" name="pageNo" value="<%=pageNo %>">
			<div class="search">
				<label>상품분류</label>
				<select name="category_no" style="width: 400px;">
					<option value="" selected="selected" disabled="disabled">상품분류 선택</option>
					<option value="1001">OUTER</option>
					<option value="1002">TOP</option>
					<option value="1003">SHIRT&amp;BLOUSE</option>
					<option value="1004">DRESS</option>
					<option value="1005">SKIRT</option>
					<option value="1006">PANTS</option>
					<option value="">전체상품</option>
				</select>			
			</div>
			<div class="search">
				<label>검색조건</label>
				<select name="search_type" style="width: 120px;">
					<option value="product_name">상품명</option>
					<option value="product_code">상품코드</option>
				</select>
				<input type="text" name="keyword" style="width: 276px;">
			</div>
			<div class="search">
				<label>판매가격대</label>
				<input type="text" name="from_price" style="width: 191px;"> ~
				<input type="text" name="to_price" style="width: 191px;">
			</div>
			<div class="search">
				<label>검색정렬기준</label>
				<select name="order_by" style="width: 400px;">
					<option value="" disabled="disabled" selected="selected">기준 선택</option>
					<option value="recent">신상품 순</option>
					<option value="priceasc">낮은가격 순</option>
					<option value="pricedesc">눞은가격 순</option>
					<option value="favor">인기상품 순</option>
					<option value="review">사용후기 순</option>
				</select>			
			</div>
			<div>
				<button type="button" class="btn btn-dark opacity-75 mt-4" style="width: 100%; border-radius: 0;">검색</button>
			</div>
		</form>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>