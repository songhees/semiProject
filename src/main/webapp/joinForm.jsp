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
	li.breadcrumb-item, .breadcrumb-item a, a.nav-link, a.hover {
		text-decoration: none;
		color: #757575;
		font-size: 14px;
	}
	a[href]:hover {
		color: #d9d7d7;
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
	
	#agreeList h2 {
		font-size: 14px;
	}
	
	#agreeList h3, #agreeList span {
		font-size: 12px;
		display: inline;
	}
	
	div#agreeList {
		margin-top: 80px;
		background-color: #fbfafa;
		border: 1px solid #ebebeb;
	}
	
	#agreeList p {
		font-size: 12px;
		color: #757575;
		text-align: left;
	}
	
	#agreeList div.scroll {
		background-color: white;
		height: 150px;
		text-align: center;
		overflow: scroll; 
		border: 1px solid #d5d5d5; 
		padding: 20px;
	}
	
	input#allCheckdBox{
        font-size: 1em;
	    width: 1.25em; /* 너비 설정 */
	    height: 1.25em; /* 높이 설정 */
	    vertical-align: middle;
	}

</style>
</head>

<body>
<%@ include file="../common/navbar.jsp" %>
<div class="container">
	<div class="row">
		<div class="col">
			<!-- 브레드크럼 breadcrumb -->
			<div>
				<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
				  <ol class="breadcrumb justify-content-end">
				    <li class="breadcrumb-item"><a href="index.jsp">HOME</a></li>
				    <li class="breadcrumb-item active" aria-current="page">JOIN</li>
				  </ol>
				</nav>
			</div>
<%
	String error = request.getParameter("error");
	if ("id-exists".equals(error)) {	
%>
			<div class="alert alert-danger">
				<strong>회원가입 실패</strong> 다른 사용자가 사용중인 아이디입니다.
			</div>
<%
	} else if ("email-exists".equals(error)) {	
%>
			<div class="alert alert-danger">
				<strong>회원가입 실패</strong> 다른 사용자가 사용중인 이메일입니다.
			</div>
<%
	} else if ("tel-exists".equals(error)) {		
%>
			<div class="alert alert-danger">
				<strong>회원가입 실패</strong> 다른 사용자가 사용중인 전화번호입니다.
			</div>
<%
	}
