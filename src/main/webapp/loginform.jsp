<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
   <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" >
    <title>로그인</title>
<style type="text/css">
	p {
		color: grey;
	}
	[href*='found'] {
		text-decoration: none;
		color: grey;
	}
	#formInput {
		width: 650px
	}
	
	div.alert-danger {
		line-height: 9px;
		border-radius: 0;
		font-size: 11px;
	}
	
</style>
</head>
<body>
	
<%
	pageContext.setAttribute("menu", "login");
	String error = request.getParameter("error");
%>
<%@ include file="common/navbar.jsp" %>
<div class="container" id="formInput">    
	<div class="row bg-light border mt-5">
		<div class="m-4">
			<h3><strong>LOGIN</strong></h3>
			<p class=""><small>가입하신 아이디와 비밀번호를 입력해 주세요.</small></p>
		</div>
		<form method="post" action="login.jsp">
			<div class="col px-5">
<%
	if ("empty".equals(error)) {				
%>
				<div class="alert alert-danger">
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
					<span class="px-4">아이디와 비밀번호는 필수입력값입니다.</span>
				</div>
<%
	} else if ("notfound-user".equals(error)) {				
%>
				<div class="alert alert-danger">
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
					<span class="px-4">회원정보가 존재하지 않습니다.</span>
				</div>
<%		
	} else if("login-required".equals(error)) {				// 로그인 후 사용가능한 JSP 페이지를 로그인없이 요청했다.
		%>
				<div class="alert alert-danger">
					<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
					<span>로그인이 필요한 페이지를 요청하였습니다.</span>
				</div>
<%
	} else if (loginUserInfo != null) {
		response.sendRedirect("index.jsp");
		return;
	}
%>			
				<div class="mb-1">
					<!-- class="form-control"은 bootstap에서 form 에 대한 style을 지정한것을 쓰기 위해 사용 -->
					<label class="form-label" for="inputId">ID</label>
					<input type="text" name="id" class="form-control" id="inputId">
				</div>
				<div class="mb-3">
					<label class="form-label" for="inputPassword">PWD</label>
					<input type="password" name="password" class="form-control" id="inputPassword">
				</div>
				<div class="mb-4 d-grid">
					<button type="submit" class="btn btn-dark">로그인</button>
				</div>
				<div class="mb-3 text-center">
					<p><a href="foundId.jsp">아이디찾기</a> | <a href="foundPassword.jsp">비밀번호찾기</a></p>
				</div>
			</div>
		</form>
	</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>