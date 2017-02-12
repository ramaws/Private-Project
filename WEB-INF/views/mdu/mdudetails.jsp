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
<title>MDU Details</title>
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
<script>
var timeAgoTagAndTimeStamp = [];
function addItemToObject(tag,timestamp){
	var isNotexist = false;
	for(i=0;i<timeAgoTagAndTimeStamp.length;i++){
		if(timeAgoTagAndTimeStamp[i].tag == tag){
		   isNotexist = true;
		   timeAgoTagAndTimeStamp[i].timestamp = timestamp ;
		}
	}
	if(!isNotexist){
		timeAgoTagAndTimeStamp.push({tag:tag,timestamp:timestamp});
	}
}
var tdExistingDataStore = [];
function addExistingData(toolId,tdData){
	var isNotexist = false;
	for(i=0;i<tdExistingDataStore.length;i++){
		if(tdExistingDataStore[i].id == toolId){
		   isNotexist = true;
		   tdExistingDataStore[i].tdData = tdData ;
		}
	}
	if(!isNotexist){
		tdExistingDataStore.push({id:toolId,tdData:tdData});
	}
}
function convertGMTDateToLocalDateISOFormat(tagId,dateinTimeStamp){
	var localTimeZonedate = new Date(dateinTimeStamp);
	localTimeZonedate.setUTCFullYear(localTimeZonedate.getFullYear(), localTimeZonedate.getMonth(), localTimeZonedate.getDate());
	localTimeZonedate.setUTCHours(localTimeZonedate.getHours(), localTimeZonedate.getMinutes(), localTimeZonedate.getSeconds(), localTimeZonedate.getMilliseconds());
	var localtimezoneOffset = new Date().toString().match(/([-\+][0-9]+)\s/)[1];
	var localDateAndTime = localTimeZonedate.toISOString().split("Z")[0]+localtimezoneOffset;
	$("#" + tagId).html(localDateAndTime);
}
function convertGMTDateToLocalDateAndUpdate(tagId, dateinTimeStamp) {
	var timeAgoVal = "";
	var seconds = Math.floor((new Date() - dateinTimeStamp) / 1000);
	var interval = Math.floor(seconds / 31536000);
	if (interval >= 1) {
		if(interval > 1){
		timeAgoVal = interval + " years ";
		}else {
			timeAgoVal = interval + " year ";
		}
	} else {
		interval = Math.floor(seconds / 2592000);
		if (interval >= 1) {
			if(interval > 1){
			timeAgoVal = interval + " months ago";
			}else{
				timeAgoVal = interval + " month ago";
			}
		} else {
			interval = Math.floor(seconds / 86400);
			if (interval >= 1) {
				if(interval > 1){
				timeAgoVal = interval + " days ago";
				}else{
					timeAgoVal = interval + " day ago";	
				}
			} else {
				interval = Math.floor(seconds / 3600);
				if (interval >= 1) {
					if(interval > 1){
					timeAgoVal = interval + " hours ago";
					}else{
						timeAgoVal = interval + " hour ago";
					}
				} else {
					interval = Math.floor(seconds / 60);
					if (interval >= 1) {
						if(interval > 1){
						timeAgoVal = interval + " minutes ago";
						}else{
							timeAgoVal = interval + " minute ago";
						}
					} else {
						timeAgoVal = "less than a minute ago.";
					}
				}
			}

		}

	}
	if(timeAgoVal.includes("minute") || timeAgoVal.includes("hour") ){
		addItemToObject(tagId,dateinTimeStamp);
		}
	$("#" + tagId).html(timeAgoVal);
}
</script>
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
				</div>
			</c:if>
		</div>
		<c:choose>
			<c:when test="${empty data}">
			MDUs Not Found .. 
    </c:when>
			<c:otherwise>
				<div class="row">
					<sec:authorize access="isAuthenticated()">
						<br>
						<br>
						<div class="" style="text-align: center">
							<span class="headerText">MDU Details</span>
						</div>
						<div id="bc1" class="btn-group btn-breadcrumb">
							<a class="btn btn-primary" href="<c:url value='/mdus' />">MDU
								List</a> <a style="pointer-events: none; cursor: default;" href="#"
								class="btn btn-primary"> ${data.mdu.id} </a>
						</div>
					</sec:authorize>
					<sec:authorize access="isAnonymous()">
						<div class="col-lg-12">
							<h3
								style="padding: 5px; background-color: dodgerblue; color: white;">
								MDU Details</h3>
						</div>
					</sec:authorize>
				</div>
				<br>

				<!--  Evaluate the MDU runningState and action  -- start -->

				<sec:authentication property="principal" var="principal" />
				<sec:authorize access="isAuthenticated()">
					<c:set var="user_auth" value="${principal.token}" />
				</sec:authorize>
				<sec:authorize access="isAnonymous()">
					<c:set var="user_auth" value="${data.mdu_token}" />
				</sec:authorize>
				<!-- Read socket url connection url from the properties file -->
				<spring:eval var="socketUrl"
					expression="@applicationProperties.socketUrl" />
				<spring:eval var="platformUrl"
					expression="@applicationProperties.platformUrl" />
				<c:url value="/j_spring_security_logout" var="logoutUrl" />
				<c:set var="toolStatus" value="${data.toolStatus}" />
				<c:set var="workPiece" value="${data.workPieces}" />
				<c:set var="mdurunningStatus" value="${data.mdu.runningState.id}" />
				<c:set var="actionState" value="ERROR" />
				<c:set var="mduStartButton"
					value=" disabled=disabled class=startbuttonDis" />
				<c:set var="mduStopButton"
					value=" disabled=disabled class=stopbuttonDis" />
				<c:choose>
					<c:when
						test="${fn:containsIgnoreCase(data.mdu.runningState.id, 'RUNNING')}">
						<c:set var="actionState" value="STOP" />
						<c:set var="mduStopButton"
							value=" name=${data.mdu.id} class=stopbutton" />
					</c:when>
					<c:when
						test="${fn:containsIgnoreCase(data.mdu.runningState.id, 'IDLE')}">
						<c:set var="actionState" value="START" />
						<c:set var="mduStartButton"
							value="name=${data.mdu.id} class=startbutton" />
					</c:when>
					<c:when
						test="${fn:containsIgnoreCase(data.mdu.runningState.id, 'SYSTEM ERROR')}">
						<c:set var="mdurunningStatus"
							value="${data.mdu.runningState.id}(${data.mdu.runningState.code })" />
					</c:when>
				</c:choose>

				<!-- Evaluate the MDU runningState and action   -- End -->

				<!-- Evaluate the MDU Alerting state and Appropriate Color   -- Start -->

				<c:set var="mduAlertingColorClass" value="class=black" />
				<c:set var="mduAlertingStatus" value="${data.mdu.alertState}" />
				<c:choose>
					<c:when test="${fn:containsIgnoreCase(actionState, 'ERROR')}">
						<c:set var="mduAlertingStatus" value="N/A" />
					</c:when>
					<c:when
						test="${fn:containsIgnoreCase(mduAlertingStatus, 'ALERTING')}">
						<c:set var="mduAlertingColorClass" value="class=red" />
					</c:when>
					<c:when
						test="${fn:containsIgnoreCase(mduAlertingStatus, 'WARNING')}">
						<c:set var="mduAlertingColorClass" value="class=yellow" />
					</c:when>
					<c:when
						test="${fn:containsIgnoreCase(mduAlertingStatus, 'NORMAL')}">
						<c:set var="mduAlertingColorClass" value="class=green" />
					</c:when>
				</c:choose>

				<!--  Evaluate the MDU Alerting state and Appropriate Color   -- End -->

				<div id="mdudetails">
					<table>
						<tr>
							<th>Machine Tool Name</th>
							<th>MDU ID</th>
							<th>MDU Name</th>
							<th>Operating Status</th>
							<th>Alert Status</th>
							<th>Last Alert Status Changed</th>
							<th>Actions</th>
						</tr>
						<tr>
							<td id="machineToolNameData"><c:out
									value="${data.mdu.machineTool.name} (${data.mdu.machineTool.machineToolType.maker}
			        -${data.mdu.machineTool.machineToolType.modelNumber})" />
							</td>
							<td><c:out value="${data.mdu.id}" /></td>
							<td><c:out value="${data.mdu.name}" /></td>
							<td id="RUNNING_${data.mdu.id}"><c:out
									value="${mdurunningStatus}" /></td>
							<td id="ALERT_${data.mdu.id}"
								<c:out value=" ${mduAlertingColorClass}"/>><c:out
									value="${mduAlertingStatus}" /></td>
							<c:choose>
								<c:when test="${mduAlertingStatus ne 'N/A'}">
									<td id="MDU_MODIFIEDDATE_${data.mdu.id}"></td>
									<script type="text/javascript">
						convertGMTDateToLocalDateAndUpdate('<c:out value="MDU_MODIFIEDDATE_${data.mdu.id}"/>',
						'<c:out value="${data.mdu.mduStatus.modifiedDate}"/>');
					</script>
								</c:when>
								<c:otherwise>
									<td id="MDU_MODIFIEDDATE_${data.mdu.id}">N/A</td>
								</c:otherwise>
							</c:choose>
							<td class="noBorder"><input type="button"
								id="mduRunningStateStart_${data.mdu.id}"
								<c:out value="${mduStartButton}"/>> <input type="button"
								id="mduRunningStateStop_${data.mdu.id}"
								<c:out value="${mduStopButton}"/>></td>
						</tr>
					</table>
				</div>
				<br>
				<br>
				<div id="tools">
					<table id="toolsTable">
						<tr>
							<th>Tool Holder No</th>
							<th>Tool Type</th>
							<th>Tool Change Time</th>
							<th>Alert Status</th>
							<th>Last Alert Status Changed</th>
							<th>Actions</th>
						</tr>
						<c:forEach var="tool" items="${data.tools}">
							<tr id="toolRow_${tool.toolholderNumber}">
								<td class="seqNum" id="toolHolerNo_${tool.toolholderNumber}">
									<c:out value="${tool.toolholderNumber}" />
								</td>
								<td id="toolType_${tool.toolholderNumber}">
									<p>
										<c:out
											value="${tool.toolType.modelNumber}
						-${tool.toolType.maker}(${tool.toolType.diameter})" />
										<img class="mdurunningDisable"
											onclick="toolHolderEditFunction(${tool.toolholderNumber},'${tool.id}')"
											alt="Exchnage Tool"
											src="/enterprise/watchdog/resources/img/exchangeTool.png">
									</p>
								</td>
								<td id="TOOL_TIMETOSET_${tool.id}"><script
										type="text/javascript">
					convertGMTDateToLocalDateISOFormat('<c:out value="TOOL_TIMETOSET_${tool.id}"/>',
					'<c:out value="${tool.toolChangeTime}"/>');
				</script></td>
								<td id="TOOL_ALERT_${tool.id}"
									<c:if test="${fn:containsIgnoreCase(toolStatus[tool.id].alertState, 'ALERTING') && toolStatus[tool.id].valid}">
   					<c:out value="class=red"/>
				</c:if>
									<c:if test="${fn:containsIgnoreCase(toolStatus[tool.id].alertState, 'WARNING') && toolStatus[tool.id].valid}">
   					<c:out value="class=yellow"/>
				</c:if>
									<c:if test="${fn:containsIgnoreCase(toolStatus[tool.id].alertState, 'NORMAL') && toolStatus[tool.id].valid}">
   					<c:out value="class=green"/>
				</c:if>>
									<c:choose>
										<c:when test="${toolStatus[tool.id].valid}">
											<c:out value="${toolStatus[tool.id].alertState}" />
										</c:when>
										<c:otherwise>
											<c:out value="N/A" />
										</c:otherwise>
									</c:choose>
								</td>
								<td id="TOOL_MODIFIEDDATE_${tool.id}"><c:choose>
										<c:when test="${toolStatus[tool.id].valid}">
											<script type="text/javascript">
					convertGMTDateToLocalDateAndUpdate('<c:out value="TOOL_MODIFIEDDATE_${tool.id}"/>',
					'<c:out value="${toolStatus[tool.id].modifiedDate}"/>');
				</script>
										</c:when>
										<c:otherwise>
											<c:out value="N/A" />
										</c:otherwise>
									</c:choose></td>
								<td><a class="mdurunningDisable"
									onclick="toolHolderDeleteFunction(${tool.toolholderNumber},'${tool.id}')">
										<span class="glyphicon glyphicon-remove"> </span>
								</a></td>
							</tr>
						</c:forEach>
					</table>
					<button id="NewRow" class="btn btnAddNew mdurunningDisable">New
						Row</button>
				</div>
				<br>
				<br>
				<div id="workPiece" class="workPiece">
					<table style="width: 40%; align: left;">
						<tr>
							<th>WorkPiece Type</th>
						</tr>
						<tr>
							<td id="workPieceData"><c:out
									value="${workPiece.workPieceType.modelNumber}" /> <a
								class="mdurunningDisable" onclick="showWorkPieceModal()"> <span
									class='glyphicon glyphicon-pencil zeon-edit-pencil'></span>
							</a></td>
						</tr>
					</table>
				</div>
			</c:otherwise>
		</c:choose>
		<!-- csrt support -->
		<form action="${logoutUrl}" method="post" id="logoutForm">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
		</form>
	</div>
	<script type="text/javascript">
	function parsediameter(diameter){
		var newDiameter = diameter;
		if(isInt(diameter)){
			newDiameter = parseFloat(diameter).toPrecision(2);
		}
		return newDiameter;
	}
	function isInt(n) {
		   return n % 1 === 0;
		}
