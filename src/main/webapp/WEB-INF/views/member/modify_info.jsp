<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta mname="viewport" content="wmidth=device-wmidth, initial-scale=1.0">

    <!-- <meta mname="viewport" content="wmidth=device-wmidth, initial-scale=1, shrink-to-fit=no" /> -->
    <meta mname="description" content="" />
    <meta mname="author" content="" />

    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/assets/css/styles.css" rel="stylesheet" />
    
    <!-- Vendor CSS Files -->
    <link href="/assets/vendor/animate.css/animate.min.css" rel="stylesheet">
    <link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="/assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
    
    <title>내 정보 수정</title>
	
		
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" 
		  rel="stylesheet" 
		  integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" 
		  crossorigin="anonymous">
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" 
			integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" 
			crossorigin="anonymous">
	</script>
	
	<meta charset="UTF-8">
	<script src="http://code.jquery.com/jquery.js"></script>	
	
	<script>
	var confirmedPnum = "";
	var input_mPnum = "";
		window.onload = function(){			
			confirmedPnum = $("#db_mpnum").val();
			console.log(confirmedPnum);
			var mid = $("#mid").val();
			console.log(mid);
			if(mid.indexOf("(n)")>-1||
			   mid.indexOf("(k)")>-1||
			   mid.indexOf("(gg)")>-1||
			   mid.indexOf("(fb)")>-1){				
				$("#showId").text("sns 로그인 유저");
			}
		}
	
		function form_check() {
			if($('#mname').val().length == 0){
				alert("이름은 필수사항입니다.");
				$('#mname').focus();
				return;
			}
				
			if($('#mpnum2').val().length == 0){
				alert("휴대폰 번호는 필수사항입니다.");
				$('#mpnum2').focus();
				return;
			}
			if($('#mpnum3').val().length == 0){
				alert("휴대폰 번호는 필수사항입니다.");
				$('#mpnum3').focus();
				return;
			}
			input_mPnum = $("#mpnum1").val()+"-"+$("#mpnum2").val()+"-"+$("#mpnum3").val();
			console.log($('#pnumValidated').val());
			console.log(input_mPnum + " / " + confirmedPnum);
			if(input_mPnum != confirmedPnum){
				console.log(111);
				alert("휴대폰 번호가 변경되었습니다. 다시 인증해야합니다.")
				$('#mpnum3').focus();		
				return;
			}
			if($('#pnumValidated').val() == "Y"){
				console.log(222);
				if(input_mPnum != confirmedPnum){
					alert("휴대폰 번호가 변경되었습니다. 다시 인증해야합니다.")
					$('#mpnum3').focus();
					return;
				}			
			}
			if($("#db_mname").val() == $("#mname").val() &&
			   $("#db_memail").val() == $("#memail").val() &&
			   input_mPnum == confirmedPnum) {
				alert("변경된 정보가 없습니다.");
				return;
			}
			
			submit_ajax();			
		}
		
		function submit_ajax(){
			var queryString = $("#reg_frm").serialize();			
			console.log(input_mPnum);
			queryString += ("&mpnum="+input_mPnum)		
			console.log(queryString);
			$.ajax({			
				url: '/member/myinfo/modify',
				type: 'POST',
				data: queryString,
				dataType: 'text',
				success: function(json){
					console.log(json); 
					var result = JSON.parse(json);
					if(result.code == "success"){
						alert(result.desc);
						window.location.replace("/member/mypage");
					} else {
						alert(result.desc);						
					}
				}
			});
		}
		
		function subNum(e) {		
			if(e.value.length == 4) {
				if(e.id == "mpnum2") $('#mpnum3').focus();
			}
			if(e.value.length > 4){
	            e.value = e.value.slice(0, 4);
	        }
		}
		
		function pnumValidation(){		
			var pnumToVal = $("#mpnum1").val()+$("#mpnum2").val()+$("#mpnum3").val();		
			console.log(pnumToVal);
			$.ajax({			
				url: '/check/sms',
				type: 'POST',
				data: {'pnum' : pnumToVal},
				dataType: 'text',			
				success: function(json){				
					console.log(json); 
					var result = JSON.parse(json);
					if(result.code == "success"){
						alert(result.desc);
						nVal = result.nVal;
						console.log(nVal);	
						showTime();
					} else {
						alert(result.desc);					
					}
				}
			});
		}
		
		var setTime = 180;
		
		function showTime() {		
			$("#input_p").css("display", "block");
			setTime = 180;
			var min = 0;
			var sec = 0;
			var interval = setInterval(function() {
								if(setTime!=-1){
									min = parseInt(setTime/60);
									sec = (setTime % 60).toString();
									console.log(sec.length);
									if(sec.length==1){
										sec = "0"+sec
									}
									var lastTime = "0"+min+":"+sec;
									console.log(lastTime);
									$("#timeLimit").text(lastTime);
									/* $('#mUseable').text("사용 가능한 아이디입니다.") */
									setTime -= 1;	
								} else {
									$("#timeLimit").text("유효 시간 만료");
									nVal = "expired";
									console.log(nVal);
									clearInterval(interval);
								}
							}, 1000);				
		}
		
		function validate() {
			var input = $("#inputVal").val();
			if(input == nVal) {
				setTime = 0;
				$("#input_p").css("display", "none");
				$("#timeLimit").text("");
				$("#inputVal").val("");
				$('#pnumValidated').val("Y");
				confirmedPnum = $("#mpnum1").val()+"-"+$("#mpnum2").val()+"-"+$("#mpnum3").val();
				alert("휴대폰 인증이 완료되었습니다.");
			} else {
				alert("인증 번호와 일치하지 않습니다.");
			}
		}
		
	</script>
	<style>
		
		/* Chrome, Safari, Edge, Opera */
		input::-webkit-outer-spin-button,
		input::-webkit-inner-spin-button {
		  -webkit-appearance: none;
		  margin: 0;
		}
	
		/* Firefox  */
		input[type='number'] {
		  -moz-appearance: textfield;
		}
		
		.test2{ padding-top: 80px; }
		.text2-1{ padding-top: 50px; }
		.text2-2{ padding-top: 20px; }
	</style>
