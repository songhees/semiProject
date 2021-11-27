<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="semi.vo.OrderItem"%>
<%@page import="java.util.List"%>
<%@page import="semi.vo.Pagination"%>
<%@page import="semi.dao.OrderDao"%>
<%@page import="semi.vo.User"%>
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
	li.breadcrumb-item, .breadcrumb-item a, a.nav-link {
	text-decoration: none;
	color: grey;
	font-size: 14px;
	}
	table th, table td {
    	padding: 11px;
	    color: #757575;
    	text-align: center;
	    font-size: 15px;
	}

	table {
	    text-align: center;
		width: 100%;
		margin: auto;
	}
	td img {
		width: 80px;
		height: 100px;
	}
</style>
</head>
<body>
<%@ include file="../common/navbar.jsp" %>
<%
	String subMenu = request.getParameter("subMenu");
	String pageNo = request.getParameter("pageNo");
	
	OrderDao orderDao = OrderDao.getinstance();
	/* login.jsp 완성시  loginUserInfo.getId() 넣기*/
	int totalRecords = orderDao.getTotalRecords("osh");

	Pagination pagination = new Pagination(pageNo, totalRecords);
	/* login.jsp 완성시  loginUserInfo.getId() 넣기*/
	List<OrderItem> itemList = orderDao.getOrderItemListByUserId("osh", pagination.getBegin(), pagination.getEnd());
%>
<div class="container">    
	<!-- 브레드크럼 breadcrumb -->
	<div>
		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb justify-content-end">
		    <li class="breadcrumb-item"><a href="#">HOME</a></li>
		    <li class="breadcrumb-item"><a href="#">MY PAGE</a></li>
		    <li class="breadcrumb-item active" aria-current="page">ORDER</li>
		  </ol>
		</nav>
	</div>
	<!-- 제목 -->
	<div class="text-center mt-5">
		<h5><strong>ORDER</strong></h5>
	</div>
	<!-- tabs -->
	<div class="my-5 border-top" style="background-color: #FFFAFA">
		<ul class="nav nav-tabs nav-justified" id="navColor">
		    <li class="nav-item"><a class="nav-link <%="order".equals(subMenu)? "active" : ""%>" href="orderList.jsp?pageNo=1&subMenu=order">주문내역조회 (<%=totalRecords %>)</a></li>
		    <li class="nav-item"><a class="nav-link <%="cancel".equals(subMenu)? "active" : ""%>" href="orderList.jsp?pageNo=1&subMenu=cancel">취소/반품/교환 내역 ()</a></li>
		    <li class="nav-item"><a class="nav-link <%="history".equals(subMenu)? "active" : ""%>" href="orderList.jsp?pageNo=1&subMenu=history">과거주문내역 ()</a></li>
	    	<li class="nav-item"><a class="nav-link disabled" href="#"></a></li>
		</ul>
	</div >
	<!-- 날짜 검색 -->
	<div>
	</div>
	<!-- table 주문 목록 -->
	<div>
		<h6><small>주문 상품 정보</small></h6>
		<table>
			<colgroup>
				<col width="9%">
				<col width="8%">
				<col width="*%">
				<col width="8%">
				<col width="8%">
				<col width="9%">
			</colgroup>
			<thead  style="border-top: 1px solid #e3e3e3; background-color: #fbfafa;">
				<tr>
					<th>주문일자<pre class="mb-1">[주문번호]</pre></th>
					<th>이미지</th>
					<th>상품정보</th>
					<th>수량</th>
					<th>구매금액</th>
					<th>주문처리상태</th>
				</tr>
			</thead>
			<tbody>
<%
	List<Integer> countNo = new ArrayList<>();
	for (OrderItem item : itemList) {
		countNo.add(item.getOrder().getNo());
	}
	
	int comparedOrderNo = 0;
	for (OrderItem item : itemList) {
%>
				<tr style="border-top: 1px solid #e3e3e3;">
<%
		if (item.getOrder().getNo() != comparedOrderNo) {
			int orderNoFrequency = Collections.frequency(countNo, item.getOrder().getNo());
%>
					<td rowspan="<%=orderNoFrequency %>"><small><%=item.getOrder().getCreatedDate() %></small><pre>[<%=item.getOrder().getNo() %>]</pre></td>
<%
		} else {
%>
					<td style="display: none;"></td>
<%			
		}
		comparedOrderNo = item.getOrder().getNo();
%>
					<td><img alt="" src=<%=item.getProductItem().getProduct().getThumbnailUrl() %>></td>
					<td style="text-align: left;"><strong><%=item.getProductItem().getProduct().getName() %></strong>
						<pre>[옵션: <%=item.getProductItem().getColor() %>/<%=item.getProductItem().getSize() %>]</pre>
					</td>
					<td><%=item.getOrderProductQuantity() %></td>
					<td><strong><%=item.getOrderProductPrice() %>원</strong></td>
					<td><%=item.getOrder().getStatus() %>
						<button class="btn btn-dark btn-sm opacity-75 m-1">구매후기</button>
					</td>
				</tr>
<%
	}
%>
			</tbody>
		</table>
	</div>
	<!-- pagination -->
	<div class="row mt-3">
		<div class="col-6 offset-3">
			<nav aria-label="Page navigation example">
				<ul class="pagination justify-content-center">
					<li class="page-item <%=pagination.isExistPrev()? "" : "disabled" %>">
					    <a class="page-link" href="orderList.jsp?pageNo=<%=pagination.getPrevPage() %>&subMenu=order" aria-label="Previous">
					    	<span aria-hidden="true">&laquo;</span>
					    </a>
				    </li>
	<%
		for (int i = pagination.getBeginPage() ; i <= pagination.getEndPage() ; i++) {
	%>				    
					<li class="page-item"><a class="page-link" href="orderList.jsp?pageNo=<%=i %>&subMenu=order"><%=i %></a></li>
	<%
		}
	%>
				    <li class="page-item <%=pagination.isExistNext()? "" : "disabled" %>">
					    <a class="page-link" href="orderList.jsp?pageNo=<%=pagination.getNextPage() %>&subMenu=order" aria-label="Next">
					    	<span aria-hidden="true">&raquo;</span>
					    </a>
				    </li>
				</ul>
			</nav>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>