$(window).load(function () {
	var mduOperatingStatus = '<c:out value="${mdurunningStatus}" />';
	if(mduOperatingStatus === "RUNNING"){
 	disableAllClicableForRunningStatus();
	}
});

function sessionKeepAlive() {
	var sessionKeepAliveUri = '<c:url value="/keep_alive" />';
	var token = '<c:out value="${pageContext.request.userPrincipal.name}" />';
	$.ajax({
		type : "POST",
		contentType : 'application/json; charset=utf-8',
		url : sessionKeepAliveUri,
		data : token,
		dataType : 'text',
		cache : false,
		timeout : 10000,
		success : function(data, textStatus, jqXHR) {
		},
		error : function(e) {
		},
		done : function(e) {
		}
	});
}	

$(document).ready(function () {
	function fnsec() {
	    // runs every 5 sec and runs on init.
		for(var i=0;i<timeAgoTagAndTimeStamp.length;i++){
			var tagname = timeAgoTagAndTimeStamp[i].tag;
			var currenttagValue = $("#" + tagname).html();
			currenttagValue = currenttagValue.trim();
			if(currenttagValue == "N/A"){}
			else{
			var timeStampAdded = parseInt(timeAgoTagAndTimeStamp[i].timestamp,10);
			convertGMTDateToLocalDateAndUpdate(tagname,timeStampAdded);
			}
		}	
	}
	setInterval(fnsec, 5*1000);
	setInterval(sessionKeepAlive, 900*1000);
	var toolTypeSelectList = "";
	var currentToolHolderNumber = 0;
	var tdExistingData = "";
	var machineToolExistingData = "";
	var workPieceExistingData = "";
	
	$(".noBorder input").click(function () {
		//var mduId = $(this).attr('name');
		var input_id = $(this).attr('id');
		var ids = input_id.split('_');
		if(ids.length < 2) return;
		var mduId = ids[1];
		var divId = this.id;
		$(this).prop("disabled", true);
		var n = divId.startsWith("mduRunningStateStart");
		if (n) {
			/* $(this).prop("class", "startbuttonDis"); */
			sendMduCommand('START',
				mduId);
		} else {
			/* $(this).prop("class", "stopbuttonDis"); */
			sendMduCommand('STOP',
				mduId);
		}
	});
	
	function getNextToolHolderNumber() {
		if (currentToolHolderNumber == 0) {
			$('.seqNum').each(function () {
				$this = parseInt($(this).text());
				if ($this > currentToolHolderNumber)
					currentToolHolderNumber = $this;
			});
		}
		return currentToolHolderNumber += 1;
	}
	
	$('#NewRow').click(function () {
		$("#NewRow").prop("disabled", true);
		var nextSeq = getNextToolHolderNumber();
		var token = '${user_auth}';
		var toolTypeSelectList = "<select id='toolHolder-dropdown_"+nextSeq+"'>";
		var resturl = '${platformUrl}/tool_types';
			$.ajax({
				type : "GET",
				contentType : 'application/json; charset=utf-8',
				url : resturl,
				data : null,
				dataType : 'text',
				headers:{
					'Authorization':token,
					'User-Agent':'EnterpriseWebApp',
					'Accept':'application/json'
				},
				cache : false,
				timeout : 100000,
				success : function (responsedata, textStatus, jqXHR) {
					data = $.parseJSON(responsedata);
					$.each(data, function (index, toolType) {
						toolTypeSelectList += '<option value="' + toolType.id + '">'
						 + toolType.modelNumber + '-'
						 + toolType.maker + '('
						 + parsediameter(toolType.diameter) + ')'
						 + '</option>';
					});
					toolTypeSelectList += "</select>";
					var bootstrapImages = "&nbsp;<a class='mdurunningDisable' onClick='toolNewRowCancel(" + nextSeq
						 + ")'><span class='glyphicon glyphicon-remove-sign'></span></a>";
					bootstrapImages += "&nbsp;<a onClick='toolNewRowConfirm(" + nextSeq
					 + ")'><span class='glyphicon glyphicon-ok'></span></a>";
					var tbodyAppend = '<tr id="toolRow_' + nextSeq + '"><td id="tooldHolder_input_"'+nextSeq
					+'> <input type="number" pattern="[0-9]" min="1" max="99999" name="toolHolderId_New_Name'
						 + nextSeq + '" value ="' + nextSeq + '"></input>'
						 + '</td><td id="toolType_' + nextSeq + '">';
					tbodyAppend += toolTypeSelectList + bootstrapImages
					 + '</td><td>' + 'N/A' + '</td><td>N/A</td><td>' + 'N/A' + '</td>'
					 + '<td id="deleteTool_' + nextSeq + '"><a class="mdurunningDisable" onclick="NewRowDeleteFunction(' + nextSeq
					 + ')"><span class="glyphicon glyphicon-remove"></span></a></td>' + '</tr>';
					$('#toolsTable tbody').append(tbodyAppend);
					sortToolTypes(nextSeq);
					$('#toolHolder-dropdown_'+nextSeq).prop("selectedIndex", 0);
				},
				error : function (request, status, error) {
					console.log("error", error);
				},
				done : function (e) {
					console.log("DONE");
				}
			});
	});
	
	//Create stomp client over sockJS protocol
	var socket = new SockJS("${socketUrl}");
	var socket1 = new SockJS("${socketUrl}");
	var stompClient = Stomp.over(socket);
	var stompClient1 = Stomp.over(socket1);
	var headers = {
		Authorization : '${user_auth}',
		Accept : 'application/json'
	};
	// Callback function to be called when stomp client is connected to server
	var connectCallback = function () {
		stompClient.subscribe("/mdus/tools/status/${data.mdu.id}", renderToolStatus);
	};
	// Callback function to be called when stomp client is connected to server
	var connectCallbackForRunningStatus = function () {
		stompClient1.subscribe("/mdus/runningStatus/${data.mdu.id}", renderRunningStatusUpdate);
	};
	// Callback function to be called when stomp client could not connect to server
	var errorCallback = function (error) {
		alert(error.headers.message);
	};
	stompClient.connect(headers, connectCallback, errorCallback);
	stompClient1.connect(headers, connectCallbackForRunningStatus, errorCallback);
	stompClient.send("/mdus/tools/status/${data.mdu.id}", {}, null);
	stompClient1.send("/mdus/runningStatus/${data.mdu.id}", {}, null);

	$(window).resize(function () {
		ellipses1 = $("#bc1 :nth-child(2)")
			if ($("#bc1 a:hidden").length > 0) {
				ellipses1.show()
			} else {
				ellipses1.hide()
			}
			ellipses2 = $("#bc2 :nth-child(2)")
			if ($("#bc2 a:hidden").length > 0) {
				ellipses2.show()
			} else {
				ellipses2.hide()
			}
	});
	/* setInterval(function() {
	functioname();
	}, 1000 * 60 * 1); */
	
	$('#mduRunningStateID').click(
		function () {
		var mduStatus = $("#mduRunningStateID").attr('value');
		$("#mduRunningStateID").prop('value', 'Please wait ...');
		$("#mduRunningStateID").prop("disabled", true);
		$.ajax({
			type : "POST",
			contentType : 'application/json; charset=utf-8',
			url : '<c:url value="/mdus/${data.mdu.id}/command"/>',
			data : mduStatus,
			dataType : 'text',
			cache : false,
			timeout : 100000,
			success : function (data, textStatus, jqXHR) {
				console.log("SUCCESS: ", data);
			},
			error : function (e) {
				console.log("ERROR: ", e);
			},
			done : function (e) {
				console.log("DONE");
			}
		});
	});

	function sendMduCommand(command, mduId) {
		var commandUri = '<c:url value="/mdus/" />';
		commandUri += mduId + '/command';
		$.ajax({
			type : "POST",
			contentType : 'application/json; charset=utf-8',
			url : commandUri,
			data : command,
			dataType : 'text',
			cache : false,
			timeout : 100000,
			success : function (data, textStatus, jqXHR) {
				console.log("SUCCESS: ", data);
			},
			error : function (e) {
				console.log("ERROR: ", e);
			},
			done : function (e) {
				console.log("DONE");
			}
		});
	}
});
function formSubmit() {
	document.getElementById("logoutForm").submit();
}
function toolEditCancel(toolId) {
	for(var i=0;i<tdExistingDataStore.length;i++){
		var id = tdExistingDataStore[i].id;
		if(toolId == id){
			$('#toolType_' + toolId)
			.html(tdExistingDataStore[i].tdData);
			tdExistingDataStore.splice(i, 1);
		}
		
	}	
	
}
function toolNewRowCancel(toolHolderId) {
	NewRowDeleteFunction(toolHolderId);
}
function NewRowDeleteFunction(toolHolderId) {
	if (confirm("Are you sure want to Delete the tool?")) {
		$("#NewRow").prop("disabled", false);
		$("#toolRow_" + toolHolderId).remove();
	}
}

