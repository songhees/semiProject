<%@page import="semi.vo.Address"%>
<%@page import="semi.dao.AddressDao"%>
<%@page import="semi.dao.UserDao"%>
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
	
	input[type=text], input[type=password] {
		line-height: 20px;
    	padding: 6px 4px;
   		border: 1px solid #d5d5d5;
    	font-size: 13px;
    	width: 300px;
	}	
	input[name=userTel], input[id=postcode] {
		width: 80px;
	}
	
	input[id=address], input[id=detailAddress] {
		margin-top: 3px;
		width: 500px;
	}
	
	input[type=button] {
		border: 1px solid #757575;
	}
</style>
</head>

<body>
<%@ include file="../common/navbar.jsp" %>
<%
/* 로그인 없이 이 페이지에 접근하는 경우 */
/* 	if (loginUserInfo == null) {
		response.sendRedirect("loginform.jsp");		
		return;
	} */

	UserDao userDao = UserDao.getInstance();
	AddressDao addressDao = AddressDao.getInstance();
	
	/* login.jsp 완성시  loginUserInfo.getId() 넣기
		번호를얻어서 주소록을 조회한다.
	*/
	User userInfo = userDao.getUserById("osh");
	Address address = addressDao.getRepresentativeAddressByNo(userInfo.getNo());

	String[] tel = userInfo.getTel().split("-");
