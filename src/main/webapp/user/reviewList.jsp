<%@page import="semi.dto.ReviewDto"%>
<%@page import="semi.vo.Review"%>
<%@page import="java.util.List"%>
<%@page import="semi.dao.ReviewDao"%>
<%@page import="semi.vo.Pagination"%>
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
	div.review-rate li {
		display: inline;
	}
	div.review-rate a{
		text-decoration: none;
		color: black;
		font-weight: bold;
	}
	div.review-rate img[alt=상품사진] {
		margin-right: 20px;
		float: left;
		width: 90px;
		height: 90px;
	}
	img[alt^=star] {
		width: 12px;
		padding-bottom: 5px;
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
	span.deletebutton {
		float: right;
	}
	span button.btn {
		border-radius: 0;
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

	String pageNo = request.getParameter("no");
	
%>
<div class="container">    
	<div class="row">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<div>
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
				  <ol class="breadcrumb justify-content-end">
				    <li class="breadcrumb-item"><a href="../index.jsp">HOME</a></li>
				    <li class="breadcrumb-item"><a href="mypage.jsp">MY PAGE</a></li>
				    <li class="breadcrumb-item active" aria-current="page" style="font-weight: bold;">BOARD LIST</li>
				  </ol>
				</nav>
			</div>
			<!-- 제목 -->
			<div class="text-center my-5">
				<h5><strong>BOARD LIST</strong></h5>
			</div>
		</div>
	</div>
<%
	String reviewPageNo = request.getParameter("reviewPageNo");
	ReviewDao reviewDao = ReviewDao.getInstance();
	int reviewTotalRecords = reviewDao.getTotalRecordsByUserNo(loginUserInfo.getNo());
	Pagination pagination = new Pagination(reviewPageNo, reviewTotalRecords, 5, 5);
	List<ReviewDto> reviewList = reviewDao.getReviewListByUserNo(loginUserInfo.getNo(), pagination.getBegin(), pagination.getEnd());
%>
	<div class="row">
		<div class="col">
			<table class="table" style="border-top: 1px solid #e3e3e3;">
<%
	if (reviewList.isEmpty()) {
%>
				<tr>
					<td class="text-center py-5">게시글이 존재하지 않습니다.</td>
				</tr>
<%
	} else {
		for (ReviewDto review : reviewList) {
%>
				<tr class="review-<%=review.getNo() %>">
					<td rowspan="3" style="width: 70%;">
						<div class="review-rate py-2">
							<img alt="상품사진" src="../resources/images/product/<%=review.getProductNo() %>/thumbnail/<%=review.getThumbnailUrl() %>">
							<a href="../product/detail.jsp?no=<%=review.getProductNo()%>#review"><%=review.getProductName() %></a>
							<ul class="thumb_img p-0 my-1" style="list-style: none">
<%
			switch (review.getRate()) {
				case 5: 
%>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li>-아주 좋아요</li>
<%
					break;
				case 4:
%>
						
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li>-맘에 들어요</li>

<%
					break;
				case 3:
%>

								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li>-보통이에요</li>

<%
					break;
				case 2:
%>

								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li>-그냥 그래요</li>

<%
					break;
				default:
%>

								<li><img alt="star1" src="../resources/images/review/rate_star/star1.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li><img alt="star1" src="../resources/images/review/rate_star/star0.png"></li>
								<li>-별로에요</li>

<%
					break;
			}
%>
							</ul>
						</div>
						<div class="review-rate" style="display: inline-block; width: 730px; height: 40px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
							<%=review.getContent() %>
						</div>
					</td>
				</tr>
				<tr class="review-<%=review.getNo() %>">
					<td>
						<p class="mb-0" style="display: inline-block;">작성일</p>
						<span class="deletebutton">
							<button type="button" class="btn btn-dark btn-sm opacity-75 mt-1" onclick="deleteItem(<%=review.getNo() %>)">삭제</button>
						</span>
						<div class="fw-bold"><%=review.getCreatedDate() %></div>
					</td>
				</tr>
				<tr class="review-<%=review.getNo() %>">
					<td>
						<p class="mb-0">작성자 등급</p>
						<span class="fw-bold"><%=loginUserInfo.getGradeCode() %></span>
					</td>
				</tr>
<%
		}
%>
			</table>
		</div>
	</div>
	<div class="row mb-3">
		<div class="col-6 offset-3">
			<nav>
				<ul class="pagination justify-content-center">
					<!-- 
						Pagination객체가 제공하는 isExistPrev()는 이전 블록이 존재하는 경우 true를 반환한다.
						Pagination객체가 제공하는 getPrevPage()는 이전 블록의 마지막 페이지값을 반환한다.
					 -->
					<li class="page-item <%=!pagination.isExistPrev() ? "disabled" : "" %>">
						<a class="page-link" href="reviewList.jsp?reviewPageNo=<%=pagination.getPrevPage()%>" >
							<span aria-hidden="true">&laquo;</span>
						</a>
					</li>
<%
	// Pagination 객체로부터 해당 페이지 블록의 시작 페이지번호와 끝 페이지번호만큼 페이지내비게이션 정보를 표시한다.
		for (int num = pagination.getBeginPage(); num <= pagination.getEndPage(); num++) {
%>					
				<li class="page-item <%=pagination.getPageNo() == num ? "active" : "" %>"><a class="page-link" href="reviewList.jsp?reviewPageNo=<%=num%>"><%=num %></a></li>
<%
		}
%>					
					<!-- 
						Pagination객체가 제공하는 isExistNext()는 다음 블록이 존재하는 경우 true를 반환한다.
						Pagination객체가 제공하는 getNexPage()는 다음 블록의 첫 페이지값을 반환한다.
					 -->
					<li class="page-item <%=!pagination.isExistNext() ? "disabled" :"" %>">
						<a class="page-link" href="reviewList.jsp?reviewPageNo=<%=pagination.getNextPage()%>" >
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
	function deleteItem(no) {
		var deletedreview = document.querySelectorAll(".review-" + no);

		for (var i=0; i< deletedreview.length; i++) {
			deletedreview[i].remove();
		}
		location.href = "deleteReview.jsp?no=" + no;
	}
</script>
</body>
</html>