<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="semi.dto.CartItemDto"%>
<%@page import="semi.dao.CartDao"%>
<%@page import="java.text.DecimalFormat"%>
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
	li.breadcrumb-item, .breadcrumb-item a, a.nav-link, a.hover {
		text-decoration: none;
		color: #757575;
		font-size: 14px;
	}
	
	div.point strong, div.point a {
		font-size: 12px;
		text-decoration: none;
		color: #404040;
	}
	
	div.point {	
		border: 1px solid #ebebeb;
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
	
	table.vinc td a {
		border-radius: 0;
		width: 90px;
		height: 24px;
		font-size: 11px;
	}
	
	tfoot {
    	font-weight: normal;
    	background-color: #fbfafa;
	}
	
	.d-grid div button  {
		border-radius: 0;
		width: 120px;
		height: 50px;
		font-size: 12px;
		
	}
	.d-grid div a {
		padding-top: 15px;
		border-radius: 0;
		width: 120px;
		height: 50px;
		font-size: 12px;
	}
	
	#guidance h4, #guidance li, #guidance p {
		color: #707070;
		font-size: 12px;
	}
	
	div h3 {
		font-weight: bold;
		font-size: 13px;
	}
</style>
</head>
<body>
<%@ include file="../../common/navbar.jsp" %>
<%
/* 로그인 없이 이 페이지에 접근하는 경우 */
/* 	if (loginUserInfo == null) {
	response.sendRedirect("loginform.jsp");		
	return;
	} */
	CartDao cartDao = CartDao.getInstance();
	/* 10000 -> loginUserInfo.getNo() */
	List<CartItemDto> itemList = cartDao.getCartItemList(10000); 
			
	DecimalFormat df = new DecimalFormat("##,###");

%>
<div class="container">    
		<!-- 브레드크럼 breadcrumb -->
	<div>
		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb justify-content-end">
		    <li class="breadcrumb-item"><a href="../../index.jsp">HOME</a></li>
		    <li class="breadcrumb-item active" aria-current="page">CART</li>
		  </ol>
		</nav>
	</div>
	<!-- 제목 -->
	<div class="text-center my-5">
		<h5><strong>CART</strong></h5>
	</div>