function showMachineToolsModal() {
	var token = '${user_auth}';
	var resturl = '${platformUrl}/machine_tools/types';
	$.ajax({
		type : "GET",
		contentType : 'application/json; charset=utf-8',
		url : resturl,
		data : null,
		dataType : 'text',
		headers:{
			'Authorization':token,
			'User-Agent':'EnterpriseWebApp',
			'Accept':'application/json'
		},
		cache : false,
		timeout : 100000,
		success : function (data, textStatus, jqXHR) {
			data = $.parseJSON(data);
			var output = '<select id ="machinetool-dropdown">';
			$.each(data, function (index, machineTool) {
				output += '<option value="' + machineTool.id + '">' + machineTool.id
				 + '-' + machineTool.maker
				 + '-' + machineTool.modelNumber
				 + '</option>';
			});
			output += '</select>';
			machineToolExistingData = $('#machineToolNameData').html();
			var bootstrapImages = "&nbsp;<a  onClick='machineToolChangeCancel()'><span class='glyphicon glyphicon-remove-sign'></span></a>";
				bootstrapImages += "&nbsp;<a onClick='machineToolChangeConfirm()'><span class='glyphicon glyphicon-ok'></span></a>" ;
			output += bootstrapImages;
			$('#machineToolNameData').html(output);
		},
		error : function (e) {
			console.log("ERROR: ", e);
		},
		done : function (e) {
			console.log("DONE");
		}
	});
		
}
function showWorkPieceModal() {
	var existingWorkPieceName = $('#workPieceData').text().trim();
	var token = '${user_auth}';
	var resturl = '${platformUrl}/work_piece_types';
	$.ajax({
		type : "GET",
		contentType : 'application/json; charset=utf-8',
		url : resturl,
		data : null,
		dataType : 'text',
		headers:{
			'Authorization':token,
			'User-Agent':'EnterpriseWebApp',
			'Accept':'application/json'
		},
		cache : false,
		timeout : 100000,
		success : function (data, textStatus, jqXHR) {
			data = $.parseJSON(data);
			var output = '<select id ="workpiece-dropdown">';
			$.each(data, function (index, el) {
				if(el.modelNumber == existingWorkPieceName) {
					output += '<option selected value="' + el.id + '">' + el.modelNumber + '</option>';
				} else {
					output += '<option value="' + el.id + '">' + el.modelNumber + '</option>';
				}
			});
			output += '</select>';
			workPieceExistingData = $('#workPieceData').html();
			var bootstrapImages = "&nbsp;<a onClick='workPieceChangeCancel()'><span class='glyphicon glyphicon-remove-sign'></span></a>";
				bootstrapImages += "&nbsp;<a onClick='workPieceChangeConfirm()'><span class='glyphicon glyphicon-ok'></span></a>" ;
			output += bootstrapImages;
			$('#workPieceData').html(output);
		},
		error : function (e) {
			console.log("ERROR: ", e);
		},
		done : function (e) {
			console.log("DONE");
		}
	});
}

