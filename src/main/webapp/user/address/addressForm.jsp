<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="java.util.List"%>
<%@page import="semi.vo.Address"%>
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
	
	.vintable tbody th, input[type=button]:hover {
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
	.vintable {
		line-height: 180%;
  		width: 100%;
  		margin: auto;
	} 
	.vintable + div button  {
		border-radius: 0;
		width: 96px;
		height: 40px;
		font-size: 11px;
		
	}
	.vintable + div a {
		padding-top: 11px;
		border-radius: 0;
		width: 96px;
		height: 40px;
		font-size: 11px;

	}
	
	th, td {
		padding: 11px 0 10px 18px;
		color: #757575;
		font-size: 13px;
	}
	
	input[type=text], input[type=password] {
		line-height: 20px;
    	padding: 6px 4px;
   		border: 1px solid #d5d5d5;
    	font-size: 13px;
    	width: 300px;
	}	
	input[id=postcode] {
		width: 80px;
	}
	
	input[id=address], input[id=detailAddress] {
		margin-top: 3px;
		width: 500px;
	}
	
	input[type=button] {
		border: 1px solid #757575;
	}
	
	#guidance h4, #guidance li, p, td[colspan] {
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
	int addressNo = NumberUtils.toInt(request.getParameter("no"), 0);
/* 로그인 없이 이 페이지에 접근하는 경우 */
/* 	if (loginUserInfo == null) {
		response.sendRedirect("loginform.jsp");		
		return;
	}
*/
	AddressDao addressDao = AddressDao.getInstance();
	Address address = addressDao.getAddressByNo(addressNo);

	/*
		if (loginUserInfo.getNo() != address.getUser().getNo()) {
			response.sendRedirect("index.jsp");		
			return;
		}
	 */
%>
<div class="container">    
	<div class="row mb-3">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
			  <ol class="breadcrumb justify-content-end">
			    <li class="breadcrumb-item"><a href="#">HOME</a></li>
			    <li class="breadcrumb-item"><a href="#">MY PAGE</a></li>
			    <li class="breadcrumb-item active" aria-current="page">ADDRESS BOOK</li>
			  </ol>
			</nav>
		</div>
	</div>
	<div class="row">
		<!-- 제목 -->
		<div class="col text-center mt-5">
			<h5><strong>ADDRESS BOOK</strong></h5>
			<p>자주 쓰는 배송지를 등록 관리하실 수 있습니다.</p>
		</div>
	</div>
	<div class="row">
		<!-- 주문정보 table -->
		<div class="col my-5">
			<form id="loginForm" action="register.jsp" method="post" onsubmit="checkInputField(event)">
				<input type="hidden" name="no" value="<%=addressNo %>">
				<table class="vintable">
					<tbody>
						<colgroup>
							<col width="13%">
							<col width="*">
						</colgroup>
						<tr>
							<th>배송지명 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
							<td><input type="text" name="addressName" id="name" value="<%=address!=null? address.getAddressName() : "" %>">
							<div class="form-text text-danger" style="display: none;" id="error-name">
								배송지명은 필수 입력항목입니다.
							</div>
							</td>
						</tr>
						<tr>
							<th>성명 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
							<td>
								<input type="text" name="name" id="userName" value="<%="오송희"  /*=loginUserInfo.getName */	%>" disabled readonly>
							</td>
						</tr>
						<tr>
							<th>주소 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
							<td>
								<input name="postcode" type="text" id="postcode" placeholder="우편번호" value="<%=address!=null? address.getPostalCode() : "" %>">
								<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
								<input name ="baseAddress" type="text" id="address" placeholder="주소" value="<%=address!=null? address.getBaseAddress() : "" %>"><br>
								<input name="addressDetail" type="text" id="detailAddress" placeholder="상세주소" value="<%=address!=null? address.getDetail() : "" %>">
								<div class="form-text text-danger" style="display: none;" id="error-address">
									주소은 필수 입력항목입니다.
								</div>
							</td>
						</tr>
						<tr class="text-end">
							<td class="p-1" colspan="2" style="border-left: none;">
								<input name="isDefault" class="m-1" type="checkbox" <%=address!=null? ("Y".equals(address.getAddressDefault()) ? "checked" : "") : "" %>>
								기본배송지로저장
							</td>
						</tr>
					</tbody>
				</table>
				<div class="text-end mt-2">
<%
	if (addressNo == 0) {
%>
					<button type="submit" class="btn btn-dark opacity-50">등록</button>
<%		
	} else {
%>
					<button type="submit" class="btn btn-dark opacity-50">수정</button>
<%		
	}
%>
					<a href="../../index.jsp" class="btn btn-outline-secondary" >취소</a>
				</div>
			</form>
		</div>
	</div>
	<!-- 이용안내 메세지 -->
	<div id="guidance" class="my-4 border">
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
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	function checkInputField(event) {
		event.preventDefault();
		var form = document.getElementById("loginForm");
		
		
		var name = document.getElementById("name").value
		var postcode = document.getElementById("postcode").value
		var address = document.getElementById("address").value
		var detail = document.getElementById("detailAddress").value
		
		var errorMessageName = document.getElementById("error-name")
		var errorMessageAddress = document.getElementById("error-address")
		
		errorMessageName.style.display = 'none'
		errorMessageAddress.style.display = 'none'
		
		var inValid = true
		if (name === '') {
			errorMessageName.style.display = ''
			inValid = false
		}
		
		if (postcode==='' || address==='' || detail==='') {
			errorMessageAddress.style.display = ''
			inValid = false
		}
		
		if (inValid) {
			form.submit
		}
	}
	
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("detailAddress").value = extraAddr;
                
                } else {
                    document.getElementById("detailAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }
</script>
</body>
</html>