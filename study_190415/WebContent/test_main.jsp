<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	response.setHeader("Cache-control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>style test</title>

<script type="text/JavaScript">
	var xhrObject; // XMLHttpRequest 객체를 지정할 변수를 전역변수로 선언

	function createXHR() { // XMLHttpRequest 객체를 생성하는 메소드
		if (window.ActiveXObject) { // 웹 브라우저가 IE5.0, IE 6.0인 경우
			xhrObject = new ActiveXObject("Microsoft.XMLHTTP"); // XMLHttpRequest 객체 생성  
		} else if (window.XMLHttpRequest) { // 웹 브라우저가 IE 7.0, 파이어폭스, 사파리, 오페라등의 경우
			xhrObject = new XMLHttpRequest(); // XMLHttpRequest 객체 생성	
		}
	}

	function getData() {

		var form_name = "form_main";
		var user_id = document.forms[form_name].elements["txt_user_id"].value;

		createXHR(); // createXHR 메소드 호춯

		var url = "./testFile.jsp"; // 요청 URL설정
		// var url = "./getUserInfo.jsp"; // 요청 URL 설정

		var reqparam = "user_id=" + user_id;
		xhrObject.onreadystatechange = resGetData; // 응답결과를 처리메소드인 resultProcess()메소드 설정
		xhrObject.open("Post", url, "true"); // 서버의 응답요청 - url 변수에 설정된 리소스를 요청할 준비
		xhrObject.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8"); // POST방식의 경우 반드시 설정
		xhrObject.send(reqparam); // 서버로 요청을 확인
	}

	function resGetData() {
		if (xhrObject.readyState == 4) {
			if (xhrObject.status == 200) {
				var result = xhrObject.responseText;
				var objRes = eval("(" + result + ")");
				var num = objRes.datas.length;
				var res = "<table cellpading='3' cellspacing='0' border='1' width='980'>";
				var resDiv = document.getElementById("div_res");

				if (num < 1) {
					res += "<tr><td width='980' height='100' align='center' style='font-size:50;'>검색 결과가 없습니다.</td></tr>";
				} else {
					for (var i = 0; i < num; i++) {
						var user_id = objRes.datas[i].ID;
						var user_name = objRes.datas[i].NAME;
						var user_phone = objRes.datas[i].PHONE;

						res += "<tr>";
						res += "<td width='980' height='100' align='center' style='font-size:50' bgcolor = '#D0E6FC'>" + user_id + "</td>";
						res += "</tr>";
						res += "<tr>";
						res += "<td width='980' height='100' align='center' style='font-size:50' bgcolor = '#FFFFCC'>" + user_name + "</td>";
						res += "</tr>";
						res += "<tr>";
						res += "<td width='980' height='100' align='center' style='font-size:50' bgcolor = '#FFFFCC'>" + user_phone + "</td>";
						res += "</tr>";
					}
				}
				res += "</table>";
				resDiv.innerHTML = res;
			}
		}
	}

	function searchData() {
		
		var form_name = "form_main";
		var user_id = document.forms[form_name].elements["txt_user_id"].value;
		
		if (user_id == "") {
			alert("user_id를 입력해 주세요~^^a");
			document.forms[form_name].elements["txt_user_id"].focus;
			return
		} else {
			getData();
		}
	}
</script>

</head>
<body>
	<div id='div_main' width='980' height='300' style='visilility: visible; position: absolute; left: 0px; top: 115px; z-index: 1;'>
		<form name="form_main" onSubmit="javascript:return false;">
			<table border='0' width='980' padding='0' spacing='0'>
				<tr>
					<td width='245'></td>
					<td width='245' align='right'><input type='text' name='txt_user_id' size='10' value='' maxlength='10'
						style='width: 240; font-size: 50; text-align: left;'></td>
					<td width='245'><img src='./img/search.gif' width='245' height='100' onclick='javascript:searchData();'></td>
					<td width='245'></td>
				</tr>
			</table>
		</form>
	</div>

	<div id='div_res' style='visilility: visible; position: absolute; width: 980; left: 0px; top: 215px; z-index: 1;'>
		<table border='1' width='980' padding='10' spacing='0'>
			<tr>
				<td align='center' style='width: 950; font-size: 50' bgcolor='#FFFFCC'>결과물</td>
			</tr>
		</table>
	</div>

</body>
</html>