function toolHolderEditFunction(toolHolderId, toolId) {
	tdExistingData = $('#toolType_' + toolHolderId).html();
	addExistingData(toolHolderId,tdExistingData);
	var existingtoolTypeId = $('#toolType_' + toolHolderId).text().replace(/\s+/g, '');
	var ToolHolderoutput = "";
	ToolHolderoutput = "<select id='toolHolder-dropdown_"+toolHolderId+"'>";
	var token = '${user_auth}';
	var resturl = '${platformUrl}/tool_types';
	$.ajax({
		type : "GET",
		contentType : 'application/json; charset=utf-8',
		url : resturl,
		data : null,
		dataType : 'text',
		headers:{
			'Authorization':token,
			'User-Agent':'EnterpriseWebApp',
			'Accept':'application/json'
		},
		cache : false,
		timeout : 100000,
		success : function (responsedata, textStatus, jqXHR) {
			data = $.parseJSON(responsedata);
			$.each(data, function (index, toolType) {
				var toolTypeValue = toolType.modelNumber + '-'
					 + toolType.maker + '(' + parsediameter(toolType.diameter)
					 + ')';
				if(existingtoolTypeId == toolTypeValue.trim()){
					ToolHolderoutput += '<option selected value="' + toolType.id + '">'
					 +toolTypeValue
					 + '</option>';
				}else{
				ToolHolderoutput += '<option value="' + toolType.id + '">'
				 +toolTypeValue
				 + '</option>';
				}
			});
			ToolHolderoutput += "</select>";
			ToolHolderoutput += "&nbsp;<a onClick='toolEditCancel(" + toolHolderId
			 + ")'><span class='glyphicon glyphicon-remove-sign'></span></a>";
			ToolHolderoutput += "&nbsp;<a onClick='toolExchangeConfirm(" + toolHolderId + ",&quot;"
			 + toolId + "&quot;)'><span class='glyphicon glyphicon-ok'></span></a>";
			$('#toolType_' + toolHolderId).html(ToolHolderoutput);
			sortToolTypes(toolHolderId);
			return true;
		},
		error : function (request, status, error) {
			console.log("error", error);
		},
		done : function (e) {
			console.log("DONE");
		}
	});
}
	function sortToolTypes() {
	    var options = $('#toolHolder-dropdown option');
	    var arr = options.map(function(_, o) {
	        return {
	            t: $(o).text(),
	            v: o.value,
	            s: o.selected
	        };
	    }).get();
	    arr.sort(function(o1, o2) {
	        return o1.t > o2.t ? 1 : o1.t < o2.t ? -1 : 0;
	    });
	    options.each(function(i, o) {
	        if(arr[i].s){
	        	o.selected = arr[i].s;	
	        }
	        o.value = arr[i].v;
	        $(o).text(arr[i].t);
	    });
	}
	function sortWorkpieceTypes() {
	    var options = $('#workpiece-dropdown option');
	    var arr = options.map(function(_, o) {
	        return {
	            t: $(o).text(),
	            v: o.value,
	            s: o.selected
	        };
	    }).get();
	    arr.sort(function(o1, o2) {
	        return o1.t > o2.t ? 1 : o1.t < o2.t ? -1 : 0;
	    });
	    options.each(function(i, o) {
	        if(arr[i].s){
	        	o.selected = arr[i].s;	
	        }
	        o.value = arr[i].v;
	        $(o).text(arr[i].t);
	    });
	}
