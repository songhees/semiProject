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
		width: 120px;
		height: 40px;
		font-size: 11px;
		
	}
	.vintable + div a {
		padding-top: 11px;
		border-radius: 0;
		width: 120px;
		height: 40px;
		font-size: 11px;

	}
	
	th, td {
		padding: 11px 0 10px 18px;
		color: #757575;
		font-size: 13px;
	}
</style>
</head>
<body>
<%@ include file="../common/navbar.jsp" %>
<%
	int addressNo = Integer.parseInt(request.getParameter("no"));
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
			</div>
			<!-- 주문정보 table -->
			<div class="my-5">
				<form id="loginForm" action="modify.jsp" method="post" onsubmit="checkInputField(event)">
					<table class="vintable">
						<tbody>
							<colgroup>
								<col width="13%">
								<col width="*">
							</colgroup>
							<tr>
								<th>배송지명 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="text" name="addressName" value="<%=address.getName() %>"></td>
							</tr>
							<tr>
								<th>성명 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td>
									<input type="text" name="name" id="userName" value="<%="오송희"  /*=loginUserInfo.getName */	%>" disabled readonly>
									<div class="form-text text-danger" style="display: none;" id="error-password">
										
									</div>
								</td>
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<input name="postcode" type="text" id="postcode" placeholder="우편번호" value="<%=address.getPostalCode() %>">
									<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
									<input name ="baseAddress" type="text" id="address" placeholder="주소" value="<%=address.getBaseAddress() %>"><br>
									<input name="addressDetail" type="text" id="detailAddress" placeholder="상세주소" value="<%=address.getDetail() %>">
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
		</div>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
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