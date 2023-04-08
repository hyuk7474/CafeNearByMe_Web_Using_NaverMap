<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%> 
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" /> -->
    <meta name="description" content="" />
    <meta name="author" content="" />

    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/assets/css/styles.css" rel="stylesheet" />
    <!-- css Files -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous">
        </script>
    <!-- Vendor CSS Files -->
    <link href="/assets/vendor/animate.css/animate.min.css" rel="stylesheet">
    <link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="/assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
    
    
	
	<script src="http://code.jquery.com/jquery.js"></script>
	
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" 
		  rel="stylesheet" 
		  integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" 
		  crossorigin="anonymous">
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" 
			integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" 
			crossorigin="anonymous">
	</script>
	
	<meta charset="UTF-8">
	
	<title>로그인</title>
	
	<script src="http://code.jquery.com/jquery.js"></script>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	
	<meta charset="UTF-8">
	
	<style>
		#loginError{
			border: 1px solid red;
			border-radius: 10px;
			background: #ffcc99;
		}
		.test1{  }
	    .test2{ padding-top: 80px; }
	    .test3{ font-size : 120%; font-weight: bold; padding-top: 20px; }
	    hr { height : 1px; }
	</style>
	<script src="http://code.jquery.com/jquery.js"></script>
	<script>
		function join() {
			window.location.href="/join";
		}
		function login_google() {
			window.location.href="/oauth2/authorization/google";
		}
		function login_kakao() {
			window.location.href="/oauth2/authorization/kakao";
		}
		function login_naver() {
			window.location.href="/oauth2/authorization/naver";
		}		
		function login_facebook() {
			window.location.href="/oauth2/authorization/facebook";
		}	
	</script>
</head>
<body>
<sec:authorize access="isAuthenticated()">
	<c:url value="/logout" var="logoutUrl"/>
	<a href="${logoutUrl}">Log Out</a> <br>
	<p> Status : Log-In</p>
	<jsp:forward page="/WEB-INF/views/root.jsp"/>
</sec:authorize>
<div class="container-fluid">
<div class="row">
	<div class="col test1"></div>
    <div class="col-4 test2">
    	<!-- 
    	<a href="/"> <img src="/assets/img/로고.png" alt="KIDULT logo" style="margin-left: 35%; width: 30%;"></a>
    	 -->
		<c:url value="j_spring_security_check" var="loginUrl" />
		<form id="reg_frm" action="${loginUrl}" method="post">
		
  		<!-- Id input -->
  		<div class="form-outline mb-3">
  			<label class="form-label" for="form2Example1">ID</label>
	    	<input type="text" name="mid" id="mid" value="${mid}" class="form-control" />
	    </div>

		<!-- Password input -->
 		<div class="form-outline mb-3">
 			<label class="form-label" for="form2Example2">Password</label>
    		<input type="password" name="mpw" id="mpw" class="form-control" />
		</div>

		<!-- 2 column grid layout for inline styling -->
		<div class="row mb-3">
    		
  		</div>
  		<c:if test="${param.error != null}">
		<p id="loginError">
			Login Error! <br />
			${error_message}
		</p>
		</c:if>

  		<!-- Login button -->
  		<button type="submit" class="btn btn-info btn-block mb-4">Login</button>

  		<!-- Register buttons -->
 		<div class="text-center">
    		<button type="button" class="btn btn-outline-info btn-block mb-4" onclick="join()">회원가입</button>
    		<p class="test3"></p>
		</div>
		</form>
		<hr />
		<div class="form-outline mb-3">
  			<div class="text-center">
  				<p class="test3">SNS로 로그인</p>
  			</div>
			<br/>
	    </div>
	    
		<button type="submit" class="btn btn-secondary btn-block mb-4" onclick="login_google()">Google로 로그인</button>
		<button type="submit" class="btn btn-warning btn-block mb-4" onclick="login_kakao()">Kakao로 로그인</button>
		<button type="submit" class="btn btn-success btn-block mb-4" onclick="login_naver()">Naver로 로그인</button>
		<button type="submit" class="btn btn-primary btn-block mb-4" onclick="login_facebook()">Facebook으로로 로그인</button>
		
	</div>
    <div class="col test1"></div>
</div>  
</div>


<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>		
</body>
</html>