// Render Tools Status data from server into HTML, registered as callback
// when subscribing to /mdus/tools/status topic

function renderToolStatus(frame) {
	var mdus = JSON.parse(frame.body);
	var runningvalue = $('#RUNNING_' + mdus.mduId).html();
	if (runningvalue == "RUNNING" || runningvalue == "IDLE") {
		if (mdus.alertState == "ALERTING") {
			$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
				"color" : "red"
			});
		}
		if (mdus.alertState == "WARNING") {
			$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
				"color" : "#7a7a10"
			});
		}
		if (mdus.alertState == "NORMAL") {
			$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
				"color" : "green"
			});
		}
		convertGMTDateToLocalDateAndUpdate("MDU_MODIFIEDDATE_"+mdus.mduId, mdus.tool.modifiedDate);	
	}else{
		$('#MDU_MODIFIEDDATE_' + mdus.mduId).html("N/A").css({
			"color" : "black"
		});
		$('#ALERT_' + mdus.mduId).html("N/A").css({
			"color" : "black"
		});
	}
	var tool = mdus.tool;
	if (tool.alertState == "ALERTING") {
		$('#TOOL_ALERT_' + tool.id).html(tool.alertState).css({
			"color" : "red"
		});
	} else if (tool.alertState == "WARNING") {
		$('#TOOL_ALERT_' + tool.id).html(tool.alertState).css({
			"color" : "#7a7a10"
		});
	} else if (tool.alertState == "NORMAL") {
		$('#TOOL_ALERT_' + tool.id).html(tool.alertState).css({
			"color" : "green"
		});
	} else {
		$('#TOOL_ALERT_' + tool.id).html("N/A").css({
			"color" : "black"
		});
	}
	convertGMTDateToLocalDateAndUpdate("TOOL_MODIFIEDDATE_"+tool.id, tool.modifiedDate);
}
function renderMDUAlertStatus(mdus) {
	if (mdus.alertState == "ALERTING") {
		$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
			"color" : "red"
		});
	}
	if (mdus.alertState == "WARNING") {
		$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
			"color" : "#7a7a10"
		});
	}
	if (mdus.alertState == "NORMAL") {
		$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
			"color" : "green"
		});
	}
	convertGMTDateToLocalDateAndUpdate("MDU_MODIFIEDDATE_"+mdus.mduId, mdus.mduStatus.modifiedDate);		
}
function renderRunningStatusUpdate(runningStatusData) {
	var updateData = JSON.parse(runningStatusData.body);
	var runningStatusVal = updateData.runningStatus.id;
	runningStatusVal = runningStatusVal.trim();
	if(runningStatusVal == "SYSTEM ERROR"){
		var errorcode = updateData.runningStatus.code;
		errorcode = errorcode.trim();
		runningStatusVal +="("+errorcode+")";
	}
	$('#RUNNING_' + updateData.mduId).html(runningStatusVal);
	if (updateData.runningStatus.id === "RUNNING") {
		$("#mduRunningStateStart_" + updateData.mduId).prop("class",
			"startbuttonDis");
		$("#mduRunningStateStart_" + updateData.mduId).prop("disabled", true);
		$("#mduRunningStateStop_" + updateData.mduId).prop("class",
			"stopbutton");
		$("#mduRunningStateStop_" + updateData.mduId).prop("disabled", false);
		renderMDUAlertStatus(updateData);
		disableAllClicableForRunningStatus();
	} else if (updateData.runningStatus.id === "IDLE") {
		$("#mduRunningStateStart_" + updateData.mduId).prop("class", "startbutton");
		$("#mduRunningStateStart_" + updateData.mduId).prop("disabled", false);
		$("#mduRunningStateStop_" + updateData.mduId).prop("class", "stopbuttonDis");
		$("#mduRunningStateStop_" + updateData.mduId).prop("disabled", true);
		renderMDUAlertStatus(updateData);
		enableAllClicableForRunningStatus();
	} else {
		$("#mduRunningStateStart_" + updateData.mduId).prop("class", "startbuttonDis");
		$("#mduRunningStateStart_" + updateData.mduId).prop("disabled", true);
		$("#mduRunningStateStop_" + updateData.mduId).prop("disabled", true);
		$("#mduRunningStateStop_" + updateData.mduId).prop("class", "stopbuttonDis");
		$('#ALERT_' + updateData.mduId).html("N/A").css({
			"color" : "black"
		});
		$('#MDU_MODIFIEDDATE_' + updateData.mduId).html("N/A").css({
			"color" : "black"
		});
		enableAllClicableForRunningStatus();
	}
}




