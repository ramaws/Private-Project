<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${(empty statusCode) && ( statusCode ==400)}">
    <h1>400 – Bad Request</h1>	
    <p>he data sent by you doesn’t have the required parameter, <c:out value="errorMessage"></c:out></p>
</c:if>