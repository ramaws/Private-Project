<!-- Copyright © 2016 Ricoh Co. Ltd. All rights reserved. -->
<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>

<head>
<title>MDU List</title>
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
	function addItemToObject(tag, timestamp) {
		var isNotexist = false;
		for (i = 0; i < timeAgoTagAndTimeStamp.length; i++) {
			if (timeAgoTagAndTimeStamp[i].tag == tag) {
				isNotexist = true;
				timeAgoTagAndTimeStamp[i].timestamp = timestamp;
			}
		}
		if (!isNotexist) {
			timeAgoTagAndTimeStamp.push({
				tag : tag,
				timestamp : timestamp
			});
		}
	}
	function convertGMTDateToLocalDateAndUpdate(tagId, dateinTimeStamp) {
		var timeAgoVal = "";
		var seconds = Math.floor((new Date() - dateinTimeStamp) / 1000);
		var interval = Math.floor(seconds / 31536000);
		if (interval >= 1) {
			if (interval > 1) {
				timeAgoVal = interval + " years ";
			} else {
				timeAgoVal = interval + " year ";
			}
		} else {
			interval = Math.floor(seconds / 2592000);
			if (interval >= 1) {
				if (interval > 1) {
					timeAgoVal = interval + " months ago";
				} else {
					timeAgoVal = interval + " month ago";
				}
			} else {
				interval = Math.floor(seconds / 86400);
				if (interval >= 1) {
					if (interval > 1) {
						timeAgoVal = interval + " days ago";
					} else {
						timeAgoVal = interval + " day ago";
					}
				} else {
					interval = Math.floor(seconds / 3600);
					if (interval >= 1) {
						if (interval > 1) {
							timeAgoVal = interval + " hours ago";
						} else {
							timeAgoVal = interval + " hour ago";
						}
					} else {
						interval = Math.floor(seconds / 60);
						if (interval >= 1) {
							if (interval > 1) {
								timeAgoVal = interval + " minutes ago";
							} else {
								timeAgoVal = interval + " minute ago";
							}
						} else {
							timeAgoVal = "less than a minute ago.";
						}
					}
				}

			}

		}
		if (timeAgoVal.includes("minute") || timeAgoVal.includes("hour")) {
			addItemToObject(tagId, dateinTimeStamp);
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
						<span><button id="userSignOut" class="btn-md btn-primary usersignout"
								onclick="javascript:formSubmit()">
								<span class="glyphicon glyphicon-off"></span>Sign Out
							</button></span>
					</p>
					<sec:authorize access="hasRole('ROLE_FIELD')">
					<c:url value="/config/tooltypes" var="tooltypeConfigPageUrl" />
					<a href="${tooltypeConfigPageUrl}" >
			<img hspace="4" alt="Configuration" style="position:relative;top:-3px" 
			src="<c:url value='/resources/img/setting_icon.png' />">Configuration</a>
			</sec:authorize>
				</div>
			</c:if>
		</div>
		<div class="row">


			<c:choose>
				<c:when test="${empty mdus}">
       No Mdus are available
    </c:when>
				<c:otherwise>

					<sec:authorize access="isAuthenticated()">
						<br>
						<br>

						<div class="" style="text-align: center">
							<span class="headerText">MDU List</span>
						</div>
						<div id="bc1" class=" btn-breadcrumb" style="margin: 10px 0px">
							<div class="btn btn-primary pull-left disablePointer">
								<a href="#">MDU List</a>
							</div>


						</div>


					</sec:authorize>
					<div style="clear: both"></div>
					<div id="machineTools" class="table-responsive">

						<table class="table">
							<tr>
								<th>Machine Tool Name</th>
								<th>MDU ID</th>
								<th>MDU Name</th>
								<th>Operating Status</th>
								<th>Alert Status</th>
								<th>Last Alert Status Changed</th>
								<th>Actions</th>
							</tr>


							<c:forEach var="mdu" items="${mdus}">
								<c:url value="/machine_tools/${mdu.id}/tools"
									var="detailPageUrl" />
								<c:choose>
									<c:when
										test="${fn:containsIgnoreCase(mdu.runningState.id, 'RUNNING')}">
										<c:set var="actionState" value="STOP" />
										<c:set var="mdurunningStatus" value="${mdu.runningState.id}" />
									</c:when>
									<c:when
										test="${fn:containsIgnoreCase(mdu.runningState.id, 'IDLE')}">
										<c:set var="actionState" value="START" />
										<c:set var="mdurunningStatus" value="${mdu.runningState.id}" />
									</c:when>
									<c:when
										test="${fn:containsIgnoreCase(mdu.runningState.id, 'SYSTEM ERROR')}">
										<c:set var="actionState" value="ERROR" />
										<c:set var="mdurunningStatus"
											value="${mdu.runningState.id}(${mdu.runningState.code })" />
									</c:when>
									<c:when
										test="${fn:containsIgnoreCase(mdu.runningState.id, 'DISCONNECTED')}">
										<c:set var="actionState" value="DISCONNECTED" />
										<c:set var="mdurunningStatus" value="${mdu.runningState.id}" />
									</c:when>
									<c:otherwise>
										<c:set var="actionState" value="ERROR" />
										<c:set var="mdurunningStatus" value="SYSTEM ERROR" />
									</c:otherwise>
								</c:choose>
								<tr>
									<td><c:out value="${mdu.machineTool.name}" /></td>
									<td><span> <c:out value="${mdu.id}" />
									</span> <a href="${detailPageUrl}" class="detailsPage"> </a></td>
									<td><c:out value="${mdu.name}" /></td>
									<td id="RUNNING_${mdu.id}"><c:out
											value="${mdurunningStatus}" /></td>
									<td id="ALERT_${mdu.id}"
										<c:choose>
 											 <c:when test="${fn:containsIgnoreCase(actionState, 'ERROR')}">
    												<c:out value="class=black"/>
  											</c:when>
  											 <c:when test="${fn:containsIgnoreCase(actionState, 'DISCONNECTED')}">
    												<c:out value="class=black"/>
  											</c:when>
  											<c:when test="${fn:containsIgnoreCase(mdu.alertState, 'ALERTING')}">
   												<c:out value="class=red"/>
  											</c:when>
  											<c:when test="${fn:containsIgnoreCase(mdu.alertState, 'WARNING')}">
   												<c:out value="class=#7a7a10"/>
  											</c:when>
  											<c:when test="${fn:containsIgnoreCase(mdu.alertState, 'NORMAL')}">
   												<c:out value="class=green"/>
  											</c:when>
  											<c:otherwise>
   												 <c:out value="class=black"/>
  											</c:otherwise>
										</c:choose>>
										<c:choose>
											<c:when test="${fn:containsIgnoreCase(actionState, 'ERROR')}">
												<c:set var="mduAlertingStatus" value="N/A" />
											</c:when>
											<c:when
												test="${fn:containsIgnoreCase(actionState, 'DISCONNECTED')}">
												<c:set var="mduAlertingStatus" value="N/A" />
											</c:when>
											<c:otherwise>
												<c:set var="mduAlertingStatus" value="${mdu.alertState}" />
											</c:otherwise>
										</c:choose> <c:out value="${mduAlertingStatus}" />
									</td>
									<c:choose>
										<c:when test="${mduAlertingStatus ne 'N/A'}">
											<td id="MDU_MODIFIEDDATE_${mdu.id}"></td>
											<script type="text/javascript">
												convertGMTDateToLocalDateAndUpdate(
														'<c:out value="MDU_MODIFIEDDATE_${mdu.id}"/>',
														'<c:out value="${mdu.mduStatus.modifiedDate}"/>');
											</script>
										</c:when>
										<c:otherwise>
											<td id="MDU_MODIFIEDDATE_${mdu.id}">N/A</td>
										</c:otherwise>
									</c:choose>
									<td class="noBorder"><input type="button"
										id="mduRunningStateStart_${mdu.id}"
										<c:choose>
									<c:when test="${actionState ne 'START'}">
									<c:out value="disabled=disabled class=startbuttonDis"/>
									</c:when>
										<c:otherwise>
										<c:out value="name=${mdu.id} class=startbutton"/>
									</c:otherwise>
										</c:choose> />
										<input type="button" id="mduRunningStateStop_${mdu.id}"
										<c:choose>
									<c:when test="${actionState ne 'STOP'}">
									<c:out value="disabled=disabled class=stopbuttonDis"/>
									</c:when>
										<c:otherwise>
										<c:out value="name=${mdu.id} class=stopbutton"/>
									</c:otherwise>
										</c:choose> />
									</td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
		<c:url value="/j_spring_security_logout" var="logoutUrl" />
		<!-- csrt support -->
		<form action="${logoutUrl}" method="post" id="logoutForm">
			<input type="hidden" name="${_csrf.parameterName}"
				value="${_csrf.token}" />
		</form>


		<spring:eval var="socketUrl"
			expression="@applicationProperties.socketUrl" />
		<spring:eval var="systemVerion"
			expression="@applicationProperties.systemVerion" />
		<footer>

			<p class="footer_text">
				This Page updated at : <span id="pageUpdatedDate"> 12:10</span>
				System Version :
				<c:out value="${systemVerion}" />
			</p>

		</footer>


	</div>


	<script>
		updateTime();
		function updateTime() {
			var today = new Date();
			var time = today.getHours() + ':' + today.getMinutes() + ':'
					+ today.getSeconds();
			document.getElementById('pageUpdatedDate').innerHTML = time;
		}
		function formSubmit() {
			document.getElementById("logoutForm").submit();
		}

		// Render Mdu data from server into HTML, registered as callback
		// when subscribing to Mdu  status
		function renderStatus(frame) {
			var mdu = JSON.parse(frame.body);
			var currentRunningStatus = $('#RUNNING_' + mdu.mduId).html().trim();
			if (currentRunningStatus == "RUNNING"
					|| currentRunningStatus == "IDLE") {
				if (mdu.alertState == "ALERTING") {
					$('#ALERT_' + mdu.mduId).html(mdu.alertState).css({
						"color" : "red"
					});
				} else if (mdu.alertState == "WARNING") {
					$('#ALERT_' + mdu.mduId).html(mdu.alertState).css({
						"color" : "#7a7a10"
					});
				} else if (mdu.alertState == "NORMAL") {
					$('#ALERT_' + mdu.mduId).html(mdu.alertState).css({
						"color" : "green"
					});
				} else {
					$('#ALERT_' + mdu.mduId).html(mdu.alertState).css({
						"color" : "black"
					});
				}
				convertGMTDateToLocalDateAndUpdate('MDU_MODIFIEDDATE_'
						+ mdu.mduId, mdu.mduStatus.modifiedDate);
			} else {
				$('#ALERT_' + mdu.mduId).html("N/A").css({
					"color" : "black"
				});
				$('#MDU_MODIFIEDDATE_' + mdu.mduId).html("N/A").css({
					"color" : "black"
				});
			}
			updateTime();

		}

		function renderMDUAlertStatus(mdus) {
			if (mdus.alertState == "ALERTING") {
				$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
					"color" : "red"
				});
			} else if (mdus.alertState == "WARNING") {
				$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
					"color" : "#7a7a10"
				});
			} else if (mdus.alertState == "NORMAL") {
				$('#ALERT_' + mdus.mduId).html(mdus.alertState).css({
					"color" : "green"
				});
			}
			convertGMTDateToLocalDateAndUpdate(
					'MDU_MODIFIEDDATE_' + mdus.mduId,
					mdus.mduStatus.modifiedDate);
		}

		function renderRunningStatusUpdate(runningStatusData) {
			var updateData = JSON.parse(runningStatusData.body);
			// 			alert(runningStatusData);
			var runningStatusVal = updateData.runningStatus.id;
			runningStatusVal = runningStatusVal.trim();
			if (runningStatusVal == "SYSTEM ERROR") {
				var errorcode = updateData.runningStatus.code;
				errorcode = errorcode.trim();
				runningStatusVal += "(" + errorcode + ")";
			}
			$('#RUNNING_' + updateData.mduId).html(runningStatusVal);
			if (updateData.runningStatus.id === "RUNNING") {
				$("#mduRunningStateStart_" + updateData.mduId).prop("class",
						"startbuttonDis");
				$("#mduRunningStateStart_" + updateData.mduId).prop("disabled",
						true);
				$("#mduRunningStateStop_" + updateData.mduId).prop("class",
						"stopbutton");
				$("#mduRunningStateStop_" + updateData.mduId).prop("disabled",
						false);
				renderMDUAlertStatus(updateData);
			} else if (updateData.runningStatus.id === "IDLE") {
				$("#mduRunningStateStart_" + updateData.mduId).prop("class",
						"startbutton");
				$("#mduRunningStateStart_" + updateData.mduId).prop("disabled",
						false);
				$("#mduRunningStateStop_" + updateData.mduId).prop("class",
						"stopbuttonDis");
				$("#mduRunningStateStop_" + updateData.mduId).prop("disabled",
						true);
				renderMDUAlertStatus(updateData);
			} else {
				$("#mduRunningStateStart_" + updateData.mduId).prop("class",
						"startbuttonDis");
				$("#mduRunningStateStart_" + updateData.mduId).prop("disabled",
						true);
				$("#mduRunningStateStop_" + updateData.mduId).prop("disabled",
						true);
				$("#mduRunningStateStop_" + updateData.mduId).prop("class",
						"stopbuttonDis");
				$('#ALERT_' + updateData.mduId).html("N/A").css({
					"color" : "black"
				});
				$('#MDU_MODIFIEDDATE_' + updateData.mduId).html("N/A").css({
					"color" : "black"
				});
			}
			updateTime();
		}

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
				success : function(data, textStatus, jqXHR) {
					console.log("SUCCESS: ", data);
					//renderStatusUpdate(data);
				},
				error : function(e) {
					console.log("ERROR: ", e);
				},
				done : function(e) {
					console.log("DONE");
				}
			});
		}
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

		// Register handler for add button
		$(document)
				.ready(
						function() {
							function fnsec() {
								// runs every 5 sec and runs on init.
								for (var i = 0; i < timeAgoTagAndTimeStamp.length; i++) {
									var tagname = timeAgoTagAndTimeStamp[i].tag;
									var currenttagValue = $("#" + tagname)
											.html();
									currenttagValue = currenttagValue.trim();
									if (currenttagValue == "N/A") {
									} else {
										var timeStampAdded = parseInt(
												timeAgoTagAndTimeStamp[i].timestamp,
												10);
										convertGMTDateToLocalDateAndUpdate(
												tagname, timeStampAdded);
									}
								}
							}
							setInterval(fnsec, 5 * 1000);
							setInterval(sessionKeepAlive, 900 * 1000);
							updateTime();
							$("input")
									.click(
											function() {
												//var mduId = $(this)
												//		.attr('name');
												//var mduId = $(this).attr('name');
												var input_id = $(this).attr(
														'id');
												var ids = input_id.split('_');
												if (ids.length < 2)
													return;
												var mduId = ids[1];
												var divId = this.id;
												$(this).prop("disabled", true);
												var n = divId
														.startsWith("mduRunningStateStart");
												if (n) {
													/* $(this).prop("class", "startbuttonDis"); */
													sendMduCommand('START',
															mduId);
												} else {
													/* $(this).prop("class", "stopbuttonDis"); */
													sendMduCommand('STOP',
															mduId);
												}
												console.log('MDUID', mduId);
											});
							$(".clickable-row").click(
									function() {
										$("#mduidDetails").prop("disabled",
												true);
										window.document.location = $(this)
												.data("href");
									});
							//Create stomp client over sockJS protocol
							var socket = new SockJS("${socketUrl}");
							var socket1 = new SockJS("${socketUrl}");
							var stompClient = Stomp.over(socket);
							var stompClient1 = Stomp.over(socket1);
							var headers = {
								Authorization : '${pageContext.request.userPrincipal.principal.token}',
								Accept : 'application/json'
							};
							//stompClient.connect(headers)
							// Callback function to be called when stomp client is connected to server
							var connectCallback = function() {
								stompClient.subscribe('/mdus/status',
										renderStatus);
							};

							var connectCallbackForRunningStatus = function() {
								stompClient1.subscribe("/mdus/runningStatus",
										renderRunningStatusUpdate);
							};

							// Callback function to be called when stomp client could not connect to server
							var errorCallback = function(error) {
								console.log("Error : " + error);
							};

							// Connect to server via websocket
							stompClient.connect(headers, connectCallback,
									errorCallback);
							// Connect to server via websocket
							stompClient1.connect(headers,
									connectCallbackForRunningStatus,
									errorCallback);
							stompClient.send("/portal", {}, null);
							//return false;

						});
	</script>
</body>
</html>
