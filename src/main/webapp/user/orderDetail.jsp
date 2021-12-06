<%@page import="java.text.DecimalFormat"%>
<%@page import="semi.dto.OrderItemDto"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="semi.dao.OrderDao"%>
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
	
	.vintable tbody th, #priceTable, table#vintable thead, tfoot {
    	font-weight: normal;
    	background-color: #fbfafa;
	}
	.vintable td {
 		border: 1px solid #ebebeb;
	    border-right: none;
	}	
	.vintable th{
 		border: 1px solid #ebebeb;
	    border-left: none;
	}
	.vintable, #priceTable {
		line-height: 180%;
  		width: 100%;
  		margin: auto;
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
	td img {
		width: 80px;
		height: 100px;
	}
	
	th, td {
		padding: 11px 0 10px 18px;
		color: #757575;
		font-size: 13px;
	}

	div h3 {
		font-weight: bold;
		font-size: 13px;
	}
	#priceTable {
		border: 1px solid black;
	}
	#priceTable th {
		border-right: 1px solid #e3e3e3;
	}
	td.price {
		color: black;
		font-size: 18px;
		font-weight: bold;
	}
	
	#guidance h4, #guidance li, #guidance p {
		color: #707070;
		font-size: 12px;
	}
	
	a.hover:hover {
		color: #d9d7d7;
	}
	a.hover {
		color: #363636;
	}
	
</style>
</head>
<body>
<%@ include file="../common/navbar.jsp" %>
<%
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));

	/* 로그인 없이 이 페이지에 접근하는 경우 */
	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	}
	
	OrderDao orderDao = OrderDao.getinstance();

	Map<String, Object> orderInfo = orderDao.getOrderInfo(loginUserInfo.getNo(), orderNo);
	List<OrderItemDto> orderItems = orderDao.getOrderItemDetail(orderNo);
	
	/* 상품가격으로 배송비여부 판단하기 */
	DecimalFormat df = new DecimalFormat("##,###");
	
	long totalPrice = (Long)orderInfo.get("totalPrice");
	int shippingFee = 0;
	
	if (totalPrice < 50000) {
		totalPrice += 3000;
		shippingFee = 3000;
	}
%>
<div class="container">    
	<!-- 브레드크럼 breadcrumb -->
	<div>
		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb justify-content-end">
		    <li class="breadcrumb-item"><a href="../index.jsp">HOME</a></li>
		    <li class="breadcrumb-item"><a href="mypage.jsp">MY PAGE</a></li>
		    <li class="breadcrumb-item active" aria-current="page">ORDER</li>
		  </ol>
		</nav>
	</div>
	<!-- header제목 -->
	<div class="text-center mt-5">
		<h5><strong>ORDER</strong></h5>
	</div>
	<!-- 주문 상세 정보 표 -->
	<!-- 주문정보 table -->
	<div class="my-5">
		<div>
			<h3>주문 정보</h3>
		</div>
		<div>
			<table class="vintable">
				<tbody>
					<colgroup>
						<col width="13%">
						<col width="*">
					</colgroup>
					<tr>
						<th>주문번호</th>
						<td><%=orderInfo.get("orderNo") %></td>
					</tr>
					<tr>
						<th>주문일자</th>
						<td><%=orderInfo.get("createdDate") %></td>
					</tr>
					<tr>
						<th>주문자</th>
						<td><%=orderInfo.get("userName") %></td>
					</tr>
					<tr>
						<th>주문처리상태</th>
						<td><%=orderInfo.get("status") %></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!-- 결제정보 table -->
	<div class="my-5">
		<div>
			<h3>결제 정보</h3>
		</div>
		<div>
			<table class="vintable">
				<tbody>
					<colgroup>
						<col width="13%">
						<col width="*">
					</colgroup>
					<tr>
						<th>총 주문금액</th>
						<td><%=df.format(orderInfo.get("totalPrice")) %>원</td>
					</tr>
				</tbody>
			</table>
			<table id="priceTable">
				<tbody>
					<colgroup>
						<col width="13%">
						<col width="*">
					</colgroup>
					<tr>
						<th>총 결재금액</th>
						<td class="price"><%=df.format(totalPrice) %><small>원</small></td>
					</tr>
					<tr style="border-top: 1px solid #e3e3e3;">
						<th>결제수단</th>
						<td class="bg-white"><%=orderInfo.get("paymentMethod") %></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!-- 주문 상품 정보 -->
	<div>
		<div>
			<h3>주문 상품 정보</h3>
		</div>
		<div>
			<table id="vintable">
				<colgroup>
					<col width="10%">
					<col width="*">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th>이미지</th>
						<th>상품정보</th>
						<th>수량</th>
						<th>판매가</th>
						<th>기본배송</th>
						<th>주문처리상태</th>
					</tr>
				</thead>
				<tbody>
