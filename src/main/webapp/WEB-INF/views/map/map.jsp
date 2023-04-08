<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<% 
String data = (String) request.getAttribute("data");
System.out.println(data);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v6.2.0/css/all.css">
<link rel="stylesheet" href="/assets/css/modal_style.css">
<link rel="stylesheet" href="/assets/css/styles.css"/>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-u1OknCvxWvY5kfmNBILK2hRnQC3Pr17a+RTT6rIHI7NnikvbZlHgTPOOmMi466C8" crossorigin="anonymous"></script>
<style>	

	body {
      margin:0;
      padding: 0;
    }

	table, td {	
	 	text-align:center;
	 	padding : 15px;	 	
	 }
	 
	 td {
	 	border-top: 1px solid black;
	 	
	 }
	 .menu {
	 	width : 260px;	 	
	 }
	 .price {
	 	width : 100px;
	 }
	 .cart {
	 	width : 40px;	 	
	 }
	 
	 #cart_img {
	 	width: 30px;
	 	height:30px;
	 	cursor: pointer;
	 }
	 
	 input::-webkit-outer-spin-button,
		input::-webkit-inner-spin-button {
		  -webkit-appearance: none;
		  margin: 0;
		}
	
	/* Firefox  */
	input[type='number'] {
	  -moz-appearance: textfield;
	}
	
	.menu_btn {
		width: 100%; 
		cursor: pointer; 
		padding:10px; 
		border:solid 1px black
	}