<%
	if (itemList.isEmpty()) {
%>
	<div>
		장바구니가 비어있습니다.
	</div>
<%
	} else {
%>
	<div class="row mb-5">
		<div class="col">
			<div class="point p-3">
				<strong class="px-3">혜택정보</strong>
				<a class="px-5" href="#<%-- 포인트 적립금액 리스트 페이지와 연결 --%>">가용적립금: <%-- <%=df.format(loginUserInfo.getPoint()) %> --%>원</a>
			</div>
		</div>
	</div>
	<div>
		<form action="<%--주문하는 페이지로 이동--%>" method="post">
			<table class="vinc">
				<colgroup>
					<col width="1%">
					<col width="8%">
					<col width="*%">
					<col width="10%">
					<col width="8%">
					<col width="5%">
					<col width="10%">
					<col width="6%">
					<col width="10%">
					<col width="8%">
				</colgroup>
				<thead  style="border-top: 1px solid #e3e3e3; background-color: #fbfafa;">
					<tr>
						<th><input type="checkbox" id="checkeAll" onchange="toggleCheckbox()"></th>
						<th>이미지</th>
						<th>상품정보</th>
						<th>판매가</th>
						<th>수량</th>
						<th>적립금</th>
						<th>배송구분</th>
						<th>배송비</th>
						<th>합계</th>
						<th>선택</th>
					</tr>
				</thead>
				<tbody>
<%
		int index = 0;
		int shippingFee = 0;
		long totalPrice = 0;
		for (CartItemDto item : itemList) {
			long productPrice = 0;
			index++;
			
			if (item.getDiscountFrom() != null && item.getDiscountTo() != null) {
				long now = System.currentTimeMillis();
				
				if (item.getDiscountFrom().getTime() <= now && now <= item.getDiscountTo().getTime()) {
					productPrice = item.getDiscountPrice();
				} else {
					productPrice = item.getPrice();
				}
				
			} else {
				productPrice = item.getPrice();
			}
			totalPrice += productPrice;
%>
					<tr>
						<td>
							<input type="checkbox" name="isChecked" id="check">
						</td>
						<td><img alt="" src="../../resources/images/product/<%=item.getProductNo() %>/thumbnail/<%=item.getThumbnailUrl() %>"></td>
						<td style="text-align: left;">
							<input type="hidden" name="item" value="<%=item.getProductItemNo() %>">
							<strong>
								<a class="hover" href="../../product/detail.jsp?no=<%=item.getProductNo() %>"><%=item.getName() %></a>
							</strong>
							<pre>[옵션: <%=item.getColor() %>/<%=item.getSize() %>]</pre>
						</td>
						<td><strong><%=productPrice %>원</strong></td>
						<td><input type="hidden" name="quantity" value="<%=item.getQuantity() %>"><%=item.getQuantity() %></td>
						<td><input type="hidden" name="point" value="<%=productPrice/100 %>"><strong><%=productPrice/100 %>원</strong></td>
						<td>기본배송</td>
<%
			if (index == itemList.size()) {
				if (totalPrice >= 50000) {
					shippingFee = 0;
				} else {
					shippingFee = 3000;
				}
				
%>
						<td rowspan="<%=-(itemList.size()) %>">
							<%=shippingFee %>
						</td>
<%
			} else {
%>
						<td style="display: none;"></td>
<%				
			}
%>
						<td><input type="hidden" name="price" value="<%=productPrice*item.getQuantity() %>"><strong><%=productPrice*item.getQuantity() %>원</strong></td>
						<td>
							<a class="btn btn-dark btn-sm opacity-75 m-1 <%="Y".equals(item.getOnSale()) ?  "" : "disabled" %>" href="#<%-- 주문페이지 이동 --%>">주문하기</a>
							<a class="btn btn-outline-dark btn-sm opacity-75" href="delete.jsp">삭제</a>
						</td>
					</tr>
<%			
		}
		
%>

				</tbody>
				<tfoot>
					<tr>
						<td colspan="10">
							<div class="d-flex justify-content-between p-2">
								<div>
									[기본배송]
								</div>
								<div>
									<input type="hidden" name="totalPrice" value="<%=totalPrice %>">
									<input type="hidden" name="shippingFee" value="<%=shippingFee %>">
									상품구매금액 <strong><%=totalPrice %></strong> + 배송비 <%=shippingFee %> = 합계 : 
									<strong class="px-3" style="font-size: 18px;"><%=shippingFee+totalPrice %>원</strong>
								</div>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
			<div class="row mt-2">
				<div class="col">
					<div class="row d-grid d-md-flex">
						<div class="offset-1 col-9 text-center">	
							<button class="btn btn-dark opacity-75" type="submit">전체상품주문</button>
							<a href="../index.jsp" class="btn btn-dark opacity-50">선택상품주문</a>
						</div>
						<div class="col-2">
							<a class="btn btn-outline-secondary btn-sm" href="../../index.jsp">쇼핑계속하기</a>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
<%
	}
%>
	<!-- 이용안내 메세지 -->
	<div id="guidance" class="my-5 border">
		<h3 class="border-bottom p-3" style="background-color: #fbfafa;">이용안내</h3>
		<div class="p-3">
			<h4>장바구니 이용안내</h4>
			<ol>
				<li>선택하신 상품의 수량을 변경하시려면 수량변경 후 [변경] 버튼을 누르시면 됩니다.</li>
				<li>[쇼핑계속하기] 버튼을 누르시면 쇼핑을 계속 하실 수 있습니다.</li>
			</ol>
			<h4>무이자할부 이용안내</h4>
			<ol>
				<li>상품별 무이자할부 혜택을 받으시려면 무이자할부 상품만 선택하여 [주문하기] 버튼을 눌러 주문/결제 하시면 됩니다.</li>
				<li>[전체 상품 주문] 버튼을 누르시면 장바구니의 구분없이 선택된 모든 상품에 대한 주문/결제가 이루어집니다.</li>
				<li>단, 전체 상품을 주문/결제하실 경우, 상품별 무이자할부 혜택을 받으실 수 없습니다.</li>
				<li>무이자할부 상품은 장바구니에서 별도 무이자할부 상품 영역에 표시되어, 무이자할부 상품 기준으로 배송비가 표시됩니다.
					<br>실제 배송비는 함께 주문하는 상품에 따라 적용되오니 주문서 하단의 배송비 정보를 참고해주시기 바랍니다.</li>
			</ol>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>