</head>
<body>
<input id="db_mpnum" type="hidden" value="${mPnum}" />
<input id="db_mname" type="hidden" value="${mName}" />
<input id="db_memail" type="hidden" value="${mEmail}" />
<div class="container-flumid">
        <div class="row">
            <div class="col test1"></div>
            <div class="col-5 test2">
            	<!-- <img src="/assets/img/로고.png" alt="KIDULT logo" style="margin-left: 35%; wmidth: 30%;"> -->            	
				<form id="reg_frm">
					<div class="form-group" style="padding-bottom:20px;">
						<p id="showId" class="text2-2">아이디&nbsp;&nbsp;&nbsp;${mId}</p>
                		<input type="hidden" class="form-control" id="mid" name="mid" value="${mId}">              								
					</div>
					<small id="joinhelp" class="form-text text-muted"><span style="color: orangered;">*</span>은 필수 입력 사항입니다.</small><p>
                	<div class="form-group" style="padding-bottom:20px;">
						<p>이름<span style="color: orangered;">*</span></p>
	                	<input type="text" class="form-control" id="mname" value="${mName}" name="mname" placeholder="사용자의 이름을 입력하세요.">
					</div>					
					<div class="form-group" style="padding-bottom:20px;">
	             		<p>휴대폰 번호<span style="color: orangered;">*</span></p>
	             		<select id="mpnum1" style="float:left" value='${mPnum1}'>
	             			<option value="010">010</option>
	             			<option value="02">02</option>
	             			<option value="051">051</option>
	             			<option value="053">053</option>
	             			<option value="032">032</option>
	             			<option value="062">062</option>
	             			<option value="042">042</option>
	             			<option value="052">052</option>
	             			<option value="044">044</option>
	             			<option value="031">031</option>
	             			<option value="033">033</option>
	             			<option value="043">043</option>	             			
	             			<option value="041">041</option>
	             			<option value="063">063</option>
	             			<option value="061">061</option>
	             			<option value="054">054</option>
	             			<option value="055">055</option>
	             			<option value="064">064</option>
	             		</select>
	                	<span style="float:left">&nbsp;-&nbsp;</span>
	                	<input type="number" class="form-control" id="mpnum2" name="mpnum2" style="width:25%; height:40%; float: left" value="${mPnum2}" oninput="subNum(this)">
	                	<span style="float:left">&nbsp;-&nbsp;</span>
	                	<input type="number" class="form-control" id="mpnum3" name="mpnum3" style="width:25%; height:40%; float: left" value="${mPnum3}"oninput="subNum(this)">
	                	<span style="float:left">&nbsp;&nbsp;</span>
	                	<button type="button" class="btn btn-dark btn-danger mb-4" onclick="pnumValidation()" id="checkdup" value="N" style="float:left;">번호 인증</button>
	                	<br><br><br>
	                	<p id="input_p" style="display:none; float:left;">
	                		<input type="hidden" id="pnumValidated" value="N">
	                		<span style="float:left;">인증 번호 입력 &nbsp;&nbsp;</span> 
	                		<input class="form-control" id="inputVal" type="number" style="width:25%; height:40%; float: left;"/>
	                		<span style="float:left">&nbsp;&nbsp;</span>
	                		<button type="button" class="btn btn-dark btn-danger mb-4" onclick="validate()" id="checkdup" value="N" style="float:left;">인증</button>
	                		<span style="float:left">&nbsp;&nbsp;</span> 
	                		<span id="timeLimit" style="color:red; float:left;"></span>
	                	</p>	
					</div>
					<br><br>
					<div class="form-group" style="padding-bottom:20px;">
						<p>이메일 주소</p>
	                	<input type="text" class="form-control" id="memail" name="memail" placeholder="이메일 주소를 입력하세요." value="${mEmail}">
					</div>					
	                <br>
	                <div class="text-center">	                	
		             	<p>
		             	<p>
		             	<button type="button" class="btn btn-info btn-lg" onclick="form_check()">수정</button>
		             	<button type="button" class="btn btn-danger btn-lg" onclick="window.location.href='/'">취소</button>
		             	
					</div>	

	            	<p></p>
	             	
	        	</form>
            </div>
            <div class="col test1"></div>
        </div>   
    </div>
</body>
</html>