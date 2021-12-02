<%@page import="java.text.DecimalFormat"%>
<%@page import="org.apache.tomcat.jakartaee.commons.io.output.NullOutputStream"%>
<%@page import="semi.criteria.OrderItemCriteria"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.time.LocalDate"%>
<%@page import="semi.criteria.OrderItemCriteria"%>
<%@page import="semi.dto.OrderItemDto"%>
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

	li.breadcrumb-item, .breadcrumb-item a, a.nav-link, a.hover {
		text-decoration: none;
		color: #757575;
		font-size: 14px;
	}
	a.hover:hover {
		color: #d9d7d7;
	}
	
	table th, table td {
    	padding: 11px;
	    color: #757575;
    	text-align: center;
	    font-size: 14px;
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
	
	table tr {
		border-top: 1px solid #e3e3e3;
		border-bottom: 1px solid #e3e3e3;
	}
	.nav > li > a.active {
    	background-color: #404040 !important;
    	color: white !important;
	}
	
	.nav > li {
    	border-right: 1px solid #ebebeb;
	}
	
	a.page-link {
		border: none;
		color: #757575;
		padding: 4px 0;
		width: 20px;
		text-align: center;
	}
	li.page-item.active > a.page-link {
		color: #757575;
		background-color: white;
		font-weight: bold;
	}
	li.page-item.active {
		border-bottom: 2px solid #757575;
	}
	li.page-item {
		margin: 0 6px;
	}
</style>
</head>
<body>
<!-- 굳이 status에 대해 나눌 필요없이 subMenu로 나누면된다 -> 코드 줄임 -->
<%@ include file="../common/navbar.jsp" %>
<%
	
	String pageNo = request.getParameter("pageNo");
	OrderDao orderDao = OrderDao.getinstance();
	OrderItemCriteria criteria = new OrderItemCriteria();
	
	String subMenu = request.getParameter("subMenu");
	String startDate = request.getParameter("startDate");
	String endDate = request.getParameter("endDate");
	
	if (subMenu == null) {
		subMenu = "order";
		startDate = criteria.getPeriod(3)[0];
		endDate = criteria.getPeriod(3)[1];
	} else if (subMenu != null && startDate == null) {
		startDate = criteria.getPeriod(3)[0];
		endDate = criteria.getPeriod(3)[1];
	}
	
	/* 로그인 없이 이 페이지에 접근하는 경우 */
/* 	if (loginUserInfo == null) {
		response.sendRedirect("loginform.jsp");		
		return;
	} */

	/* 검색 조건 */
	/* login.jsp 완성시  loginUserInfo.getId() 넣기*/
	criteria.setUserId("osh");
	criteria.setBeginDate(startDate);
	criteria.setEndDate(endDate);
	criteria.setStatus(subMenu);
	
	/* 예외발생시 */
	int nowYear = Calendar.getInstance().get(Calendar.YEAR)-1;
	int year = 0;
	
	/* "subMenu" 가 뭔지에 따라  orderDao.getOrderItemListByUserId의 매개 변수를 다르게 한다.*/
	if ("history".equals(subMenu)) {
		try {
			year = Integer.parseInt(request.getParameter("year"));
		} catch (NumberFormatException e) {
			year = nowYear;
		}
		criteria.setBeginDate(year + "/01/01");
		criteria.setEndDate((year+1) + "/01/01");
	}
	
	int totalRecords = orderDao.getTotalRecords(criteria);
	Pagination pagination = new Pagination(pageNo, totalRecords, 5, 5);
	
	/* login.jsp 완성시  loginUserInfo.getId() 넣기*/
	criteria.setBegin(pagination.getBegin());
	criteria.setEnd(pagination.getEnd());

	List<OrderItemDto> itemList = orderDao.getOrderItemListByUserId(criteria);
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
	<!-- 주문상태 tabs subMenu -->
	<div class="mt-5" style="background-color: #FFFAFA">
		<ul class="nav nav-tabs nav-justified border">
		    <li class="nav-item"><a class="nav-link <%="order".equals(subMenu)? "active" : ""%>" href="orderList.jsp?pageNo=1&subMenu=order">주문내역조회</a></li>
		    <!-- 주문 상태가 취소/반품/교환 인 상품의 목록으로 이동하는 버튼 -->
		    <li class="nav-item"><a class="nav-link <%="cancel".equals(subMenu)? "active" : ""%>" href="orderList.jsp?pageNo=1&subMenu=cancel">취소/반품/교환내역</a></li>
		    <!-- 년도별 주문내역 조회 -->
		    <li class="nav-item"><a class="nav-link <%="history".equals(subMenu)? "active" : ""%>" href="orderList.jsp?pageNo=1&subMenu=history">과거주문내역</a></li>
	    	<li class="nav-item"><a class="nav-link disabled" href="#"></a></li>
		</ul>
	</div>
	<!-- 특정 주문상태 TAB에 해당하는 날짜 검색 -->
	<div class="my-3 border">
<%
	if ("history".equals(subMenu)) {
%>
		<div class="p-3">
			<form action="orderList.jsp" method="get">
				<input type="hidden" name="pageNo" value="1" >
				<input type="hidden" name="subMenu" value="history" >
				<select name="year" style="min-width: 90px;">
<%
		for (int i = 0 ; i < 5; i++) {
%>
					<option value="<%=nowYear-i %>" <%=year == (nowYear-i) ? "selected" : "" %>> <%=nowYear-i %> 년</option>
<%
		}
%>
				</select>
				<button class="btn btn-dark btn-sm opacity-75 m-1" type="submit">조회</button>
			</form>
		</div>
<%
	} else {
%>
		<div class="btn-group btn-group-sm p-3">
			<!-- <form id="form-search" method="get" action="orderList.jsp">
					<input type="button" onclick="" name="period">오늘 -->
		  	<a class="btn btn-outline-secondary" href="orderList.jsp?pageNo=1&subMenu=<%=subMenu %>&startDate=<%=criteria.getPeriod(0)[0] %>&endDate=<%=criteria.getPeriod(0)[1] %>">오늘</a>
			<a class="btn btn-outline-secondary" href="orderList.jsp?pageNo=1&subMenu=<%=subMenu %>&startDate=<%=criteria.getPeriod(1)[0] %>&endDate=<%=criteria.getPeriod(1)[1] %>">1개월</a>
			<a class="btn btn-outline-secondary" href="orderList.jsp?pageNo=1&subMenu=<%=subMenu %>&startDate=<%=criteria.getPeriod(3)[0] %>&endDate=<%=criteria.getPeriod(3)[1] %>">3개월</a>
			<a class="btn btn-outline-secondary" href="orderList.jsp?pageNo=1&subMenu=<%=subMenu %>&startDate=<%=criteria.getPeriod(6)[0] %>&endDate=<%=criteria.getPeriod(6)[1] %>">6개월</a>
		</div>
<%
	}
%>
	</div>
	<!-- 부가 설명  -->
	<div>
		<ul class="mb-5" style="font-size: 12px; color: #757575;">
			<li>기본적으로 최근 3개월간의 자료가 조회되며, 기간 검색시 주문처리완료 후 15개월 이내의 주문내역을 조회하실 수 있습니다.</li>
			<li>완료 후 15개월 이상 경과한 주문은 [과거주문내역]에서 확인할 수 있습니다.</li>
			<li>주문번호를 클릭하시면 해당 주문에 대한 상세내역을 확인하실 수 있습니다.</li>
			<li>취소/교환/반품 신청은 배송완료일 기준 7일까지 가능합니다</li>
		</ul>
	</div>
	<!-- table 주문 목록 -->
	<div>
		<h6><small>주문 상품 정보</small></h6>
	</div>
	<div>
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
	DecimalFormat df = new DecimalFormat("##,###");
	if (itemList.isEmpty()) {
%>
				<tr>
					<td class="text-center p-5" colspan="6">주문 내역이 없습니다.</td>
				</tr>
<%
	} else {
		List<Integer> countNo = new ArrayList<>();
		for (OrderItemDto item : itemList) {
			countNo.add(item.getOrderNo());
		}
	
		int comparedOrderNo = 0;
		for (OrderItemDto item : itemList) {
%>
				<tr>
<%
			if (item.getOrderNo() != comparedOrderNo) {
				int orderNoFrequency = Collections.frequency(countNo, item.getOrderNo());
%>
					<td rowspan="<%=orderNoFrequency %>"><small><%=item.getOrderCreatedDate() %></small>
						<pre><a class="hover" href="orderDetail.jsp?orderNo=<%=item.getOrderNo() %>">[<%=item.getOrderNo() %>]</a></pre>
					</td>
<%
			} else {
%>
					<td style="display: none;"></td>
<%			
			}
			comparedOrderNo = item.getOrderNo();
			String productPrice = df.format(item.getOrderProductPrice());
%>
					<td><img alt="" src="../resources/images/product/<%=item.getProductNo() %>/thumbnail/<%=item.getThumbnailUrl() %>"></td>
					<td style="text-align: left;">
						<strong>
							<a class="hover" href="../product/detail.jsp?no=<%=item.getProductNo() %>"><%=item.getProductName() %></a>
						</strong>
						<pre>[옵션: <%=item.getColor() %>/<%=item.getSize() %>]</pre>
					</td>
					<td><%=item.getOrderProductQuantity() %></td>
					<td><strong><%=productPrice %>원</strong></td>
					<td><%=item.getStatus() %>
						<button class="btn btn-dark btn-sm opacity-75 m-1" <%="주문완료".equals(item.getStatus())? "" : "disabled" %>>구매후기</button>
					</td>
				</tr>
<%
		}
%>
			</tbody>
		</table>
	</div>
	<!-- pagination -->
	<div class="row my-5">
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
					<li class="page-item <%=pagination.getPageNo() == i ? "active" : "" %>"><a class="page-link" href="orderList.jsp?pageNo=<%=i %>&subMenu=<%=subMenu %>&startDate=<%=startDate %>&endDate=<%=endDate %>"><%=i %></a></li>
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
<%
	}
%>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	
</script>
</body>
</html>