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
    <title>빈스데이</title>
<style type="text/css">
	li.breadcrumb-item, .breadcrumb-item a, a.nav-link, a.hover, li.breadcrumb-item a:hover {
		text-decoration: none;
		color: #757575;
		font-size: 14px;
	}
	
	.vintable tbody th, input#findAddress {
    	font-weight: normal;
    	background-color: #fbfafa;
	}
	input[name=userId], input[name=name] {
		background-color: #fff7f7;
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
	
	div.modal-body h3 {
		color: #212529;
		font-size: 14px;
		font-weight: bold;
	}
	div.modal-body p, div.modal-content small {
		color: #212529;
	 	padding: 0 0 0 18px;
		font-size: 13px;
	}
	div.modal-content {
		border-radius: 0;
	}
	div.modal-content input[type=text] {
		display: inline;
		border-radius: 0;
		line-height: 15px;
		background-color: white;
	}
	input#findAddress {
		background-color: white;
	}
	div.alert-danger {
		line-height: 9px;
		border-radius: 0;
		font-size: 11px;
	}
</style>
</head>
<body>
<%@ include file="../common/navbar.jsp" %>
<%
	/* 로그인 없이 이 페이지에 접근하는 경우 */
	if (loginUserInfo == null) {
		response.sendRedirect("../loginform.jsp");		
		return;
	}
	String error = request.getParameter("error");
	
	AddressDao addressDao = AddressDao.getInstance();
	Address address = addressDao.getRepresentativeAddressByUserNo(loginUserInfo.getNo());

	String[] tel = loginUserInfo.getTel().split("-");
%>
<div class="container">
	<div class="row">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<div>
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
				  <ol class="breadcrumb justify-content-end">
				    <li class="breadcrumb-item"><a href="../index.jsp">HOME</a></li>
				    <li class="breadcrumb-item active" aria-current="page" style="font-weight: bold;">EDIT PROFILE</li>
				  </ol>
				</nav>
			</div>
<%
	if ("email-exists".equals(error)) {				
%>
				<div class="alert alert-danger">
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
					<span class="px-4">이미 존재하는 이메일 입니다.</span>
				</div>
<%		
	} else if("tel-exists".equals(error)) {		
		%>
				<div class="alert alert-danger">
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
					<span>이미 존재하는 전화번호 입니다.</span>
				</div>
<%
	} 
