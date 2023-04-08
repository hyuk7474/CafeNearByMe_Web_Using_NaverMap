<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="http://code.jquery.com/jquery.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v6.2.0/css/all.css">
<link rel="stylesheet" href="/assets/css/modal_style.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-u1OknCvxWvY5kfmNBILK2hRnQC3Pr17a+RTT6rIHI7NnikvbZlHgTPOOmMi466C8" crossorigin="anonymous"></script>

<!-- <script src="http://code.jquery.com/jquery-latest.min.js"></script> -->
<title>마이페이지</title>
<style>
	.btn {
		padding: 10px;
	}
</style>
</head>
<script>

	var winidowHeight = null; 
	var headerHeight = null;
	
	window.onload = function() {
		console.log($("#mid").val())
		resize();
	    window.addEventListener('resize', resize);
	}
	
	function toMyInfo() {
		var mid = $("#mid").text();	
		$("#mid_form").submit();
	}
	
	function getHistory() {
		console.log($('#mid_hidden').html());
		$.ajax({			
			url: '/member/gethistory',
			type: 'POST',
			data: {mId : $('#mid_hidden').html()},            	
			dataType: 'text',			
			success: function(json){    				
				var result = JSON.parse(json);
				console.log(result);
				if(result.code == "success"){
					alert(result.desc);
					$('#paid_history').append('<div onclick="hideHistory()" class="hide fas fa-times" z-index: -1></div>');
					for(key in result.data){
						console.log(result['data'][key]['item_Name']);
						$('#paid_history').append('<center><p><strong>구매 상세 정보</strong></p>'								
												+ '<p>'+result['data'][key]['item_Name']+'</p>'
												+ '<p>'+result['data'][key]['price']+'</p>'
												+ '<p>'+result['data'][key]['mEmail']+'</p>'
												+ '<p>'+result['data'][key]['mName']+'</p>'
												+ '<p>'+result['data'][key]['mPnum']+'</p>'
												+ '<p>'+result['data'][key]['paidDate']+'</p>'
												+ '<p>'+result['data'][key]['paidTime']+'</p></center><hr>');
						showHistory();
					}
				} else {
					alert(result.desc);    				
				}
			}
		});
	}
	
	function resize(){    		
	    var winidowWidth = window.innerWidth;
	    winidowHeight = window.innerHeight  - document.getElementById('appHead').offsetHeight
	    
	    
	    headerHeight = document.getElementById('appHead').offsetHeight;    	    
	    
	    $("#paid_history").css("height", winidowHeight);
	    $("#paid_history").css("width", winidowWidth);
	    
	        
	}
	
	function hideHistory() {
		$("#paid_history").css("top", "-100%");	
	}
	
	function showHistory() {
		$("#paid_history").css("top", headerHeight);	
	}
</script>
<body>
<span id="mid_hidden" style="display:none;"><sec:authentication property="name"/></span>
<header id="appHead">
    <nav class="navbar navbar-expand-lg navbar-light bg-light">    
	  <div class="fa-solid fa-house" style="width: 40px; height:40px; font-size:30px; padding:5px; cursor: pointer;" onclick="location.href='/map'"></div>  
	</nav>    
    </header>
<form id="mid_form" action="/member/myinfo" method="post">
	<input name="mId" id="mId" type="hidden" value=<sec:authentication property="name"/>>
</form>
<center style="padding:50px;">
<p>
<button type="button" class="btn btn-success" onclick="toMyInfo()">내 정보 수정</button>
<p>
<button type="button" class="btn btn-warning" onclick="getHistory()">주문 내역</button>
<p>
<button type="button" class="btn btn-danger" onclick="location.href='/logout'">로그아웃</button>
<p>
</center>

<div id="paid_history" style="position: fixed; overflow: auto; top:-100%; transition: 500ms; background-color: white;">
	<div onclick="hideHistory()" class="hide fas fa-times" style="position: absolute;" z-index: -1></div>
</div>

</body>
</html>