<!-- Copyright Â© 2016 Ricoh Co. Ltd. All rights reserved. -->
<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<title>Workpiece Type</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href='<c:url value="/resources/css/application.css"/>'>
<link rel="stylesheet"
	href='<c:url value="/resources/css/bootstrap.min.css"/>'>
<script src='<c:url value="/resources/js/jquery-1.11.3.min.js"/>'></script>
<script src='<c:url value="/resources/js/bootstrap.min.js"/>'></script>
<script src='<c:url value="/resources/js/stomp.min.js"/>'></script>
<script src='<c:url value="/resources/js/sockjs-0.3.4.min.js"/>'></script>
<style type="text/css">
/* new css */

td {
   max-width: 50px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    text-align: left !important;
}
#errormsg{
 
  background:#de210c;
  padding:6px 10px;
  border-radius:4px;
  font-size:12px; 
  color:white;

}
.zeroPadding{
 padding:0

}
.rightpadding{
 
  padding-right:10px

}
.mtop{

 margin-top:30px !important

}
table th, table tr td{ padding:10px 18px !important}
button{margin-left:7px}
.container{
 
 padding-bottom:30px
 
}


#sidebar-wrapper {

  width: 100%;
  color: white;
  position: relative ;
  min-height: 300px;
  height:auto;
  z-index: 1;
}
.sidebar-nav {
  
  margin: 0;
  padding: 0;
  width: 100%;
  list-style: none;
}
.sidebar-nav li {
  text-indent: 20px;
  line-height: 50px;
  /* Permalink - use to edit and share this gradient: http://colorzilla.com/gradient-editor/#7abcff+0,60abf8+44,4096ee+100;Blue+3D+%2314 */
background: #7abcff; /* Old browsers */
background: -moz-linear-gradient(top,  #7abcff 0%, #60abf8 44%, #4096ee 100%); /* FF3.6-15 */
background: -webkit-linear-gradient(top,  #7abcff 0%,#60abf8 44%,#4096ee 100%); /* Chrome10-25,Safari5.1-6 */
background: linear-gradient(to bottom,  #7abcff 0%,#60abf8 44%,#4096ee 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-9 */
  
}
.sidebar-nav li a {
  color: white;
  display: block;
  text-decoration: none;
}
.sidebar-nav li a:hover {
  background: rgba(255,255,255,0.25);
  color: white;
  text-decoration: none;
}
.sidebar-nav li a:active, .sidebar-nav li a:focus {
  text-decoration: none;
}
#sidebar-wrapper.sidebar-toggle {
  transition: all 0.3s ease-out;
  
}
@media (min-width: 768px) {
  #sidebar-wrapper.sidebar-toggle {
    transition: 0s;
   
  }
}
.table {
	 width: 100%;
	}

th{
text-align: left !important;
}
.logoSection {
    padding: 5px 0px;
    }	
</style>
</head>
<body>
	<div class="container">
		<div class="row logoSection">
			<div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
				<%-- <img style="max-width: 85%" class="img-responsive"
					src="<c:url value='/resources/img/ricoh_logo.png' />" alt="Loading" /> --%>
			</div>
			<c:if test="${pageContext.request.userPrincipal.name != null}">
				<div class="SigninSignout">
					<p>${pageContext.request.userPrincipal.name}
						<span>
							<button id="userSignOut" class="btn-md btn-primary"
								onclick="javascript:formSubmit()">
								<span class="glyphicon glyphicon-off"></span>Sign Out
							</button>
						</span>
					</p>
					<c:url value="/mdus" var="mdulistPageUrl" />
					<a href="${mdulistPageUrl}" >
			<img hspace="4" alt="Home" style="position:relative;top:-3px" 
			src="<c:url value='/resources/img/Home_icon.png' />">MDU List</a>
				</div>
			</c:if>

		</div>
		<div class="row mtop">
			<div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 zeroPadding rightpadding">
  				<div id="sidebar-wrapper" class="sidebar-toggle">
				<ul class="sidebar-nav">
					<li><a href='<c:url value="/config/tooltypes"/>'>Tool Type</a>
					</li>
					<li class="btnActive"><a href='#'>WorkPiece Type</a></li>
					<li style="display: none;"><a href='<c:url value="/config/machinetooltypes"/>'>Machinetool Type</a></li>
					<li style="display: none;"><a href='<c:url value="/config/machine_tools"/>'>Machinetool-MDU</a>
					</li>
				</ul>
				</div>
			</div>	
			<div class="col-lg-10 col-md-10 col-sm-10 col-xs-10 zeroPadding">
			<div id="workpiecetypeconfig" class="table-responsive">
				<table class="table" id="workpiecetypeconfigTable">
					<tr>
						<th>Model Number</th>
						<th>Material</th>
						<th>Maker</th>
						<th>Name</th>
					</tr>


					<c:forEach var="workpiecetype" items="${workpieceTypes}">
						<tr>
							<td title="${workpiecetype.modelNumber}">${workpiecetype.modelNumber}</td>
							<td title="${workpiecetype.material}">${workpiecetype.material}</td>
							<td title="${workpiecetype.maker}">${workpiecetype.maker}</td>
							<td title="${workpiecetype.name}">${workpiecetype.name}</td>
						</tr>
					</c:forEach>
				</table>
			</div>
			
			<div>
		<span class=" pull-left" id="errormsg"></span>
		<button id="NewRow" class="btn btnAddNew">New Row</button>
		<div id="saveCancel">
		<button id="Cancel" class="btn btnAddNew">Cancel</button>
		<button id="Save" class="btn btnAddNew">Save</button>
		</div>
		</div>
			
			</div>
		</div>
		<spring:eval var="platformUrl"
			expression="@applicationProperties.platformUrl" />
		<sec:authentication property="principal" var="principal" />
		<sec:authorize access="isAuthenticated()">
			<c:set var="user_auth" value="${principal.token}" />
		</sec:authorize>
	<c:url value="/j_spring_security_logout" var="logoutUrl" />
		<!-- csrt support -->
		<form action="${logoutUrl}" method="post" id="logoutForm">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
		</form>	
	</div>
	<script type="text/javascript">
	function formSubmit() {
		document.getElementById("logoutForm").submit();
	}
$(document).ready(function() {
	
	$('.dropdown').on('show.bs.dropdown', function(e){
	    $(this).find('.dropdown-menu').first().stop(true, true).slideDown(300);
	});
	$('.dropdown').on('hide.bs.dropdown', function(e){
		$(this).find('.dropdown-menu').first().stop(true, true).slideUp(300);
	});
	$("#menu-toggle").click(function(e) {
		e.preventDefault();
		var elem = document.getElementById("sidebar-wrapper");
		left = window.getComputedStyle(elem,null).getPropertyValue("left");
		if(left == "200px"){
			document.getElementsByClassName("sidebar-toggle")[0].style.left="-200px";
		}
		else if(left == "-200px"){
			document.getElementsByClassName("sidebar-toggle")[0].style.left="200px";
		}
	});
	hideSaveCancel();
	hideErrorMsg();
	$('#NewRow').click(function () {
		$("#NewRow").prop("disabled", true);
		hideErrorMsg();
		showSaveCancel();
		var tbodyAppend = '<tr id="worpieceTypeConfigNewRow"><td><input name="modelNumber" maxlength="64"></td>'
		+'<td><input name="material" maxlength="64"></td><td><input name="maker" maxlength="64"></td>'
		+'<td><input name="name" maxlength="64"></td>';
		$('#workpiecetypeconfigTable tbody').append(tbodyAppend);
			});
	$('#Save').click(function () {
		var modelNumber = $("input[name=modelNumber").val();
		modelNumber = modelNumber.trim();
		if(isBlank(modelNumber) ){
			showErrorMsg();
			showErrorMessage("Model Number is Mandatory please enter a value");
			hideErrorMessageAfter3Sec();
			$("input[name=modelNumber").focus();
			return;
		}
		var material = $("input[name=material").val();
		material = material.trim();
		if(isBlank(material) ){
			showErrorMsg();
			showErrorMessage("Material is Mandatory please enter a value");
			hideErrorMessageAfter3Sec();
			$("input[name=material").focus();
			return;
		}
		var maker = $("input[name=maker").val();
		maker = maker.trim();
		if(isBlank(maker) ){
			showErrorMsg();
			showErrorMessage("Maker is Mandatory please enter a value");
			hideErrorMessageAfter3Sec();
			$("input[name=maker").focus();
			return;
		}
		var name = $("input[name=name").val();
		name = name.trim();
		if(isBlank(name) ){
			showErrorMsg();
			showErrorMessage("Name is Mandatory please enter a value");
			hideErrorMessageAfter3Sec();
			$("input[name=name").focus();
			return;
		}
		if(confirm("Are you sure want to save the changes?")){
		var workpieceTypeData = {};
		workpieceTypeData["modelNumber"] = modelNumber;
		workpieceTypeData["material"] = material;
		workpieceTypeData["maker"] = maker;
		workpieceTypeData["name"] = name;
		var workpieceTypeDataJson = JSON
			.stringify(workpieceTypeData);
		var platformresturl = '${platformUrl}';
		platformresturl += "/work_piece_types";
		var token = '${user_auth}';
		$.ajax({
			type : "POST",
			contentType : 'application/json; charset=utf-8',
			url : platformresturl,
			data : workpieceTypeDataJson,
			dataType : 'text',
			headers:{
				'Authorization':token,
				'User-Agent':'EnterpriseWebApp',
				'Accept':'application/json'
			},
			cache : false,
			timeout : 100000,
			success : function (responsedata,
				textStatus, jqXHR) {
				var tbodyAppend = '<tr><td title = "'+modelNumber+'">'+modelNumber+'</td>'
				+'<td title = "'+material+'">'+material+'</td><td title = "'+maker+'">'+maker+'</td><td>'+name+'</td>';
				$("#worpieceTypeConfigNewRow").remove();
				$('#workpiecetypeconfigTable tbody').append(tbodyAppend);
				$("#NewRow").prop("disabled", false);
				hideSaveCancel();
				hideErrorMsg();
				
			}, error : function (request, status, error) {
			console.log("error", error);
			}, done : function (e) {
			console.log("DONE");
				}
    	 });
		}
 	});
	
	$('#Cancel').click(function () {
		if(confirm("Are you sure want to cancel the changes?")){
		$("#NewRow").prop("disabled", false);
		hideErrorMsg();
		hideSaveCancel();
		$("#worpieceTypeConfigNewRow").remove();
		}
	});
function hideSaveCancel(){
	$("#saveCancel").hide();
}		
function showSaveCancel(){
	$("#saveCancel").show();
}

function hideErrorMessageAfter3Sec(){
	setTimeout(hideErrorMsg, 10000);
}
function hideErrorMsg(){
	$("#errormsg").hide();
}

function showErrorMsg(){
		$("#errormsg").show();
}

});

function isBlank(str) {
    return (!str || /^\s*$/.test(str));
}

function showErrorMessage(str){
	document.getElementById("errormsg").innerHTML = str;
}

</script>
</body>
</html>