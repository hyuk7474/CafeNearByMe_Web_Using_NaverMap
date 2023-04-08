<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <link rel="stylesheet" href="/assets/css/modal_style.css">    
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.1.0/css/all.css">
  </head>
  
  <body>
<div class="modal">
  <img src="/assets/img/image.jpg" alt="">
  <div class="content">
    <h1>Awesome Modal</h1>
    <p>Lorem Ipsum is simply dummy text of the printing and typesetting industry.</p>
    <a href="#">Read More</a>
  </div>
  <div onclick="hidemodal()" class="hide fas fa-times"></div>
</div>

<a onclick="showmodal()" class="btn" href="#">Show Modal</a>

<script type="text/javascript">
  var modal = document.getElementsByClassName("modal")[0];
  function showmodal() {
    modal.style.bottom = "20px";
  }
  function hidemodal() {
    modal.style.bottom = "-300px";
  }
</script>

  </body>
</html>
