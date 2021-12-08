<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	h3 strong {
		font-size: 16px;
	}
	p small {
		color: grey;
		font-size: 13px;
	}
	input {
		border-radius: 0;
		border: 1px solid #d5d5d5;
		display: block;
		width: 528px;
		height: 38px;
	}
	label {
		font-size: 13px;
	}
	[href*='found'] {
		text-decoration: none;
		color: grey;
	}
	#formInput {
		width: 650px;
		margin: 0 auto;
	}
	
	div.alert-danger {
		line-height: 9px;
		border-radius: 0;
		font-size: 11px;
	}
	div.d-grid button.btn {
		border-radius: 0;
		background-color: #464646;
		color: white;
		height: 46px;
		font-size: 13px;
	}
	
</style>
</head>
<body>
<%
	String error = request.getParameter("error");
%>
<%@ include file="common/navbar.jsp" %>
<div class="container">    
	<!-- 브레드크럼 breadcrumb -->
	<div>
		<nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
		  <ol class="breadcrumb justify-content-end">
		    <li class="breadcrumb-item"><a href="index.jsp">HOME</a></li>
		    <li class="breadcrumb-item active" aria-current="page" style="font-weight: bold;">LOGIN</li>
		  </ol>
		</nav>
	</div>
	<div class="row bg-light border mt-5" id="formInput">
		<div class="m-4">
			<h3 style="margin: 1px;"><strong>LOGIN</strong></h3>
			<p><small>가입하신 아이디와 비밀번호를 입력해 주세요.</small></p>
		</div>
		<form id="loginForm" method="post" action="login.jsp" onsubmit="checkInputField(event)">
			<div class="col px-5">
<%
	if ("notfound-user".equals(error)) {				
%>
				<div class="alert alert-danger">
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
					<span class="px-4">회원정보가 존재하지 않습니다.</span>
				</div>
<%
	} else if (loginUserInfo != null) {
		response.sendRedirect("index.jsp");
		return;
	} else if ("mismatch-password".equals(error)) {
%>
		<div class="alert alert-danger">
			<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			<span class="px-4">비밀번호가 일치하지 않습니다.</span>
		</div>
<%	
	}
%>			
				<div class="mb-1">
					<label for="inputId">ID</label>
					<input type="text" name="id" id="inputId">
					<div class="form-text text-danger" style="display: none;" id="error-Id">
						아이디를 입력해주세요.			
					</div>
				</div>
				<div class="mb-5">
					<label for="inputPassword">PWD</label>
					<input type="password" name="password" id="inputPassword">
					<div class="form-text text-danger" style="display: none;" id="error-password">
						비밀번호를 입력해주세요.	
					</div>
				</div>
				<div class="mb-4 d-grid">
					<button type="submit" class="btn">로그인</button>
				</div>
				<div class="mb-3 text-center">
					<p><a href="foundId.jsp">아이디찾기</a> | <a href="foundPassword.jsp">비밀번호찾기</a></p>
				</div>
			</div>
		</form>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	function checkInputField(event) {
		event.preventDefault();
		
		var loginForm = document.getElementById("loginForm");
		
		var userId = document.getElementById("inputId").value;
		var password = document.getElementById("inputPassword").value;
		
		/* 오류 메세지 */
		var errorMessageIdByInput = document.getElementById("error-Id");
		var errorMessagePwdByInput = document.getElementById("error-password");
		
		errorMessageIdByInput.style.display = 'none';
		errorMessagePwdByInput.style.display = 'none';
		
		var inValid = true;
		if (userId === '') {
			errorMessageIdByInput.style.display = '';
			inValid = false;
		}
		if (password === '') {
			errorMessagePwdByInput.style.display = '';
			inValid = false;
		} 
		
		if (inValid) {
			loginForm.submit();
		}
	}
</script>
</body>
</html>