%>
<div class="container">
	<div class="row">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<div>
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
				  <ol class="breadcrumb justify-content-end">
				    <li class="breadcrumb-item"><a href="#">HOME</a></li>
				    <li class="breadcrumb-item active" aria-current="page">EDIT PROFILE</li>
				  </ol>
				</nav>
			</div>
			<!-- 제목 -->
			<div class="text-center mt-5">
				<h5><strong>EDIT PROFILE</strong></h5>
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
								<th>아이디</th>
								<td><input type="text" name="userId" value="<%=userInfo.getId() %>" readonly="readonly"><span class="px-1">(영문소문자/숫자, 4~16자)</span></td>
							</tr>
							<tr>
								<th>비밀번호 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td>
									<input maxlength="16" type="password" name="userPassword" id="userPassword">
									<span class="px-1" id="as">(영문 대소문자/숫자/특수문자 중 3가지 이상 조합, 8~16자)</span>
									<div class="form-text text-danger" style="display: none;" id="error-password">
										
									</div>
								</td>
							</tr>
							<tr>
								<th>비밀번호 확인 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td>
									<input type="password" id="comparedPassword">
									<div class="form-text text-danger" style="display: none;" id="error-password-same">
										비밀번호가 일치하지 않습니다.
									</div>
								</td>
							</tr>
							<tr>
								<th>이름</th>
								<td><input type="text" name="name" value="<%=userInfo.getName() %>" readonly="readonly"></td>
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<input name="postcode" type="text" id="postcode" placeholder="우편번호" value="<%=address != null? address.getPostalCode() : "" %>">
									<input type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
									<input name ="baseAddress" type="text" id="address" placeholder="주소" value="<%=address != null? address.getBaseAddress() : "" %>"><br>
									<input name="addressDetail" type="text" id="detailAddress" placeholder="상세주소" value="<%=address != null? address.getDetail() : "" %>">
								</td>
							</tr>
							<tr>
								<th>휴대전화 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input maxlength="3" type="text" name="userTel" value="<%=tel[0] %>">
									-
									<input maxlength="4" type="text" name="userTel" value="<%=tel[1] %>">
									-
									<input maxlength="4" type="text" name="userTel" value="<%=tel[2] %>">
									<div class="form-text text-danger" style="display: none;" id="error-tel">
										휴대전화 번호를 입력해주세요.
									</div>
								</td>
							</tr>
							<tr>
								<th>SMS 수신여부 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="radio" value="Y" name="smsSubscription" <%="Y".equals(userInfo.getSmsSubscription())? "checked" : "" %>> 수신함
									<input type="radio" value="N" name="smsSubscription" <%="N".equals(userInfo.getSmsSubscription())? "checked" : "" %>> 수신안함
									<div>
										쇼핑몰에서 제공하는 유익한 이벤트 소식을 SMS로 받으실 수 있습니다.
									</div>	
								</td>
							</tr>
							<tr>
								<th>이메일 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="text" name="userEmail" value="<%=userInfo.getEmail() %>" id="email">
									<div class="form-text text-danger" style="display: none;" id="error-email">
										이메일을 입력해 주세요.
									</div>
								</td>
							</tr>
							<tr>
								<th>이메일 수신여부 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="radio" value="Y" name="emailSubscription" <%="Y".equals(userInfo.getEmailSubscription())? "checked" : "" %>> 수신함
									<input type="radio" value="N" name="emailSubscription" <%="N".equals(userInfo.getEmailSubscription())? "checked" : "" %>> 수신안함
									<div>
										쇼핑몰에서 제공하는 유익한 이벤트 소식을 email로 받으실 수 있습니다.
									</div>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="row mt-2">
						<div class="col">
							<div class="row d-grid d-md-flex">
								<div class="offset-1 col-10 text-center">	
									<button class="btn btn-dark opacity-75" type="submit">회원정보수정</button>
									<a href="../index.jsp" class="btn btn-dark opacity-50">취소</a>
								</div>
								<div class="col-1">
									<button class="btn btn-outline-secondary btn-sm" style="width: 80px;" type="submit">회원탈퇴</button>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>    
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
	function checkInputField(event) {
		event.preventDefault();
		
		var loginForm = document.getElementById("loginForm");
		
		/* 오류 확인할 대상 */
		var comparedPwd = document.getElementById("comparedPassword").value;
		var inputEmail = document.getElementById("email").value;
		var inputTel = document.querySelectorAll("input[name=userTel]");
		
		var password = document.getElementById("userPassword");
		var inputPwd = password.value;
		
		/* 오류 메세지 */
		var errorMessagePwdByInput = document.getElementById("error-password");
		var errorMessagePwdBySame = document.getElementById("error-password-same");
		var errorMessageEmail = document.getElementById("error-email");
		var errorMessageTel = document.getElementById("error-tel");		
		
		var pattern1 = /[0-9]+/;
		var pattern2 = /[a-zA-Z]+/;
		var pattern3 = /[!_?#@~\-+*]+/;
		
		errorMessagePwdBySame.style.display = 'none';
		errorMessagePwdByInput.style.display = 'none';
		errorMessageEmail.style.display = 'none';
		errorMessageTel.style.display = 'none';
		
		var inValid = true;
		if (inputPwd === '') {
			errorMessagePwdByInput.textContent = '비밀번호를 입력해주세요.'
			errorMessagePwdByInput.style.display = '';
			inValid = false;
		} else if (inputPwd <= 7) {
			errorMessagePwdByInput.textContent = '최소 8글자 이상이어야 합니다.'
			errorMessagePwdByInput.style.display = '';
			inValid = false;			
		} else if (!pattern1.test(password) || !pattern2.test(password) || !pattern3.test(password)) {
			errorMessagePwdByInput.textContent = '비밀번호는 영문 대소문자, 숫자, 특수문자로 구성해야 합니다.'
			errorMessagePwdByInput.style.display = '';
			inValid = false;			
		}
		
		if (inputPwd !== comparedPwd) {
			errorMessagePwdBySame.style.display = '';
			inValid = false;
		}
		
		if (inputEmail === '') {
			errorMessageEmail.style.display = '';
			inValid = false;
		}
		
		for (var i=0; i<inputTel.length; i++) {
			if (inputTel[i].value === '') {
				errorMessageTel.style.display = '';
				inValid = false;
			}
		}
		
		if (inValid) {
			loginForm.submit();
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