function disableAllClicableForRunningStatus(){
	$(".mdurunningDisable").css({
	   opacity:0.4,
	   cursor:"default"
	});
	$(".mdurunningDisable").each(function () {
		this.style.pointerEvents = 'none';
	});
	
	}
function enableAllClicableForRunningStatus(){
	$(".mdurunningDisable").css({
		opacity:1,
		cursor:"pointer"
	});
	$(".mdurunningDisable").each(function () {
		this.style.pointerEvents = 'auto';
	});
	
	}
function toolExchangeConfirm(toolHolderId, toolId) {
	var toolTypeId = $('#toolHolder-dropdown_'+toolHolderId+' option:selected').val();
	var machineToolId = '<c:out value="${data.mdu.machineTool.id}" />';
	var resturl = '${platformUrl}/machine_tools/${data.mdu.machineTool.id}/tools';
	var token = '${user_auth}';
	var editToolData = {};
	editToolData["toolholder_number"] = toolHolderId + "";
	editToolData["tool_type_id"] = toolTypeId;
	var editToolJsonString = JSON
		.stringify(editToolData);
	$.ajax({
		type : "POST",
		contentType : 'application/json; charset=utf-8',
		url : resturl,
		data : editToolJsonString,
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
			data = $.parseJSON(responsedata);
			var tbodyAppend = '<tr id="toolRow_'+data.toolholderNumber+'">';	
			var toolHolderTd = '<td class="seqNum" id="toolHolerNo_'+data.toolholderNumber+	'">';
				toolHolderTd += data.toolholderNumber+'</td>'
			var toolTypeTd = '<td id="toolType_'+data.toolholderNumber+'">';
				toolTypeTd += '<p>'+data.toolType.modelNumber+'-'+data.toolType.maker+'('+parsediameter(data.toolType.diameter)+')';
				toolTypeTd += "&nbsp; <img class='mdurunningDisable' onclick='toolHolderEditFunction(" + data.toolholderNumber + ",&quot;" + data.id + "&quot;)' alt='Exchnage Tool' src='/enterprise/watchdog/resources/img/exchangeTool.png'>";
				toolTypeTd += '</p></td>';
			var tooltimeToSetDateTd = '<td id="TOOL_TIMETOSET_'+data.id+'"></td>';
			var toolAlertTd = '<td id="TOOL_ALERT_'+data.id+'">N/A</td>';
			var toolmodifiedDateTd ='<td id="TOOL_MODIFIEDDATE_'+data.id+'"></td>';
			var toolDeleteTd = '<td><a class="mdurunningDisable" onclick="toolHolderDeleteFunction('+data.toolholderNumber+',&quot;' + data.id+'&quot;)">';	
				toolDeleteTd += '<span class="glyphicon glyphicon-remove"></span></a></td>';
				tbodyAppend +=toolHolderTd+toolTypeTd+tooltimeToSetDateTd+toolAlertTd+toolmodifiedDateTd+toolDeleteTd;
				tbodyAppend +="</tr>";
			$("#toolRow_"+data.toolholderNumber).remove();
			$('#toolsTable tbody').append(tbodyAppend);
			convertGMTDateToLocalDateISOFormat('TOOL_TIMETOSET_'+data.id,data.toolChangeTime);
			animateDataForTwoSeconds('toolRow_'+data.toolholderNumber);
			/* $("#" + 'TOOL_TIMETOSET_'+data.id).html(data.toolChangeTime); */
			$("#" + 'TOOL_MODIFIEDDATE_'+data.id).html("N/A");
		},
		error : function (request, status, error) {
			console.log("error", error);
		},
		done : function (e) {
			console.log("DONE");
		}
	});
}
function animateDataForTwoSeconds(tagId){
	for(i=0;i<3;i++) {
		$('#'+tagId).fadeIn(300).fadeOut(300).fadeIn(300);
	  }
}
function toolHolderDeleteFunction(toolHolderId, toolId) {
	if (confirm("Are you sure want to Delete the tool?")) {
		var resturl = '${platformUrl}/machine_tools/${data.mdu.machineTool.id}/tools';
		var token = '${user_auth}';
		var deleteToolData = {}
		deleteToolData["tool_id"] = toolId;
		var deleteToolJsonString = JSON
			.stringify(deleteToolData);
		$.ajax({
			type : "DELETE",
			contentType : 'application/json; charset=utf-8',
			url : resturl,
			data : deleteToolJsonString,
			dataType : 'text',
			headers:{
				'Authorization':token,
				'User-Agent':'EnterpriseWebApp',
				'Accept':'application/json'
			},
			cache : false,
			timeout : 100000,
			success : function (data,
				textStatus, jqXHR) {
				$("#toolRow_" + toolHolderId).remove();
			},
			error : function (request, status, error) {
				console.log("error", error);
			},
			done : function (e) {
				console.log("DONE");
			}
		});
	}
}
function toolNewRowConfirm(toolholderId) {
	var toolholderinput = $("input[name=toolHolderId_New_Name"+toolholderId+"]").val();
	var exit = false;
	$('.seqNum').each(function () {
		$this = parseInt($(this).text());
		if($this == toolholderinput) {
			alert("Cannot add a tool with an existing Tool Holder number!");
			exit = true;
		}
	});
	if (exit) {
		return;
	}
	var toolTypeId = $('#toolHolder-dropdown_'+toolholderId+' option:selected').val();
	var selected = $('#toolHolder-dropdown_'+toolholderId+' option:selected').text();
	var resturl = '${platformUrl}/machine_tools/${data.mdu.machineTool.id}/tools';
	var token = '${user_auth}';
	var newToolData = {}
	newToolData["tool_type_id"] = toolTypeId;
	newToolData["toolholder_number"] = toolholderinput;
	var newToolJsonString = JSON
		.stringify(newToolData);
	$.ajax({
		type : "POST",
		contentType : 'application/json; charset=utf-8',
		url : resturl,
		data : newToolJsonString,
		dataType : 'text',
		headers:{
			'Authorization':token,
			'User-Agent':'EnterpriseWebApp',
			'Accept':'application/json'
		},
		cache : false,
		timeout : 100000,
		success : function (responsedata, textStatus, jqXHR) {
			data = $.parseJSON(responsedata);
			var tbodyAppend = '<tr id="toolRow_'+data.toolholderNumber+'">';	
			var toolHolderTd = '<td class="seqNum" id="toolHolerNo_'+data.toolholderNumber+	'">';
				toolHolderTd += data.toolholderNumber+'</td>'
			var toolTypeTd = '<td id="toolType_'+data.toolholderNumber+'">';
				toolTypeTd += '<p>'+data.toolType.modelNumber+'-'+data.toolType.maker+'('+parsediameter(data.toolType.diameter)+')';
				toolTypeTd += "&nbsp; <img class='mdurunningDisable' onclick='toolHolderEditFunction(" + data.toolholderNumber + ",&quot;" + data.id + "&quot;)' alt='Exchnage Tool' src='/enterprise/watchdog/resources/img/exchangeTool.png'>";
				toolTypeTd += '</p></td>';
			var tooltimeToSetDateTd = '<td id="TOOL_TIMETOSET_'+data.id+'"></td>';
			var toolAlertTd = '<td id="TOOL_ALERT_'+data.id+'">N/A</td>';
			var toolmodifiedDateTd ='<td id="TOOL_MODIFIEDDATE_'+data.id+'"></td>';
			var toolDeleteTd = '<td><a class="mdurunningDisable" onclick="toolHolderDeleteFunction('+data.toolholderNumber+',&quot;' + data.id+'&quot;)">';	
				toolDeleteTd += '<span class="glyphicon glyphicon-remove"></span></a></td>';
				tbodyAppend +=toolHolderTd+toolTypeTd+tooltimeToSetDateTd+toolAlertTd+toolmodifiedDateTd+toolDeleteTd;
				tbodyAppend +="</tr>";
			$("#toolRow_" + toolholderId).remove();
			$('#toolsTable tbody').append(tbodyAppend);
			convertGMTDateToLocalDateISOFormat('TOOL_TIMETOSET_'+data.id,data.toolChangeTime);
			animateDataForTwoSeconds('TOOL_TIMETOSET_'+data.id);
			/* $("#" + 'TOOL_TIMETOSET_'+data.id).html(data.toolChangeTime); */
			$("#" + 'TOOL_MODIFIEDDATE_'+data.id).html("N/A");
				alert('Tool Added SuccessFully!');
				$("#NewRow").prop("disabled", false);
		},
		error : function (request, status, error) {
			console.log("error", error);
		},
		done : function (e) {
			console.log("DONE");
		}
	});
}
function machineToolChangeCancel() {
	$('#machineToolNameData').html(machineToolExistingData)
	}