%>
			<!-- 제목 -->
			<div class="text-center mt-5">
				<h5><strong>JOIN</strong></h5>
			</div>
			<!-- 주문정보 table -->
			<div class="my-5">
				<form id="joinForm" action="join.jsp" method="post" onsubmit="checkInputField(event)">
					<table class="vintable">
						<tbody>
							<colgroup>
								<col width="13%">
								<col width="*">
							</colgroup>
							<tr>
								<th>아이디 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input maxlength="16" type="text" name="userId" id="userId">
									<span class="px-1">(영문소문자/숫자, 4~16자)</span>
									<div class="form-text text-danger" style="display: none;" id="error-Id">
										
									</div>
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
									<input type="password" id="comparedPassword">
									<div class="form-text text-danger" style="display: none;" id="error-password-same">
										비밀번호가 일치하지 않습니다.
									</div>
								</td>
							</tr>
							<tr>
								<th>이름 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="text" name="name" id="name">
									<div class="form-text text-danger" style="display: none;" id="error-name">
										이름을 입력해 주세요.
									</div>
								</td>
							</tr>
							<tr>
								<th>휴대전화 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input maxlength="3" type="text" name="userTel">
									-
									<input maxlength="4" type="text" name="userTel">
									-
									<input maxlength="4" type="text" name="userTel">
									<div class="form-text text-danger" style="display: none;" id="error-tel">
										휴대전화 번호를 입력해주세요.
									</div>
								</td>
							</tr>
							<tr>
								<th>이메일 <img src="https://img.echosting.cafe24.com/skin/base/common/ico_required_blue.gif" alt="필수"></th>
								<td><input type="text" name="userEmail" value="" id="email">
									<div class="form-text text-danger" style="display: none;" id="error-email">
										이메일을 입력해 주세요.
									</div>
								</td>
							</tr>
						</tbody>
					</table>
					<div id="agreeList">
						<div class="border-bottom p-3">
							<input type="checkbox" id="allCheckdBox" onchange="toggleCheckbox()"> 
							<h2 style="display: inline;">이용약관 및 개인정보수집 및 이용, 쇼핑정보 수신(선택)에 모두 동의합니다.</h2>
						</div>
						<div class="border-bottom p-4">
							<h3>[필수] 이용약관 동의</h3>
							<div class="scroll">
								<p>제1조(목적)
						          이 약관은 빈스회사(전자상거래 사업자)가 운영하는 빈스데이 사이버 몰(이하 “몰”이라 한다)에서 제공하는 인터넷 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 사이버 몰과 이용자의 권리.의무 및 책임사항을 규정함을 목적으로 합니다.
						          ※「PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다.」
						        </p>
						        <p>
						              제2조(정의)
						          ① “몰”이란 빈스회사가 재화 또는 용역(이하 “재화 등”이라 함)을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 등을 거래할 수 있도록 설정한 가상의 영업장을 말하며, 아울러 사이버몰을 운영하는 사업자의 의미로도 사용합니다.
						          ② “이용자”란 “몰”에 접속하여 이 약관에 따라 “몰”이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.
						          ③ ‘회원’이라 함은 “몰”에 회원등록을 한 자로서, 계속적으로 “몰”이 제공하는 서비스를 이용할 수 있는 자를 말합니다.
            					</p>
            					<p>
						              제3조 (약관 등의 명시와 설명 및 개정)
						          ① “몰”은 이 약관의 내용과 상호 및 대표자 성명, 영업소 소재지 주소(소비자의 불만을 처리할 수 있는 곳의 주소를 포함), 전화번호.모사전송번호.전자우편주소, 사업자등록번호, 통신판매업 신고번호, 개인정보보호책임자등을 이용자가 쉽게 알 수 있도록 00 사이버몰의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.
						          ② “몰은 이용자가 약관에 동의하기에 앞서 약관에 정하여져 있는 내용 중 청약철회.배송책임.환불조건 등과 같은 중요한 내용을 이용자가 이해할 수 있도록 별도의 연결화면 또는 팝업화면 등을 제공하여 이용자의 확인을 구하여야 합니다.
						          ③ “몰”은 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및 전자거래기본법」, 「전자금융거래법」, 「전자서명법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매 등에 관한 법률」, 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
						          ④ “몰”이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 몰의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 “몰“은 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.
						          ⑤ “몰”이 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에 의한 개정약관의 공지기간 내에 “몰”에 송신하여 “몰”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.
						          ⑥ 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다.
						        </p>
							</div>
							<span>이용약관에 동의하십니까?</span>
							<input type="checkbox" class="agree">
							<span>동의함</span>
						</div>
						<div class="border-bottom p-4">
							<h3>[필수] 개인정보 수집 및 이용 동의</h3>
							<div class="scroll">
								<p> 1. 개인정보 수집목적 및 이용목적 </p>
								<p> 가. 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산</p>
								<p> 콘텐츠 제공 , 구매 및 요금 결제 , 물품배송 또는 청구지 등 발송 , 금융거래 본인 인증 및 금융 서비스</p>
								<p> 나. 회원 관리</p>
								<p>	회원제 서비스 이용에 따른 본인확인 , 개인 식별 , 불량회원의 부정 이용 방지와 비인가 사용 방지 , 가입 의사 확인 , 연령확인 , 만14세 미만 아동 개인정보 수집 시 법정 대리인 동의여부 확인, 불만처리 등 민원처리 , 고지사항 전달</p>
								<p>	2. 수집하는 개인정보 항목 : 이름 , 로그인ID , 비밀번호 , 이메일 , 14세미만 가입자의 경우 법정대리인의 정보</p>
								<p>	3. 개인정보의 보유기간 및 이용기간</p>
								<p>	원칙적으로, 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.</p>
								<p>	가. 회사 내부 방침에 의한 정보 보유 사유</p>
								<p>	o 부정거래 방지 및 쇼핑몰 운영방침에 따른 보관 : OO년</p>
								<p>	나. 관련 법령에 의한 정보보유 사유</p>
								<p>	o 계약 또는 청약철회 등에 관한 기록</p>
								<p>	-보존이유 : 전자상거래등에서의소비자보호에관한법률</p>
								<p>	-보존기간 : 5년</p>
								<p>	o 대금 결제 및 재화 등의 공급에 관한 기록</p>
								<p>	-보존이유: 전자상거래등에서의소비자보호에관한법률</p>
								<p>	-보존기간 : 5년</p>
								<p>	o 소비자 불만 또는 분쟁처리에 관한 기록</p>
								<p>	-보존이유 : 전자상거래등에서의소비자보호에관한법률</p>
								<p>	-보존기간 : 3년 </p>
								<p>	o 로그 기록 </p>
								<p>	-보존이유: 통신비밀보호법 </p>
								<p>	-보존기간 : 3개월 </p>
								<p>	※ 동의를 거부할 수 있으나 거부시 회원 가입이 불가능합니다. </p>
							</div>
							<span>개인정보 수집 및 이용에 동의하십니까? </span>
							<input type="checkbox" class="agree"><span>동의함</span>
						</div>
						<div class="border-bottom p-4">
							<h3>[선택] 쇼핑정보 수신 동의</h3>
							<div class="scroll">
								<p>
									할인쿠폰 및 혜택, 이벤트, 신상품 소식 등 쇼핑몰에서 제공하는 유익한 쇼핑정보를 SMS나 이메일로 받아보실 수 있습니다.
								</p>
								<p>
									단, 주문/거래 정보 및 주요 정책과 관련된 내용은 수신동의 여부와 관계없이 발송됩니다.
								</p>
								<p>
									선택 약관에 동의하지 않으셔도 회원가입은 가능하며, 회원가입 후 회원정보수정 페이지에서 언제든지 수신여부를 변경하실 수 있습니다.
								</p>
							</div>
							<div>
								<span>SMS 수신을 동의하십니까?</span>
								<input type="checkbox" name="smsSubscription"><span>동의함</span>
							</div>
							<div>
								<span>이메일 수신을 동의하십니까?</span>
								<input type="checkbox" name="emailSubscription"><span>동의함</span>
							</div>
						</div>
					</div>
					<div class="row mt-2">
						<div class="col">
							<div class="row d-grid d-md-flex">
								<div class="offset-1 col-10 text-center">	
									<button class="btn btn-dark opacity-75" style="border-radius: 0; font-size: small;" type="submit">회원가입</button>
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
	function toggleCheckbox() {
		var checkedAllBox = document.getElementById("allCheckdBox").checked;
		
		var checkBox = document.querySelectorAll("#agreeList input[type=checkbox]");

		for (var i=0; i<checkBox.length; i++) {
			checkBox[i].checked = checkedAllBox;
		}
	}
	
	function checkInputField(event) {
		event.preventDefault();
		
		var joinForm = document.getElementById("joinForm");
		
		/* 오류 확인할 대상 */
		var comparedPwd = document.getElementById("comparedPassword").value;
		var inputEmail = document.getElementById("email").value;
		var inputTel = document.querySelectorAll("input[name=userTel]");
		
		var name = document.getElementById("name").value;
		var userId = document.getElementById("userId");
		var password = document.getElementById("userPassword");
		var inputPwd = password.value;
		var inputId = userId.value;
		var isChecked = document.querySelectorAll("input.agree");
		
		/* 오류 메세지 */
		var errorMessageName = document.getElementById("error-name");
		var errorMessageIdByInput = document.getElementById("error-Id");
		var errorMessagePwdByInput = document.getElementById("error-password");
		var errorMessagePwdBySame = document.getElementById("error-password-same");
		var errorMessageEmail = document.getElementById("error-email");
		var errorMessageTel = document.getElementById("error-tel");		
		
		var pattern1 = /[0-9]+/;
		var pattern2 = /[a-zA-Z]+/;
		var pattern3 = /[!_?#@~\-+*]+/;
		
		errorMessageName.style.display = 'none';
		errorMessageIdByInput.style.display = 'none';
		errorMessagePwdBySame.style.display = 'none';
		errorMessagePwdByInput.style.display = 'none';
		errorMessageEmail.style.display = 'none';
		errorMessageTel.style.display = 'none';
		
		var inValid = true;
		if (inputId === '') {
			errorMessageIdByInput.textContent = '아이디를 입력해주세요.';
			errorMessagePwdByInput.style.display = '';
			inValid = false;
		} else if (inputId.length <= 3) {
			errorMessageIdByInput.textContent = '최소 4글자 이상이어야 합니다.';
			errorMessageIdByInput.style.display = '';
			inValid = false;
		} else if (!pattern1.test(inputId) || !pattern2.test(inputId)) {
			errorMessageIdByInput.textContent = '아이디는 영문 대소문자, 숫자로 구성해야 합니다.'
			errorMessageIdByInput.style.display = '';
			inValid = false;			
		}
		
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
		
		if (name === '') {
			errorMessageName.style.display = '';
			inValid = false;
		}
		
		if (inputEmail === '') {
			errorMessageEmail.style.display = '';
			inValid = false;
		}
		
		for (var i=0; i<isChecked.length; i++) {
			if (!isChecked[i].checked) {
				inValid = false;
				alert("이용약관, 개인정보 수집 동의는 필수 입니다.");
				break;
			}
		}
		
		for (var i=0; i<inputTel.length; i++) {
			if (inputTel[i].value === '') {
				errorMessageTel.style.display = '';
				inValid = false;
			} else if(!pattern1.test(inputTel[i].value)) {
				errorMessageTel.textContent = ' 휴대전화는 숫자로 입력해주세요.'
				errorMessageTel.style.display = '';
				inValid = false;
			}
		}
		
		if (inValid) {
			joinForm.submit();
		}
	}

</script>
</body>
</html>