</style>
</head>
<script src="http://code.jquery.com/jquery.js"></script>
<body>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=15m2bf5ymh&callback=initMap"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=htg9k51x5q&submodules=geocoder"></script>
    <script src="https://js.bootpay.co.kr/bootpay-4.2.0.min.js" type="application/javascript"></script>
    <script type="text/javascript">
    	var mid = "";
    	var auth = "";
    	var cartItems = "";
    	window.onload = function() {    		
    		var latlonData = ' <%= data %> ';    		
    		var jsonlatlonData = JSON.parse(latlonData);
    		
    		$('.kind').slideUp();
    		
    		mid = $('#mid_hidden').html();
    		auth = $('#auth_hidden').html();
    		
    		console.log(mid + " : " + auth);    		
    		loginCheck();
    		
    		resize();
    	    window.addEventListener('resize', resize);
    	}
    	
    	var IMG_PATH = '/assets/img';
    	
    	var markerCenter = null;
    	
    	var map = null;
    	var bSetCoor = false;
    	var centerLat = "";
    	var centerLon = "";
    	var openedInfoWindows = null;
    	
    	var mapHeight = null;
    	var headerHeight = null;
    	var footerHeight = null;
    	
    	var orderTotPrice = null;
    	
    	var finalTotPrice = null;
    	var finalTotQty = null;
    	var finalMenuName = null;
    	
    	var justPaid_wrap_bottom = null;
    	var justPaid_wrap_left = null;
    	
    	//var menu_info_wrap_width = 200;
    	
    	
    	var detailInfoString = $(
    			
  			  '<div id="menu_tot_wrap" style="width: 50px; height: 100%;position: relative;top:0;left:0; overflow: auto;" z-index: -1>'              
              +		'<div id="menu_info_wrap" style="padding: 20px; width: 450px; height: 100%; position : fixed; top:0; left:-100%;  float: left; background-color: #f5fffa;border:solid 1px #333; display:block; overflow: auto;  transition: 500ms;" z-index: -1>'
              +			'<div onclick="hideInfo()" class="hide fas fa-times" z-index: -1></div>'
              +			'<h3 id="menu_title"></h3>'
              +			'<div>'
              +				'<p id="cat_coffee" onclick=show("coffee")>Coffee&nbsp;&nbsp;▼</p>'
              +			'<table id="coffee" class="kind" style="display: block;"><tr><td class="menu">메뉴</td><td class="price">가격</td><td> </td></tr></table>'
              +				'<p id="cat_juice" onclick=show("juice")>Juice&nbsp;&nbsp;▼</p>'
              +			'<table id="juice" class="kind" style="display: block;"><tr><td class="menu">메뉴</td><td class="price">가격</td><td> </td></tr></table>'
              + 			'<p id="cat_ade" onclick=show("ade")>Ade&nbsp;&nbsp;▼</p>'
              +			'<table id="ade" class="kind" style="display: block;"><tr><td class="menu">메뉴</td><td class="price">가격</td><td> </td></tr></table>'
              + 			'<p id="cat_tea" onclick=show("tea")>Tea&nbsp;&nbsp;▼</p>'
              +			'<table id="tea" class="kind" style="display: block;"><tr><td class="menu">메뉴</td><td class="price">가격</td><td> </td></tr></table>'
              +			'<div id="order_btn" onclick="showOrder();" class="btn" style="width: 450px; position: fixed; left: -100%; bottom: 150px; transition: 500ms; color: white; background-color: lightgreen; border-radius: 8px; border: 2px solid wihte; display: block;">주문하러 가기&nbsp;&nbsp;<span id="countItem" class="badge badge-danger">10</span></div>'
              + 		'</div>'              
              + 		'<div id="deactivate"  style="width: 100%; height:100%; position: absolute; top:0; left:0;opacity: 0.8;background-color:#f5fffa;border:solid 1px #333; display: none; overflow: hidden;" z-index: 500></div>'              
              +			'<div id="modal" style="width:450px; position: fixed; background: lightgreen; left: -100%; bottom: 0; transition: 500ms; border:solid 1px #333;">'
              +				'<input id="cno_hidden" type="hidden">'
              +				'<input id="price_hidden" type="hidden">'
              +				'<input id="kind_hidden" type="hidden">'
              +				'<div onclick="hidemodal()" class="hide fas fa-times"></div>'
              +				'<div id="totAdd_wrap" style="padding: 20px; text-align: center;">'
              +					'<p id="menu_chosen" style="fontWeight: 900;"></p>'
              +					'<button id="sub_btn" onclick="sub_count(\'item_count\')" onchange="sub_count(\'item_count\')">-</button><input id="item_count" type="number" value="1" style="width:40px; text-align:center;" oninput="checkNum(\'item_count\')" onchange="checkNum(\'item_count\')"><button id="add_btn" onclick="plus_count(\'item_count\')">+</button>'
              +					'<div id="add_wrap1">'
              +						'<hr>'
              +						'<p id="add_title1"></p>'                
              +						'<p id="add_p11"><span id="add_text11"></span>&nbsp;&nbsp;<input id="add_radio11" name="choice1" type="radio" checked="true"/></p>'
              +						'<p id="add_p12"><span id="add_text12"></span>&nbsp;&nbsp;<input id="add_radio12" name="choice1" type="radio"/></p>'                
              +					'</div>'                
              +					'<div id="add_wrap2">'
              +						'<hr>'
              +						'<p id="add_title2"><p>'
              +						'<p id="add_p21"><span id="add_text21"></span>&nbsp;&nbsp;<input id="add_radio21" name="choice2" type="radio" checked="true"/></p>'
              +						'<p id="add_p22"><span id="add_text22"></span>&nbsp;&nbsp;<input id="add_radio22" name="choice2" type="radio"/></p>'
              +						'<p id="add_p23"><span id="add_text23"></span><input id="add_radio23" name="choice2" type="radio"/></p>'
              +					'</div>'
              +					'<p>'
              +					'<button id="menu_confirm" onclick="makeCartItem()"></button>'
              +				'</div>'                
              +			'</div>'
              +	  	'</div>'
              + 	'<div id="menu_select_wrap" style="width:50px;height:100%;position: relative; top: 0; left: 0; float: left; background-color: white;border:solid 1px #333; display:block;overflow: auto;" z-index: 9999>'
              +			'<center><div id="menu_btn_list" class="menu_btn fa-solid fa-list"></div></center>'
              +			'<center><div id="menu_btn_showMenu" class="menu_btn fas fa-mug-hot"></div></center>'              
              +			'<center><div id="menu_btn_account" class="menu_btn fa-solid fa-user" onclick=\'location.href="/member/mypage"\' style="position: fixed; width:50px; height:50px; left:0; top:100;" title="마이 페이지"></div></center>'
              +			'<center><div id="menu_btn_log" class="menu_btn fa-solid fa-right-to-bracket"  onclick=\'location.href="/loginform"\' style="position: fixed; width:50px; height:50px; left:0; top:50;" title="로그인"></div></center>'              
  			  + 	'</div>'
  			  +		'<div id="menu_order_wrap" style="padding: 20px; width: 450px; height: 100%; position : fixed; top:0; left:-100%;  float: left; background-color: #f5fffa;border:solid 1px #333; display:block; overflow: auto;  transition: 500ms;" z-index: -1>'
  			  +			'<div onclick="hideOrder()" class="hide fas fa-times" z-index: -1></div>'
  			  +			'<p>주문 확인</p>'			
              +			'<table id="cartItems" style="display: block;"></table>'
              +			'<hr>'
              +			'<p id="orderTotPrice_p" style="text-align: right;"><strong>합계 금액</strong>&nbsp;&nbsp;<span id="orderTotPrice"></span></p>'
              +			'<p id="orderTotPrice_waring" style="text-align: right; color:red; display: none;"><strong>주문할 음료를 체크해주세요.</strong></p>'
              +			'<center><button onclick="getInfosToPay()">결제하기</button></center>'
  			  +		'</div>'
  			  +		'<div id="map_deactivater"  style="width: 100%; height:100%; position: fixed; top:-100%; left:0;opacity: 0.8;background-color:#f5fffa;border:solid 1px #333; display: none; overflow: hidden; transition: 500ms;" z-index: 500></div>'
  			  +		'<div id="justPaid_wrap" style="width: 400px; height: 300px; position: fixed; left: 35%; top: -100%; background-color: #f5fffa;border:solid 1px #333; margin: 10px; transition: 500ms;">'  			
  			  +			'<div id="justPaid_content" style="padding: 20px;">'  			
  			  +			'<div onclick="hideJustPaid()" class="hide fas fa-times" z-index: -1></div>'
  			  +				'<p id="thanks_text">Thanks</p>'
  			  +				'<p><b> 주문 내역 </b></p>'
  			  +				'<p id="item_Name">카페 라떼</p>'
  			  +				'<p id="mId">hong</p>'
  			  +				'<p id="mName">홍길동</p>'
  			  +				'<p id="mPnum">010-7864-7567</p>'
  		      +			'</div>'
  			  +		'</div>'
              +'</div>'
              );
	
    	function showInfo() {
    	    $('#menu_info_wrap').css('left', '50px');
    	}
    	
    	function hideInfo() {    		
    		$('#menu_info_wrap').css('left', '-100%');
    	}
    	
    	function showOrder() {
    		setOrderPage();
    		$('#menu_order_wrap').css('left', '50px');    		
    	}
		function hideOrder() {
			$('#menu_order_wrap').css('left', '-100%');
    	}
    	
    	
    	function showmodal() {
    		$('#deactivate').css('display', 'block');
    		$('#menu_info_wrap').css('overflow', 'hidden');    		
    	    $('#modal').css('left', '50px');    	        	    
    	}
    	
    	function hidemodal() {
    		$('#modal').css('left', '-100%');
    		setTimeout(500);
    		$('#menu_info_wrap').css('overflow', 'auto');
    		$('#deactivate').css('display', 'none');
    		$('#item_count').val('1');    		
    		$('#add_radio11').prop('checked', 'true');
    		$('#add_radio21').prop('checked', 'true');
    		$('#add_wrap1').css('display', 'block');
    		$('#add_wrap2').css('display', 'block');
    	}
    	
    	function plus_count(target) {    		
    		var iNow = parseInt($('#'+target).val());    		
    		if(isNaN(iNow)) iNow = 0;    		
			var iResult = iNow + 1
    		$('#'+target).val(iResult);
    		checkNum(target);    		
    	}
    	
		function sub_count(target) {
			var iNow = parseInt($('#'+target).val());
			if(isNaN(iNow)) iNow = 2;
			var iResult = iNow - 1
    		$('#'+target).val(iResult);
    		checkNum(target);    		
    	}
		
		function checkNum(target) {
			var iNow = parseInt($('#'+target).val());
			if(iNow<1) {
				alert('최소 1개 이상 주문하여야 합니다.');
				$('#'+target).val("1");
				$('#totCount').text("1");
			} else if(iNow>99){
				alert('최대 주문 수량은 99개입니다.');
				$('#'+target).val("99");
				$('#totCount').text("99");
			} else if(isNaN(iNow)) {			
				return;
			}			
			getTotPrice(target);
		}
		
		function getTotPrice(target) {
			var price = parseInt($('#price_hidden').val());
			var count = parseInt($('#'+target).val());
			var totPrice = price * count;
			console.log(totPrice);
			$('#'+target+'_totPrice').text(getPriceString(totPrice));						
			$('#totCount').text(count);
		}
		
		var priceList = [];
		
		function setOrderPage() {
			priceList = [];
			$('#cartItems').html('<tr><td class="cart_chkbox">구매 여부</td><td class="cart_menu">메뉴</td><td class="cart_count">수량</td><td class="cart_price">가격</td></tr>');
			
			for (let i = 0; i < cartItems.size; i++) {
				
       	    	var item = cartItems.get("item"+i);
       	               	        
       	        var infos = item.split("'");
       	        
       	     	var cartItemPrice = infos[7];
       	     	var nRowPrice = cartItemPrice.substring(0, cartItemPrice.length-1).replace(",", "");       	     	
       	     	priceList.push(parseInt(nRowPrice));       	     	
    	        var cartItemCount = infos[9];
    	        
       	        var chkBoxString = "<input onchange='calcCartTotPrice("+i+");') type='checkbox' id='cartChk_"+i+"' value=" + cartItemPrice +" checked>"; 
       	        
       	     	var menuDetail = "<center><p id='cart_menu_name_"+i+"'>"+infos[1]+"</p>";
       	     	if(infos[3]=='null' || infos[3]=="없음") menuDetail += "";
       	     	else menuDetail += "<p id='detail1_"+i+"'>"+infos[3]+"</p>";
    	     	if(infos[5]=='null' || infos[5]=="없음") menuDetail += "";
    	     	else menuDetail += "<p id='detail2_"+i+"'>"+infos[5]+"</p>";
    	     	menuDetail += "</center>";
    	     	
       	        var cart_item_td = "cart_item_count"+i;
       	     	console.log(cart_item_td+'_totPrice');
       	        
       	     	$('#cartItems').append("<tr class='cart_tr'><td>"+chkBoxString+"</td><td>"+menuDetail+"</td><td id=cart_item_count"+i+">"
       	     						//+ '<button id="sub_btn" onclick="sub_count(\''+cart_item_td+'\')">-</button><input id="'+cart_item_td+'" type="number" value="'+cartItemCount+'" style="width:40px; text-align:center;" oninput="checkNum(\''+cart_item_td+'\')" onchange="checkNum(\''+cart_item_td+'\')"><button id="add_btn" onclick="plus_count(\''+cart_item_td+'\')">+</button>'
       	     						+ cartItemCount
       	     						+ "</td><td id='+"+cart_item_td+"_totPrice'>"+ cartItemPrice + "</td></tr>");
       	     	/* if($('#detail1_'+i).text()=='null' || $('#detail_'+i).text()=="없음") $('#detail1_'+i).remove();
    	     	if($('#detail2_'+i).text()=='null' || $('#detail_'+i).text()=="없음") $('#detail2_'+i).remove(); */
       	    }
			var totPrice = null;
			for(num in priceList){
				console.log(priceList[num]);
				totPrice += priceList[num];
			}			
			orderTotPrice = totPrice;
			console.log(orderTotPrice);
			$('#orderTotPrice').text(getPriceString(orderTotPrice));
		}
		
		function calcCartTotPrice(i) {			
			console.log($("#cartChk_"+i).is(':checked'));
			if(!$("#cartChk_"+i).is(':checked')){
				orderTotPrice -= priceList[i];				
				$('#orderTotPrice').text(getPriceString(orderTotPrice));
				if($('#orderTotPrice').text()=='0') {					
					$('#orderTotPrice_waring').css('display', 'block');
					$('#orderTotPrice_p').css('display', 'none');
					return;
				}
				$('#orderTotPrice_waring').css('display', 'none');
				$('#orderTotPrice_p').css('display', 'block');
			} else {
				orderTotPrice += priceList[i];
				$('#orderTotPrice').text(getPriceString(orderTotPrice));
				$('#orderTotPrice_waring').css('display', 'none');
				$('#orderTotPrice_p').css('display', 'block');
			}
		}
    	  
    	function show(kind) {    		
    		var text = "";
			if(kind=='coffee') text="Coffee";
			if(kind=='juice') text="Juice";
			if(kind=='ade') text="Ade";
			if(kind=='tea') text="Tea";
			
    		if($('#'+kind).is(':visible')) {
    			$('#'+kind).slideUp(400);
    			$('#cat_'+kind).html(text+'&nbsp;&nbsp;▼');
    		}
    		else {
    			$('#'+kind).slideDown(400);
    			$('#cat_'+kind).html(text+'&nbsp;&nbsp;▲');
    		}
    	}
    	
    	function getLocation() {
    		if(navigator.geolocation) {
    			navigator.geolocation.getCurrentPosition(function(position) {
    				centerLat = position.coords.latitude;
    				centerLon = position.coords.longitude;
    				    				
    				map.panTo({lat: centerLat,lng: centerLon}, {duration:500, easing: "easeOutCubic"});
    				
    				var here = new naver.maps.LatLng(centerLat, centerLon);
    				
    				markerHere = new naver.maps.Marker({
                        map: map,
                        position: here,
                        icon: {url : "https://upload.wikimedia.org/wikipedia/ko/thumb/a/a6/Pok%C3%A9mon_Pikachu_art.png/200px-Pok%C3%A9mon_Pikachu_art.png",
                        	   size : new naver.maps.Size(50, 52),
                        	   origin: new naver.maps.Point(0, 0),
                               anchor: new naver.maps.Point(25, 26),
                               scaledSize: new naver.maps.Size(50, 52),
                        	   }                    	  
                    });
    			}, function(error) {
    				console.error(error);
    			}, {
    				enableHighAccuracy: false,
    				maximumAge: 0,
    				tiemout: Infinity
    			});
    		} else {
    			alert("GPS를 지원하지 않습니다.")
    		}
    	}
    	
    	// 주소로 좌표 찾기
    	function goChk() {

    		addr = $("#addr").val();

    		naver.maps.Service.geocode({address: addr}, function(status, response) {
    			 if (status !== naver.maps.Service.Status.OK) {
    				  return alert('좌표가 검색 되지 않았습니다');
    			 }

    			var result = response.result;
    			var lng = result.items[0].point.x;  
    			var lat = result.items[0].point.y; 	
/* 
    			var mapOptions = {
    			   center: new naver.maps.LatLng(lat,lng),
    			   zoom: 15
    			};
    			var map = new naver.maps.Map('map', mapOptions); */
    			var marker = new naver.maps.Marker({
    				position: new naver.maps.LatLng(lat,lng),
    				map: map
    			});

    			$("#coord").html("<br>위도(Lat) : " + lat + "<br><br>경도(Lng) : " + lng);
    		});
    	}    
        
        function initMap() {        	
        	
        	var lon = $("#x").val();
        	var lat = $("#y").val();        	
        	            
            if(lon.length==0 || lat.length==0){
            	if(navigator.geolocation) {
        			getLocation();
        		} else {
        			lon = 126.9769995;
                	lat = 37.5741002;        			
        		}            	
            }
            var selected = new naver.maps.LatLng(lat, lon);
            map = new naver.maps.Map('map', {
            	center: selected,
        		zoom: 15,                
                zoomControl: true,
                zoomControlOptions: {
                    style: naver.maps.ZoomControlStyle.LARGE,
                    position: naver.maps.Position.RIGHT_TOP
                },
                scaleControl: true,
                scaleControlOptions: {
                    position: naver.maps.Position.BOTTOM_RIGHT
                },
                logoControl: true,
                logoControlOptions: {
                    position: naver.maps.Position.BOTTOM_RIGHT
                },
                mapDataControl: true,
                mapDataControlOptions: {
                    position: naver.maps.Position.BOTTOM_RIGHT
                }
            });            
            
            var markerCoor = new naver.maps.Marker({
	                position: new naver.maps.LatLng(0, 0),
	                map: map
	            });

            naver.maps.Event.addListener(map, 'click', function(e) {
            	if(openedInfoWindows != null) {
            		openedInfoWindows.close();
            		$('#order_btn').css('left', '-100%');
            	}
            	
            	if(document.getElementById("menu_info_wrap").offsetLeft>0){            		
            		initDetailInfo();
            	}
            	
            	if(bSetCoor==true){            		
            		markerCoor.setPosition(e.coord);
            		console.log("clickedCoor" + e.coord);
            		centerLat = e.coord['_lat'];
            		centerLon = e.coord['_lng'];            		
            		bSetCoor=false;
            		//$('body').css('cursor', 'none');
            	}                
            });
                        
            markerSelected = new naver.maps.Marker({
                   map: map,
                   position: selected,
                   icon: {url : "https://upload.wikimedia.org/wikipedia/ko/thumb/a/a6/Pok%C3%A9mon_Pikachu_art.png/200px-Pok%C3%A9mon_Pikachu_art.png",
                   	   size : new naver.maps.Size(50, 52),
                   	   origin: new naver.maps.Point(0, 0),
                          anchor: new naver.maps.Point(25, 26),
                          scaledSize: new naver.maps.Size(50, 52),
                   	   }                    	  
               });
            
            var locationBtnHtml = '<button onclick="getLocation()"><img src="/assets/img/FindMyLoc2.png" alt="NowHere" style="width: 30px; height: 30px;"></button>';
            var arountBtnHtml = '<p style="height:5px;">&nbsp;</p><button onclick="setRadius()" z-index: -200 >이 지역에서 찾기</button>'; 
            
            naver.maps.Event.once(map, 'init', function() {                
                var customControl1 = new naver.maps.CustomControl(locationBtnHtml, {
                    position: naver.maps.Position.RIGHT_TOP
                });

                customControl1.setMap(map);
            });
            
            naver.maps.Event.once(map, 'init', function() {                
                var customControl2 = new naver.maps.CustomControl(arountBtnHtml, {
                    position: naver.maps.Position.TOP_CENTER
                });

                customControl2.setMap(map);
            });
            
            detailInfoString.appendTo(map.getElement());
            
            
        }
        
        function activateSetCoor() {
        	if(bSetCoor==false) {
        		bSetCoor=true;
        	} else {
        		bSetCoor=false;
        	}
        }
        
        function getCenterCoor() {
        	/* getCenter()
        	지도의 중심 좌표를 반환합니다.
        	getCenterPoint()
        	지도의 중심 좌표를 세계 좌표로 변환한 결과를 반환합니다. */
        	var center = map.getCenter();
        	        	
        	centerLat = center['_lat'];
        	centerLon = center['_lng'];
        	        	
        	markerCenter.setPosition({lat:centerLat,lng:centerLon});
        }
        
        function setRadius() {        	
        	var bOverRange = false;
        	if(map.getZoom() < 19) {
        		bOverRange = true;
        	}
        	
        	var bounds = map.getBounds(),
	            southWest = bounds.getSW(),
	            northEast = bounds.getNE();
        	
        	//console.log("select * from (select * from cafe_list where lat between " + southWest['_lat'] + " and " + northEast['_lat'] + ") where lon between " + southWest['_lng'] + " and " + northEast['_lng']+ ";");
        	
        	$.ajax({			
    			url: '/map/getAround',
    			type: 'POST',
    			data: {swLat : southWest['_lat'],
            		   swLon : southWest['_lng'],
            		   neLat : northEast['_lat'],
            		   neLon : northEast['_lng'],
            		   bBroad : bOverRange,        				
    				  },            	
    			dataType: 'text',			
    			success: function(json){    				
    				var result = JSON.parse(json);    				
    				if(result.code == "success"){
    					setMarker(result);
    				} else {
    					alert(result.desc);    				
    				}
    			}
    		});
        	
        	// 거리 계산을 위한 코드(거리 부정확)
        	/* var numLon = 0.0009*5;
        	var numLat = 0.0011*5;
        	var leftLon = centerLon-numLon;
        	var rightLon = centerLon+numLon;
        	var topLat = centerLat-numLat;
        	var bottomLat = centerLat+numLat;
        	
        	console.log(leftLon + " / " + rightLon + "\n<br> / " + topLat + " / " + bottomLat); */
        }
        
        var markers = [];
        var infoWindows = [];
        var detailInfos = [];
        var index = null;
        var infoString = "";
        
       	function setMarker(json) {       		       		
       		if(markers!=[]) {       			
       			for (var i = 0, len = markers.length; i < len; i++) {       		
       				markers[i].setMap(null);       				
           			}
       			markers = [];
       			infoWindows = [];
       			index = null;
       		}
       		
       		for(data in json['datas']){
       			
       			var totAddr = null;
       			var addr = "";
       			
       			if('name', json['datas'][data]['addrstreet']!='nan') totAddr= json['datas'][data]['addrstreet'];
       			else totAddr = json['datas'][data]['addrdong'];
       		
       			var addrSplited = totAddr.split(' ');
       		
       			for (let i=0; i<4; i++){
       				addr += addrSplited[i]+' ';       		
       			}
       			addr = addr.substring(0, addr.length-1);
       			addr = addr.replace(",", "");
       			
       			var aroundCoor = new naver.maps.LatLng(json['datas'][data]['lat'], json['datas'][data]['lon']);
       			
       			var markerAround = new naver.maps.Marker({
                    map: map,
                    position: aroundCoor,
                    icon: {url : IMG_PATH+"/CafeLocIcon-removebg-preview.png",
                    	   size : new naver.maps.Size(50, 52),
                    	   origin: new naver.maps.Point(0, 0),
                           anchor: new naver.maps.Point(25, 26),
                           scaledSize: new naver.maps.Size(50, 52),
                           title: json['datas'][data]['name'],
                    	   }
                });
       			
       			markers.push(markerAround);
       			
       			infoString = [
       				'<center>',
       	            '<div class="iw_inner" style="width:300px;">',
       	            '   <h4>'+json['datas'][data]['name']+'</h4>',
       	         	'   <div><img src="'+ IMG_PATH +'/CafeLogo3.png" width="60" height="60" alt="로고" class="thumb" style="float:left;" /></div>',
       	            '   <div style="width: 240px; float:left;"><span style="border-bottom:1px solid black">'+addr+'</span><br><span>평점 : '+json['datas'][data]['score']+'</span></div>',       	            
       	            '       <button onclick="showDetailInfo()">메뉴보기</button>&nbsp&nbsp',       	            
       	            '<p>',
       	            '</div>',
       	            '</center>'
       	        ].join('');
       			       			
       			cafeinfo = new naver.maps.InfoWindow({
                    content: infoString,
                    maxWidth: 300,
                    backgroundColor: "#f5fffa",
                    borderColor: "#5f9ea0",
                    borderWidth: 5,
                    anchorSize: new naver.maps.Size(30, 30),
                    anchorSkew: true,
                    anchorColor: "#eee",
                    pixelOffset: new naver.maps.Point(20, -20)
                });
       			
       			infoWindows.push(cafeinfo);
       			
       			let detailInfo = new Map();
       			
       			detailInfo.set('cno', json['datas'][data]['cno']);
       			detailInfo.set('name', json['datas'][data]['name']);	
       			detailInfo.set('addr', addr);
       			       			
       			detailInfos.push(detailInfo)
       		}
       		for(let i=0; i<infoWindows.length; i++){
   			    naver.maps.Event.addListener(markers[i], "click", function(e) {
   			    	index = i;   			    	
   			    	
   			        if (infoWindows[i].getMap()) {
   			        	infoWindows[i].close();
   			        	openedInfoWindows = null;
   			        } else {
   			        	openedInfoWindows = infoWindows[i]
   			        	infoWindows[i].open(map, markers[i]);   			        	
   			        }       			        
   			    });
   			}
       		console.log("MarkedCount : "+markers.length);
       		console.log("InfoSetCount : "+infoWindows.length);
       	}
       	
        var drinkInfos = [];
		
		function showDetailInfo() {			
			var cno = detailInfos[index].get("cno");
			var name = detailInfos[index].get("name");
			console.log(cno + " : " + name);
			$('#cno_hidden').val(cno);
			
			
			if(document.getElementById("menu_info_wrap").offsetLeft>0) {				
				if($('#menu_title').text()!=name){					
					initDetailInfo();
				} else {
					hideInfo();
					$('#order_btn').css('left', '-100%');
					return;
				}				
			}
			
			$.ajax({			
    			url: '/map/getmenu',
    			type: 'POST',
    			data: {cno : cno},            	
    			dataType: 'text',			
    			success: function(json){    				
    				var result = JSON.parse(json);    				
    				if(result.code == "success"){
    					var i = 0;    					
    					
    					for(data in result['datas']){
    						
    						var menu = result['datas'][data]['menu'];
    						var price = getPriceString(result['datas'][data]['price']);
    						    						
    						$('#menu_title').text(name);
    						var kind = '';
    						if(result['datas'][data]['kind']=='coffee') kind = 'coffee'; 
    						else if(result['datas'][data]['kind']=='ade') kind = 'ade';
    						else if(result['datas'][data]['kind']=='juice') kind = 'juice';
    						else if(result['datas'][data]['kind']=='tea') kind = 'tea';
    						
    						$('#'+kind).append("<tr class='menu_tr'><td>"+menu+"</td><td>"+price+"</td><td><a onclick='toCart(\""+i+"\");'><img id='cart_img' src='/assets/img/cart1.png' alt='Bootstrap'></a></td></tr>");
    						
    						var drinkInfo = new Map();
    						drinkInfo.set('menu', menu);
    						drinkInfo.set('price', price);
    						drinkInfo.set('kind', kind);
    						
    						drinkInfos.push(drinkInfo);
    						i++;
    					}
    					
    				} else {
    					alert(result.desc);    				
    				}
    			}
    		});
			
			showInfo();
			
			if(document.getElementById("menu_info_wrap").offsetLeft<0) showInfo();
			//else hideInfo();			 
			checkCart(cno);
		}
		
		function checkCart(cno) {
			if(document.cookie.indexOf(cno)>-1) {				
				cartItems = getCookie();
				$('#countItem').text(cartItems.size);
				$('#order_btn').css('left', '50px');
			} else {
				$('#order_btn').css('left', '-100%');
			}
		}
       	
       	function getZoomLevel() {
       		console.log(map.getZoom());
       	}
       	
       	function getPriceString(price) {    
	   	    var sResult = price.toString();
			   	    
	   	    if(sResult.length>3) {
	   	      var iRestStr = parseInt(sResult.length % 3);	   	      
	   	      sResult = plusComma(sResult, iRestStr);
	   	    }
	   	    return sResult;
	   	  }
       	
       	function plusComma(str, num) {       		
       	    var result = '';
       	    var frontStr = '';       	    
       	    var restStr = str;

       	    if(num==1||num==2){
       	    	frontStr = str.substring(0,num);
       	   		restStr = str.substring(num);       	      
       	    }
       	    
       	    var iDivided = parseInt(restStr.length / 3);
       	    
       	    for(let i=0; i<iDivided;i++) {
       	      var temp = ','+restStr.substring(i*3,i*3+3);       	      
       	      result = result + temp;       	   	  
       	    }
			if(num==0) result = result.substring(1);
			else result = frontStr+result;

       	    return result+"원";
       	  }
       	
       	function toCart(index) {
       		showmodal();       		
       		console.log(drinkInfos[index].get('menu') + " / " + drinkInfos[index].get('price') + ' / ' + drinkInfos[index].get('kind'));
       		
       		
       		var menu_chosen = drinkInfos[index].get('menu');
       		var price_chosen = drinkInfos[index].get('price');
       		var iPrice = price_chosen.replace(",", "");
       		var kind = drinkInfos[index].get('kind');
       		$('#price_hidden').val(iPrice);
       		$('#kind_hidden').val(kind);
       		$('#menu_chosen').html(menu_chosen);
       		$('#menu_confirm').html('<span id="item_count_totPrice">'+price_chosen+'</span>&nbsp;<span id="totCount">1</span>개 담기');
       		
       		if(kind=='coffee'){       			       			       			
       			$('#add_title1').html('Iced or Hot?');       			
       			$('#add_text11').html('Iced');
       			$('#add_radio11').val('Iced');
       			$('#add_text12').html('Hot');
       			$('#add_radio12').val('Hot');
       			$('#add_title2').html('샷 추가');
       			$('#add_text21').html('없음');
       			$('#add_radio21').val('없음');
       			$('#add_text22').html('1샷 추가');
       			$('#add_radio22').val('1샷 추가');
       			$('#add_text23').html('2샷 추가');
       			$('#add_radio23').val('2샷 추가');       			
       		} else if(kind=='ade'){
       			$('#add_wrap1').css('display', 'none');       			
       			$('#add_wrap2').css('display', 'none');
       			$('#menu_confirm').css('margin', '20px');       			
       		} else if(kind=='juice'){
       			$('#add_wrap1').css('display', 'none');
       			$('#add_title2').html('샷 추가');
       			$('#add_text21').html('정량');
       			$('#add_radio21').val('정량');
       			$('#add_text22').html('반만');
       			$('#add_radio22').val('반만');
       			$('#add_text23').html('1펌프 추가');
       			$('#add_radio23').val('1펌프 추가');
       		} else {
       			$('#add_title1').html('Iced or Hot?');       			
       			$('#add_text11').html('Iced');
       			$('#add_radio11').val('Iced');       			
       			$('#add_text12').html('Hot');
       			$('#add_radio12').val('Hot');
       			$('#add_wrap2').css('display', 'none');       			
       		}
       	}
       	
       	function getRadioVal(num) {
       		var choice = document.getElementsByName('choice'+num);
   			var choice_value;
   			for(var i=0; i<choice.length; i++) {    
   					if(choice[i].checked) {        
   						choice_value = choice[i].value;       						
   					}
   			}
   			return choice_value;
       	}
       	
       	function makeCartItem() {
       		var menuName = $('#menu_chosen').text();
       		var choice1_value = null;
   			var choice2_value = null;
   			var totPrice = $('#item_count_totPrice').text();
			var totCount = $('#totCount').text();
			
			var kind = $('#kind_hidden').val();
			
			if(kind=='coffee'){
				choice1_value = getRadioVal("1");
	   			choice2_value = getRadioVal("2");	   			
       		} else if(kind=='ade'){       			
       			choice1_value = null;
	   			choice2_value = null;	   			
       		} else if(kind=='juice'){       			
       			choice1_value = null;
	   			choice2_value = getRadioVal("2");	   			
       		} else {       			
       			choice1_value = getRadioVal("1");
	   			choice2_value = null;	   			
       		}
			
   			console.log(choice1_value + " / " + choice2_value + " / " + totPrice + " / " + totCount);
   			var data = "['" + menuName + "', '"+ choice1_value + "', '" + choice2_value + "', '" + totPrice + "', '" + totCount + "']";
   			
   			setCookie(data);
   			hidemodal();
   			console.log($("#cno_hidden").val())
   			checkCart($("#cno_hidden").val());
   			
       	}
       	
    	function resize(){    		
    	    var mapWidth = window.innerWidth;
    	    mapHeight = window.innerHeight  - document.getElementById('appHead').offsetHeight 
    	                                        - document.getElementById('appFooter').offsetHeight;
    	    
    	    /* menu_info_wrap_width = document.getElementById("menu_tot_wrap").offsetWidth - document.getElementById("menu_select_wrap").offsetWidth;        	
    	    console.log(menu_info_wrap_width); */
    	    
    	    footerHeight = document.getElementById('appFooter').offsetHeight;
    	    headerHeight = document.getElementById('appHead').offsetHeight;    	    
    	    var Size = new naver.maps.Size(mapWidth, mapHeight);
    	        	    
    	    map.setSize(Size);
    	    $("#map_deactivater").css("height", mapHeight);
    	    $("#map_deactivater").css("width", mapWidth);
    	    $("#menu_order_wrap").css("height", mapHeight);
    	    $("#menu_order_wrap").css("top", headerHeight);
    	    $("#menu_info_wrap").css("height", mapHeight);
    	    $("#appHead").css("width", mapWidth);
    	    $("#appFooter").css("width", mapWidth);    	    
    	    $('#order_btn').css("bottom", footerHeight);
    	    $('#modal').css("bottom", footerHeight);
    	    $("#menu_info_wrap").css("top", headerHeight);
    	    $("#menu_info_wrap").css("height", mapHeight);
    	    $('#menu_btn_account').css('bottom', footerHeight+50);
    	    $('#menu_btn_log').css('bottom', footerHeight);
    	}
       	
       	function initDetailInfo() {
        	hideInfo();
        	hidemodal();
        	$('.menu_tr').remove();
        	$('.kind').slideUp();
        	$('#cat_coffee').html('Coffee&nbsp;&nbsp;▼');
        	$('#cat_ade').html('Ade&nbsp;&nbsp;▼');
        	$('#cat_juice').html('Juice&nbsp;&nbsp;▼');
        	$('#cat_tea').html('Tea&nbsp;&nbsp;▼');
        }
       	
       	function getCookie() {
       	    var cookie_list = document.cookie.split("; ");
       	    console.log(cookie_list);

       	    // 아직 쿠키가 설정되지 않은 경우
       	    if (cookie_list[0] == "") {
       	        return null;
       	    }
       	    
       	    var items = new Map();
       	    
       	 	var cno = $('#cno_hidden').val();
       	 	console.log("--------------");
	    	console.log(cno);
       	 
       	    let j = 0;
       	 	for (var i = 0; i < cookie_list.length; i++) {
	       	 	var now_cookie_list = [];	   	    	
	   	    	now_cookie_list = cookie_list[i].split("=");
	   	    	
	  	         if (now_cookie_list[0].indexOf("item_"+cno)>-1) {
	  	        	console.log("data exist");	  	        	
	  	            item_value = JSON.parse(decodeURI(cookie_list[i].substring(cookie_list[i].indexOf("=") + 1)));	  	            
	  	            items.set("item"+j, item_value);
	  	            console.log(items.get('item'+j));
	  	            j++;
	  	        }
       	 	}
       	 	
       	    for (let i = 0; i < items.size; i++) {
       	    	var item = items.get("item"+i);
       	               	        
       	        var infos = item.split("'");       	     	
       	    }       	    
       	    
       	    return items;
       	}
       	
       	function setCookie(data) {
       		/* var date = new Date();
       		date.setDate(date.getDate() + 1); */
       		var date = new Date();
       		date.setTime(date.getTime() + 30*60*1000);
       		
   			var bakeCookie = "";       		
       		
       		var cno = $('#cno_hidden').val();
       		var nth = document.cookie.split(cno).length - 1;
       		
       		bakeCookie += "item_"+cno+"_"+nth+"="+encodeURI(JSON.stringify(data))+";";
       		
       		bakeCookie += "expires=" + date.toUTCString();
       		console.log(bakeCookie);
       		document.cookie = bakeCookie;
               		       		
       		console.log("ended");       		
       	}
       	
       	function delCookie() {
       		var cno = $('#cno_hidden').val();
       		
       		var cookie_list = document.cookie.split("; ");
       	    console.log(cookie_list);
       	    
       	    if (cookie_list[0] == "") {
       	        return null;
       	    }
       	           	 	       	 	
	    	console.log(cno);
       	 
       	    
       	 	for (var i = 0; i < cookie_list.length; i++) {
	       	 	var now_cookie_list = [];	   	    	
	   	    	now_cookie_list = cookie_list[i].split("=");
	   	    	
	   	    	if(now_cookie_list[0].indexOf(cno)>-1) {
	   	    		console.log(now_cookie_list[0]);
	   	    		
	   	    		var date = new Date();
	   	       		date.setDate(date.getDate() - 1);

	   	       		var bakeCookie = "";
	   	       		bakeCookie += now_cookie_list[0]+"=;";
	   	       		bakeCookie += "Expires=" + date.toUTCString();
	   	       		
	   	       		document.cookie = bakeCookie;	   	       		
	   	    	}	  	        
       	 	}
       	 	console.log(document.cookie);
	     	checkCart(cno);
       	}
       	
       	function loginCheck() {
       		if(auth=="[ROLE_ANONYMOUS]"){
       			console.log("Not Logined");	
       			bLogined = false;
       		} else {       			
       			console.log("logined");
       			bLogined = true;
       			document.getElementById("menu_btn_log").classList.replace('fa-right-to-bracket', 'fa-power-off');
       			$('#menu_btn_log').attr('onclick', 'location.href="/logout"');
       			$('#menu_btn_log').attr('title', '로그 아웃');
       		}
       	}
       	
       	function getInfosToPay() {
       		if($('#orderTotPrice').text()=='0'){
       			alert("주문할 음료를 선택해주세요.");
       			return;
       		}
       		if(!bLogined) {
       			alert("회원만 주문할 수 있습니다. 로그인 페이지로 이동합니다.");
       			location.href="/loginform";
       		}
       		
       		finalTotPrice = orderTotPrice;
       		finalTotCount = 0;	
   			for (let i = 0; i < cartItems.size; i++) {   				   				
   				if($("#cartChk_"+i).is(':checked')){
   					console.log(finalTotCount);
   					console.log("+카운트");
   					console.log(parseInt($('#cart_item_count'+i).text()));
   					finalTotCount += parseInt($('#cart_item_count'+i).text());
   				}
   				
   			}
       		console.log("총 잔 수 : "+finalTotCount);
       		
       		finalMenuName = $("#cart_menu_name_0").text();
       		if(cartItems.size > 1) finalMenuName += " 외 "+(cartItems.size-1)+"건";
       		finalMenuName += "(총 "+finalTotCount+"잔)";
       		console.log(finalMenuName);
       		
       		$.ajax({			
    			url: '/member/myinfojson',
    			type: 'POST',
    			data: {mId : mid},            	
    			dataType: 'text',			
    			success: function(json){    				
    				var result = JSON.parse(json);
    				console.log(result);
    				if(result.code == "success"){
    					console.log(result['data']['mPnum']);
    					var mId = result['data']['mId'];
    					var mName = result['data']['mName'];
    					var mPnum = result['data']['mPnum'];    					
    					var mEmail = result['data']['mEmail'];
    					toPayProcess(mId, mName, mPnum, mEmail);
    				} else {
    					alert(result.desc);    				
    				}
    			}
    		});
       	}
       	
       	function toPayProcess(mId, mName, mPnum, mEmail) {
       		var mid = $("#mid").val();
       		var user_name = $("#mname").val();
       		var user_pnum = $("#mpnum").val();
       		var user_email = $("#memail").val();
       		var cno = $("#cno_hidden").val();
       		var total = $("#total").val();
       		
       		
       		try {
       				var response = Bootpay.requestPayment({
       					  "application_id": "62e767dcd01c7e001e33b1f2",
       					  "price": finalTotPrice,
       					  "order_name": finalMenuName,
       					  "order_id": "TEST_ORDER_ID",
       					  "pg": "나이스페이",
       					  "method": "카드",
       					  "tax_free": 0,
       					  "user": {
       					    "id": mId,
       					    "username": mName,
       					    "phone": mPnum,
       					    "email": mEmail
       					  },
       					  "items": [
       					    {
       					      "id": cno,
       					      "name": finalMenuName,
       					      "qty": 1,
       					      "price": finalTotPrice
       					    }
       					  ],
       					  "extra": {
       					    "open_type": "iframe",
       					    "card_quota": "0,2,3",
       					    "escrow": false
       					  }
       					}).then(function(res){
       						console.log("---res---");
       						console.log(res);
       						console.log(res.data);
       						if(res.data.status_locale=="결제완료"){
       							alert("결제가 완료되었습니다.");
       						} else {
       							alert("결제를 완료하지 못 하였습니다.");
       						}
       						var name = res.data.order_name;
       						console.log(name);       						
       						//updateHistoryDB(finalMenuName, finalTotPrice, finalTotCount, mId, mName, mPnum, mEmail, cno);
       						updateHistoryDB(res.data.order_name, finalTotPrice, finalTotCount, mId, mName, mPnum, mEmail, cno);
       					})
       		} catch (e) {
       		    // 결제 진행중 오류 발생
       		    // e.error_code - 부트페이 오류 코드
       		    // e.pg_error_code - PG 오류 코드
       		    // e.message - 오류 내용
       		    console.log(e.message)
       		}
       	}
       	
       	function updateHistoryDB(item_Name, price, cupCount, mId, mName, mPnum, mEmail, cno) {
       		$.ajax({			
    			url: '/member/addhistory',
    			type: 'POST',
    			data: {item_Name: item_Name,
    				price: price,
    				cupCount: cupCount,
    				mId: mId,
    				mName: mName,
    				mPnum: mPnum,
    				mEmail: mEmail,
    				cno: cno},            	
    			dataType: 'text',			
    			success: function(json){    				
    				var result = JSON.parse(json);    				
    				if(result.code == "success"){
    					console.log(result.desc);
    					delCookie();
    				} else {
    					console(result.desc);    				
    				}
    			}
    		});	
       	}
       	
       	function showJustPaid(item_Name, price, cupCount, mId, mName, mPnum, mEmail, cno) {
       		$('#thanks_text').html('<strong>저희 '+$('#menu_title').val()+'에 주문해주셔서 고맙습니다.<br>정성을 다해 준비하겠습니다.</strong><hr>')
       		$('#item_Name').text(item_Name);
       		$('#mId').text(mId);
       		$('#mName').text(mName);
       		$('#mPnum').text(mPnum);
       		$('#justPaid_wrap').css('top', '30%');
       		$('#map_deactivater').css('top', '30%');
       	}
       	
       	function showJustPaid() {
       		$('#justPaid_wrap').css('top', '30%');
       		$('#map_deactivater').css('top', '30%');
       	}
       	       	
       	function hideJustPaid() {
       		$('#justPaid_wrap').css('top', '-100%');
       		$('#map_deactivater').css('top', '-100%');
       	}
    </script>
    
    
    <input type="hidden" id="x" value="${x }">
    <input type="hidden" id="y" value="${y }">
    <span id="mid_hidden" style="display:none;"><sec:authentication property="name"/></span>
    <span id="auth_hidden" style="display:none;"><sec:authentication property="authorities"/></span>
    <header id="appHead">
    <nav class="navbar navbar-expand-lg navbar-light bg-light">    
	  <div class="fa-solid fa-house" style="width: 40px; height:40px; font-size:30px; padding:5px;  cursor: pointer;" onclick="location.href='/map'"></div>  
	</nav>    
    </header>
    <div id="map" style="width: 100%; height: 200px; position: relative; overflow: hidden;">        
    </div>
    <footer id="appFooter" style="z-index: 1500;">
    <!-- 	<center><p>@마실텐데</p><p>서울특별시 종로구 삼일대로17길 51 스타골드빌딩 3층,4층,5층</p></center> -->
    </footer>      
</body>
</html>