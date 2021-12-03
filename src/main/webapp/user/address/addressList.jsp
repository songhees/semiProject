<%@page import="semi.vo.Address"%>
<%@page import="java.util.List"%>
<%@page import="semi.dao.AddressDao"%>
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
	String error = request.getParameter("error");

	AddressDao addressDao = AddressDao.getInstance();
/* 검색 조건 */
/* login.jsp 완성시  loginUserInfo.getNo() 넣기*/
	List<Address> addressList = addressDao.getAllAddressByUserNo(10000);
	StringBuffer str = new StringBuffer();
%>
<div class="container">    
<%
	/* 경고창구현하기 */
	if ("deny-delete".equals(error)) {
%>
		<div class="alert alert-danger">
			<small>사용자가 다른 주소록 입니다.</small>
		</div>
<%
	}
%>
	<div class="row">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<div>
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
				  <ol class="breadcrumb justify-content-end">
				    <li class="breadcrumb-item"><a href="#">HOME</a></li>
				    <li class="breadcrumb-item"><a href="#">MY PAGE</a></li>
				    <li class="breadcrumb-item active" aria-current="page">ADDRESS BOOK</li>
				  </ol>
				</nav>
			</div>
			<!-- 제목 -->
			<div class="text-center mt-5">
				<h5><strong>ADDRESS BOOK</strong></h5>
				<p>자주 쓰는 배송지를 등록 관리하실 수 있습니다.</p>
			</div>
		</div>
	</div>	
	<div class="row mt-5">
		<div class="col">
			<form action="addressDelete.jsp" method="get">
				<table id="vintable">
					<colgroup>
						<col width="2%">
						<col width="10%">
						<col width="10%">
						<col width="10%">
						<col width="*%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="ck-all" onchange="toggleCheckbox()"></th>
							<th>기본 주소</th>
							<th>배송지명</th>
							<th>수령인</th>
							<th>주소</th>
							<th>수정</th>
						</tr>
					</thead>
					<tbody>
<%
	for (Address address : addressList) {
%>
						<tr>
							<td><input type="checkbox" name="no" value="<%=address.getAddressNo() %>" id="ck"></td>
<%
		if ("Y".equals(address.getAddressDefault())) {
%>
							<td><a class="small btn btn-sm" href="default.jsp?menu=release&no=<%=address.getAddressNo() %>">해제</a></td>
<%
		} else {
%>
							<td><a class="small btn btn-sm btn-secondary" href="default.jsp?menu=fix&no=<%=address.getAddressNo() %>" style="color: white;">고정</a></td>
<%
		}
%>
							<td><%=address.getAddressName() %></td>
							<td><%="오송희" /*=loginUserInfo.getName  */ %></td>
							<td class="text-start"><%=str.append("(").append(address.getPostalCode()).append(")").append(address.getBaseAddress()).append(" ").append(address.getDetail()) %></td>
							<td><a class="small btn btn-sm" href="addressForm.jsp?no=<%=address.getAddressNo() %>">수정</a></td>
						</tr>
	<%
			str.setLength(0);
		}
	%>
					</tbody>
				</table>
				<div class="row mt-2">
					<div class="col">
						<button class="button btn btn-outline-dark" >선택 주소록 삭제</button>
					</div>
					<div class="col text-end">
						<a href="addressForm.jsp" class="button btn btn-dark opacity-75">배송지 등록</a>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- 이용안내 메세지 -->
	<div id="guidance" class="my-5 border">
		<h3 class="border-bottom p-2" style="background-color: #fbfafa;">배송주소록 유의사항</h3>
		<div class="p-1">
			<ol>
				<li>배송 주소록은 최대 10개까지 등록할 수 있으며, 별도로 등록하지 않을 경우 최근 배송 주소록 기준으로 자동 업데이트 됩니다.</li>
				<li>자동 업데이트를 원하지 않을 경우 주소록 고정 선택을 선택하시면 선택된 주소록은 업데이트 대상에서 제외됩니다.</li>
				<li>기본 배송지는 1개만 저장됩니다. 다른 배송지를 기본 배송지로 설정하시면 기본 배송지가 변경됩니다.</li>
			</ol>
		</div>
	</div>	
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	function toggleCheckbox() {
		var checkBoxAll = document.querySelector("#ck-all")
		var checkBoxes = document.querySelectorAll("#vintable tbody input[name=no]")
		
		for (var i=0; i<checkBoxes.length; i++) {
			
			var checkBox = checkBoxes[i];
			checkBox.checked = checkBoxAll.checked;
		}
	}
</script>
</body>
</html>