%>	
			<!-- 제목 -->
			<div class="text-center mt-5">
				<h5><strong>EDIT PROFILE</strong></h5>
			</div>
			<!-- 주문정보 table -->
			<div class="my-5">
				<form id="modifyForm" action="modify.jsp" method="post" onsubmit="checkInputField(event)">
					<table class="vintable">
						<tbody>
							<colgroup>
								<col width="13%">
								<col width="*">
							</colgroup>
							<tr>
								<th>아이디</th>
								<td><input type="text" name="userId" value="<%=loginUserInfo.getId() %>" readonly="readonly">
									<span class="px-1">(영문소문자/숫자, 4~16자)</span>
								</td>
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
									<input maxlength="16" type="password" id="comparedPassword">
									<div class="form-text text-danger" style="display: none;" id="error-password-same">
										비밀번호가 일치하지 않습니다.
									</div>
								</td>
							</tr>
							<tr>
								<th>이름</th>
								<td><input type="text" name="name" value="<%=loginUserInfo.getName() %>" readonly="readonly"></td>
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<input name="postcode" type="text" id="postcode" placeholder="우편번호" value="<%=address != null? address.getPostalCode() : "" %>">
									<input type="button" id="findAddress" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
									<input name="baseAddress" type="text" id="address" placeholder="주소" value="<%=address != null? address.getBaseAddress() : "" %>"><br>
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
								<td><input type="radio" value="Y" name="smsSubscription" <%="Y".equals(loginUserInfo.getSmsSubscription())? "checked" : "" %>> 수신함
									<input type="radio" value="N" name="smsSubscription" <%="N".equals(loginUserInfo.getSmsSubscription())? "checked" : "" %>> 수신안함
									<div>
										쇼핑몰에서 제공하는 유익한 이벤트 소식을 SMS로 받으실 수 있습니다.
									</div>	
								</td>
							</tr>
							<tr>
								<th>이메일 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="text" name="userEmail" value="<%=loginUserInfo.getEmail() %>" id="email">
									<div class="form-text text-danger" style="display: none;" id="error-email">
										이메일을 입력해 주세요.
									</div>
								</td>
							</tr>
							<tr>
								<th>이메일 수신여부 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="radio" value="Y" name="emailSubscription" <%="Y".equals(loginUserInfo.getEmailSubscription())? "checked" : "" %>> 수신함
									<input type="radio" value="N" name="emailSubscription" <%="N".equals(loginUserInfo.getEmailSubscription())? "checked" : "" %>> 수신안함
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
									<button type="button" style="width: 80px;" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
  										회원탈퇴
									</button>
									<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
										<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
											<div class="modal-content">
												<div class="modal-header">
													<h5 class="modal-title" id="staticBackdropLabel">회원탈퇴</h5>
													<button type="button" class="btn-close" style="width: 50px;" data-bs-dismiss="modal" aria-label="Close"></button>
												</div>
												<div class="modal-body">
													<h3>탈퇴 후 회원정보가 모두 삭제됩니다.</h3>
													<p>메일주소, 핸드폰 번호/기타 연락처 등 회원정보가 모두 삭제되며, 삭제된 데이터는 복구되지 않습니다.</p>
													
													<h3>탈퇴 후에도 작성된 게시글은 그대로 남아 있습니다.</h3>
													<p>각 게시판에 등록한 게시물 및 댓글은 탈퇴 후에도 남아있습니다.
													 삭제를 원하시는 게시물은 탈퇴 전 반드시 삭제하시기 바랍니다.
													 (탈퇴 후에는 게시글 임의 삭제 요청을 받지 않습니다.)</p>
													<div class="text-center py-2" style="background-color: #fff7f7;">
 														<input type="checkbox" id="allAgree" name="allAgree">
														<p style="font-weight: bold; display: inline;">위의 안내 내용에 동의합니다.
 														안내사항을 모두 동의하며, <br>이의제기를 하지않습니다.</p> 
													</div>
													<div class="mt-3">
														<table class="vintable">
															<tbody>
																<colgroup>
																	<col width="25%">
																	<col width="*">
																</colgroup>
																<tr>
																	<th>아이디</th>
																	<td><input type="text" id="deleteId" name="id">
																		<div class="form-text text-danger" style="display: none;" id="error-id-same">
																			아이디가 일치하지 않습니다.
																		</div>
																	</td>
																</tr>
																<!-- <tr>
																	<th>비밀번호</th>
																	<td>
																		<input maxlength="16" type="password" name="userPassword" id="userPassword">
																		<div class="form-text text-danger" style="display: none;" id="error-password">
																			
																		</div>
																	</td>
																</tr>
																<tr>
																	<th>비밀번호 확인</th>
																	<td>
																		<input maxlength="16" type="password" id="comparedPassword">
																		<div class="form-text text-danger" style="display: none;" id="error-password-same">
																			비밀번호가 일치하지 않습니다.
																		</div>
																	</td>
																</tr> -->
															</tbody>
														</table>
													</div>
												</div>
												<div class="modal-footer">
													<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
													<button type="button" class="btn btn-outline-secondary" onclick="deleteUser('<%=loginUserInfo.getId()%>')">회원탈퇴</button>
												</div>
											</div>
										</div>
									</div>
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
		
		var modifyForm = document.getElementById("modifyForm");
		
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
			errorMessagePwdByInput.textContent = '비밀번호를 입력해주세요.';
			errorMessagePwdByInput.style.display = '';
			inValid = false;
		} else if (inputPwd.length <= 7) {
			errorMessagePwdByInput.textContent = '최소 8글자 이상이어야 합니다.';
			errorMessagePwdByInput.style.display = '';
			inValid = false;			
		} else if (!pattern1.test(inputPwd) || !pattern2.test(inputPwd) || !pattern3.test(inputPwd)) {
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
			modifyForm.submit();
		}
	}
	
 	function deleteUser(userId) {
		var isCheck = document.getElementById("allAgree");
 		var inputId = document.getElementById("deleteId").value;
 		var errorMessageId = document.getElementById("error-id-same");
 		
 		errorMessageId.style.display = 'none';
 		
 		var inValid = true;
 		if (!isCheck.checked) {
 			alert("동의하셔야 회원탈퇴가 진행됩니다.");
 			inValid = false;
 		}
 		if (inputId != userId) {
 			errorMessageId.style.display = '';
 			inValid = false;
 		}
 		if (inValid) {
			location.href = "delete.jsp";
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