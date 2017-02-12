<!-- Copyright © 2016 Ricoh Co. Ltd. All rights reserved. -->
<!DOCTYPE html>
<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>RICOH FA Solutions</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href='<c:url value="/resources/css/bootstrap.min.css"/>'>
<script src='<c:url value="/resources/js/jquery-1.11.3.min.js"/>'></script>
<script src='<c:url value="/resources/js/bootstrap.min.js"/>'></script>
</head>
<body>
	<div class="container">
		<div class="row" style="margin-top: 20px">
			<div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
				<%-- <img class="img-responsive"
					src="<c:url value='/resources/img/ricoh_logo.png' />" alt="Loading" /> --%>
			</div>
			<div
				class="col-lg-offset-2 col-lg-4 col-sm-offset-2 col-sm-4 col-md-offset-2 col-md-4 col-xs-offset-2 col-xs-4">
				<h1>RICOH FA Solutions</h1>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<h3
					style="padding: 5px; background-color: dodgerblue; color: white;">Log
					in</h3>
			</div>
		</div>
		<div class="row">
			<form name='loginForm' style="margin-bottom: 0;"
				action="<c:url value='j_spring_security_check' />" method='POST'>
				<div class="row">
					<div
						class="col-lg-offset-1 col-lg-2 col-sm-offset-1 col-sm-2 col-md-offset-1 col-md-2 col-xs-offset-1 col-xs-2">
						<%-- <img class="img-responsive"
							src="<c:url value='/resources/img/transform_ricoh.png' />"
							alt="Loading" /> --%>
					</div>
					<div
						class="col-lg-offset-5 col-lg-4 col-sm-offset-5 col-sm-4 col-md-offset-5 col-md-4 col-xs-offset-5 col-xs-4">
						<c:if test="${not empty error}">
							<div class="row">
								<div
									class="alert alert-danger col-lg-10 col-sm-10 col-md-10 col-xs-10">
									<a href="#" class="close" data-dismiss="alert"
										aria-label="close">&times;</a> <strong>${error}</strong>
								</div>
							</div>
						</c:if>
						<div class="row">
							<h5>Account Name</h5>
						</div>
						<div class="row">
							<input class="col-lg-10 col-sm-10 col-md-10 col-xs-10"
								type='text' name='username' value=''>
						</div>
						<br>
						<div class="row">
							<h5>Password</h5>
						</div>
						<div class="row">
							<input class="col-lg-10 col-sm-10 col-md-10 col-xs-10"
								type='password' name='password' value=''>
						</div>
					</div>
				</div>
				<div class="row">
					<div
						class="col-lg-offset-1 col-lg-6 col-sm-offset-1 col-sm-6 col-md-offset-1 col-md-6 col-xs-offset-1 col-xs-6">
					<%-- 	<img class="img-responsive"
							src="<c:url value='/resources/img/imagine_change.png' />"
							alt="Loading" /> --%>
					</div>
					<div
						class="col-lg-offset-1 col-lg-4 col-sm-offset-1 col-sm-4 col-md-offset-1 col-md-4 col-xs-offset-1 col-xs-4">
						<br> <br>
						<div class="row">
							<input
								class="col-lg-8 col-sm-8 col-md-8 col-xs-8 btn-lg  btn-primary"
								name="submit" type="submit" value="Sign In" /> <input
								type="hidden" name="${_csrf.parameterName}"
								value="${_csrf.token}" />
						</div>
						<div class="row">
							<p style="margin-top: 175px;margin-left: -300px">Copyright © 2016 Ricoh Co. Ltd.
								All rights reserved.</p>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
