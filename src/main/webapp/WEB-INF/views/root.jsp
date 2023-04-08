<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Root</title>
</head>
<body>	
	RootPage
	
		
	<hr>
	
	<%-- <c:if test="${not empty pageContext.request.userPrincipal }">
	<p> is Log-In</p>
	</c:if>
	
	<c:if test="${empty pageContext.request.userPrincipal }">
	<p> is Log-Out</p>
	</c:if> --%>
	
	<sec:authorize access="isAuthenticated()">	
	<a href="/member/mypage">MyPage</a> <br>
	<c:url value="/logout" var="logoutUrl"/>
	<a href="${logoutUrl}">Log Out</a> <br>
	<p> Status : Log-In</p>	
	</sec:authorize>
	
	ID : <span id="mid"><sec:authentication property="name"/></span><br>	
	소유 권한 : <sec:authentication property="authorities"/><br>
		
	<sec:authorize access="!isAuthenticated()">
	<c:url value="/loginform" var="loginUrl"/>
	<p>
	<a href="${loginUrl}">Log In</a> <br>
	<p> Status : Log-Out</p>
	</sec:authorize>
	
	
		
	<script>
	// '#_=_'은 보안 세션 악용을 보호하기 위해 Facebook에 의해 추가되었다.
	// Facebook에 따르면 이를 처리하는 것은 개발자의 책임이다.
	console.log("aaa"+window.location.hash);
	if(window.location.hash == '#_=_'){
		console.log("bbb");
		console.log(history.replaceState);
		history.replaceState
			? history.replaceState(null, null, window.location.href.split('#'[0]))
			: window.loacation.hash = '';
	}
	</script>
</body>
</html>