function machineToolChangeConfirm() {
	var machineToolTypeId = $(
			'#machinetool-dropdown').val();
	var mduId = '${data.mdu.id}';
	var resturl = '${platformUrl}/mdus/${data.mdu.id}/machine_tool';
	var token = '${user_auth}';
	var macinetoolData = {}
	macinetoolData["machine_tool_type_id"] = machineToolTypeId;
	var machineToolJsonString = JSON
		.stringify(macinetoolData);
	//alert('resturl : '+resturl+" machineToolJsonString :"+machineToolJsonString);
	$.ajax({
		type : "POST",
		contentType : 'application/json; charset=utf-8',
		url : resturl,
		data : machineToolJsonString,
		dataType : 'text',
		headers:{
			'Authorization':token,
			'User-Agent':'EnterpriseWebApp',
			'Accept':'application/json'
		},
		cache : false,
		timeout : 100000,
		success : function (data,
			textStatus, jqXHR) {
			var selected = $('#machinetool-dropdown option:selected');
			var machineToolOutput = '${data.mdu.machineTool.name} (' + selected.html() + ')';
			var outputmachineToolName = '<a class="mdurunningDisable" onclick="showMachineToolsModal()"> <span class="glyphicon glyphicon-pencil zeon-edit-pencil"></span></a>';
			machineToolOutput += outputmachineToolName;
			$('#machineToolNameData').html(machineToolOutput);
		},
		error : function (request, status,
			error) {
			console.log("machineToolerror " + status, error);
		},
		done : function (e) {
			console.log("DONE");
		}
	});
}
function workPieceChangeCancel() {
$('#workPieceData').html(workPieceExistingData)
}
function workPieceChangeConfirm() {
var workpieceTypeId = $('#workpiece-dropdown').val();
var machineToolId = '${data.mdu.machineTool.id}';
var resturl = '${platformUrl}/machine_tools/${data.mdu.machineTool.id}/work_pieces';
var token = '${user_auth}';
var workPieceData = {}
workPieceData["work_piece_type_id"] = workpieceTypeId;
var workPieceJsonString = JSON.stringify(workPieceData);
$.ajax({
type : "PUT",
contentType : 'application/json; charset=utf-8',
url : resturl,
data : workPieceJsonString,
dataType : 'text',
headers:{
	'Authorization':token,
	'User-Agent':'EnterpriseWebApp',
	'Accept':'application/json'
},
cache : false,
timeout : 100000,
success : function (data, textStatus, jqXHR) {
	var selected = $('#workpiece-dropdown option:selected');
	var output = selected.html();
		output += '<a class="mdurunningDisable" onclick="showWorkPieceModal()"> <span class="glyphicon glyphicon-pencil zeon-edit-pencil"></span></a>';
	$('#workPieceData').html(output);
},
error : function (request, status, error) {
	console.log("Error", error);
},
done : function (e) {
	console.log("DONE");
}
});

}
</script>
</body>
</html>