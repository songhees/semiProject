<%@page import="java.text.DecimalFormat"%>
<%@page import="semi.vo.Pagination"%>
<%@page import="semi.vo.Point"%>
<%@page import="java.util.List"%>
<%@page import="semi.dao.PointDao"%>
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
	a.orderDetail:hover {
		color: #d9d7d7;
	}
	li.breadcrumb-item, .breadcrumb-item a, a.nav-link, a.hover, li.breadcrumb-item a:hover, a.orderDetail {
		text-decoration: none;
		color: #757575;
		font-size: 14px;
	}
	
	table#vintable thead {
    	font-weight: lighter;
    	background-color: #fbfafa;
	}
	table#vintable tr {
		border-top: 1px solid #e3e3e3;
		border-bottom: 1px solid #e3e3e3;
	}
	table#vintable {
	    text-align: center;
		width: 100%;
		margin: auto;
	}
	th, td {
		padding: 11px 0 10px;
		color: #757575;
		font-size: 13px;
	}
	td {
		padding: 15px 0 15px 0;
	}
	button.button, a.button  {
		padding: 9px 3px;
		border-radius: 0;
		width: 100px;
		height: 35px;
		font-size: 11px;
	}
	
	#guidance h4, #guidance li, p {
		color: #707070;
		font-size: 12px;
	}
	div h3 {
		font-weight: bold;
		font-size: 13px;
	}
	a.small, button.small {
		font-size: 11px;
		width: 40px;
		border: 1px solid #e3e3e3;
		color: #757575;
		border-radius: 0;
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
	ul.point {
		 padding-left: 0;
	}
	strong.data {
		text-align: right;
		float: right;
	    width: 47%;
	    padding: 0 10px;
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
<%@ include file="../../common/navbar.jsp" %>
<%
	/* 로그인 없이 이 페이지에 접근하는 경우 */
 	if (loginUserInfo == null) {
		response.sendRedirect("../../loginform.jsp");		
		return;
	}

	String pageNo = request.getParameter("pageNo");
	PointDao pointDao = PointDao.getInstance();
	
	int totalRecord = pointDao.getTotalRecords(loginUserInfo.getNo());
	Pagination pagination = new Pagination(pageNo, totalRecord, 10, 5);
	
	List<Point> pointList = pointDao.getPointHistory(loginUserInfo.getNo(), pagination.getBegin(), pagination.getEnd());
	DecimalFormat df = new DecimalFormat("##,###");
%>
<div class="container">    
	<div class="row">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<div>
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
				  <ol class="breadcrumb justify-content-end">
				    <li class="breadcrumb-item"><a href="../../index.jsp">HOME</a></li>
				    <li class="breadcrumb-item"><a href="../mypage.jsp">MY PAGE</a></li>
				    <li class="breadcrumb-item active" aria-current="page" style="font-weight: bold;">POINT</li>
				  </ol>
				</nav>
			</div>
			<!-- 제목 -->
			<div class="text-center my-5">
				<h5><strong>POINT</strong></h5>
				<p>고객님의 사용가능 적립금 금액 입니다.</p>
			</div>
		</div>
	</div>
	<div class="row mb-4">
		<div class="col">
			<ul class="point">
				<li class="title"><span>총 적립금</span>
					<strong class="data text-end"><%=df.format(loginUserInfo.getPoint()) %>원</strong>
				</li>
				<li class="title"><span >고객 등급</span>
					<strong class="data"><%=loginUserInfo.getGradeCode() %></strong>
				</li>
			</ul>
		</div>
	</div>
<%
	if (pointList.isEmpty()) {
%>
	<div class="text-center m-5">
		<p style="font-size: 14px; color: #707070;">포인트 내역이 없습니다.</p>
	</div>
<%
	} else {
%>
	<div class="row mt-5">
		<div class="col">
			<form action="addressDelete.jsp" method="get">
				<table id="vintable">
					<colgroup>
						<col width="18%">
						<col width="15%">
						<col width="18%">
						<col width="*%">
					</colgroup>
					<thead>
						<tr>
							<th>주문날짜</th>
							<th>관련주문</th>
							<th>적립금</th>
							<th>내용</th>
						</tr>
					</thead>
					<tbody>
<%
		for (Point point : pointList) {
%>
						<tr>
							<td><%=point.getCreatedDate() %></td>
<%
			if (point.getOrderNo() == 0) {
%>
							<td> </td>
<%
			} else {
				
%>
							<td><a class="orderDetail" href="../orderDetail.jsp?orderNo=<%=point.getOrderNo() %>"><%=point.getOrderNo() %></a></td>
<%
			}
			 if ("use".equals(point.getStatus())) {
%>
							<td>-<%=df.format(point.getPoint()) %>원</td>
							<td style="text-align: left;">상품구매시 사용한 적립금</td>
<%
			} else if ("add".equals(point.getStatus())){
%>
							<td><%=df.format(point.getPoint()) %>원</td>
							<td style="text-align: left;">구매에 대한 적립금</td>
<%
			} else {
%>
							<td><%=df.format(point.getPoint()) %>원</td>
							<td style="text-align: left;"><%=point.getStatus() %>에 대한 적립금</td>
						</tr>
<%
			}
		}
%>	
					</tbody>
				</table>
			</form>
		</div>
	</div>
	<!-- 이용안내 메세지 -->
	<div class="row my-5">
		<div class="col-6 offset-3">
			<nav aria-label="Page navigation example">
				<ul class="pagination justify-content-center">
					<li class="page-item <%=pagination.isExistPrev()? "" : "disabled" %>">
					    <a class="page-link" href="pointHistory.jsp?pageNo=<%=pagination.getPrevPage() %>" aria-label="Previous">
					    	<span aria-hidden="true">&laquo;</span>
					    </a>
				    </li>
	<%
		for (int i = pagination.getBeginPage() ; i <= pagination.getEndPage() ; i++) {
	%>				    
					<li class="page-item <%=pagination.getPageNo() == i ? "active" : "" %>">
						<a class="page-link" href="pointHistory.jsp?pageNo=<%=i %>"><%=i %></a>
					</li>
	<%
		}
	%>
				    <li class="page-item <%=pagination.isExistNext()? "" : "disabled" %>">
					    <a class="page-link" href="pointHistory.jsp?pageNo=<%=pagination.getNextPage() %>" aria-label="Next">
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
	<div id="guidance" class="my-5 border">
		<h3 class="border-bottom p-2" style="background-color: #fbfafa;">적립금 안내</h3>
		<div class="p-1">
			<ol>
				<li>주문으로 발생한 적립금은 배송완료 후 20일 부터 실제 사용 가능한 적립금으로 전환됩니다. 배송완료 시점으로부터 20일 동안은 미가용 적립금으로 분류됩니다.</li>
				<li>미가용 적립금은 반품, 구매취소 등을 대비한 임시 적립금으로 사용가능 적립금으로 전환되기까지 상품구매에 사용하실 수 없습니다.</li>
				<li>사용가능 적립금(총적립금 - 사용된적립금 - 미가용적립금)은 상품구매 시 바로 사용가능합니다.</li>
			</ol>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>