<%
	for (OrderItemDto item : orderItems) {
		String itemPrice = df.format(item.getOrderProductPrice());
%>
					<tr>
						<td>
							<a href="../product/detail.jsp?no=<%=item.getProductNo() %>">
								<img src="../resources/images/product/<%=item.getProductNo() %>/thumbnail/<%=item.getThumbnailUrl() %>">
							</a>
						</td>
						<td style="text-align: left;">
							<strong>
								<a class="hover" href="../product/detail.jsp?no=<%=item.getProductNo() %>"><%=item.getProductName() %></a>
							</strong>
							<pre>[옵션: <%=item.getColor() %>/<%=item.getSize() %>]</pre>
						</td>
						<td><%=item.getOrderProductQuantity() %></td>
						<td><strong><%=itemPrice %>원</strong></td>
						<td>기본배송</td>
						<td><%=orderInfo.get("status") %></td>
					</tr>
<%
	}
%>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="6">
							<div class="d-flex justify-content-between p-2">
								<div>
									[기본배송]
								</div>
								<div>
									상품구매금액 <strong><%=df.format(orderInfo.get("totalPrice")) %></strong> + 배송비 <%=shippingFee %> = 합계 : 
									<strong class="px-3" style="font-size: 18px;"><%=df.format(totalPrice) %>원</strong>
								</div>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>
	<!-- 배송지 정보 table -->
	<div class="mt-5">
		<div>
			<h3>배송지정보</h3>
		</div>
		<div>
			<table class="vintable">
				<tbody>
					<colgroup>
						<col width="13%">
						<col width="*">
					</colgroup>
					<tr>
						<th>받으시는분</th>
						<td><%=orderInfo.get("userName") %></td>
					</tr>
					<tr>
						<th>우편번호</th>
						<td><%=orderInfo.get("postalCode") %></td>
					</tr>
					<tr>
						<th>주소</th>
						<td><%=((String)orderInfo.get("baseAddress") + " " + (String)orderInfo.get("addressDetail")) %></td>
					</tr>
					<tr>
						<th>휴대전화</th>
						<td><%=orderInfo.get("userTel") %></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="text-end mt-1">
		<a class="btn btn-dark btn-sm opacity-75 m-1" href="orderList.jsp">주문목록</a>
	</div>
	<!-- 이용안내 메세지 -->
	<div id="guidance" class="my-5 border">
		<h3 class="border-bottom p-3" style="background-color: #fbfafa;">이용안내</h3>
		<div class="p-3">
			<h4>신용카드매출전표 발행 안내</h4>
			<ul style="list-style:none;">
				<li>신용카드 결제는 사용하는 PG사 명의로 발행됩니다.</li>
			</ul>
			<h4>세금계산서 발행 안내</h4>
			<ol>
				<li>부가가치세법 제 54조에 의거하여 세금계산서는 배송완료일로부터 다음달 10일까지만 요청하실 수 있습니다.</li>
				<li>세금계산서는 사업자만 신청하실 수 있습니다.</li>
				<li>배송이 완료된 주문에 한하여 세금계산서 발행신청이 가능합니다.</li>
				<li>[세금계산서 신청]버튼을 눌러 세금계산서 신청양식을 작성한 후 팩스로 사업자등록증사본을 보내셔야 세금계산서 발생이 가능합니다.	</li>
				<li>[세금계산서 인쇄]버튼을 누르면 발행된 세금계산서를 인쇄하실 수 있습니다.</li>
				<li>세금계산서는 실결제금액에 대해서만 발행됩니다.(적립금과 할인금액은 세금계산서 금액에서 제외됨)</li>
			</ol>
			<h4>부가가치세법 변경에 따른 신용카드매출전표 및 세금계산서 변경 안내</h4>
			<ol>
				<li>변경된 부가가치세법에 의거, 2004.7.1 이후 신용카드로 결제하신 주문에 대해서는 세금계산서 발행이 불가하며
					신용카드매출전표로 부가가치세 신고를 하셔야 합니다.(부가가치세법 시행령 57조)</li>
				<li>상기 부가가치세법 변경내용에 따라 신용카드 이외의 결제건에 대해서만 세금계산서 발행이 가능함을 양지하여 주시기 바랍니다.</li>
			</ol>
			<h4>현금영수증 이용안내</h4>
			<ol>
				<li>현금영수증은 1원 이상의 현금성거래(무통장입금, 실시간계좌이체, 에스크로, 예치금)에 대해 발행이 됩니다.</li>
				<li>현금영수증 발행 금액에는 배송비는 포함되고, 적립금사용액은 포함되지 않습니다.</li>
				<li>발행신청 기간제한 현금영수증은 입금확인일로 부터 48시간안에 발행을 해야 합니다.</li>
				<li>현금영수증 발행 취소의 경우는 시간 제한이 없습니다. (국세청의 정책에 따라 변경 될 수 있습니다.)</li>
				<li>현금영수증이나 세금계산서 중 하나만 발행 가능 합니다.</li>
			</ol>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>