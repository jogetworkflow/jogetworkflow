<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

                <c:catch var="exception">
                    <c:forEach var="prop" items="${plugin.pluginProperties}" varStatus="rowCounter">
                        <div class="form-row plugin-config">
                            <label for="field1">${prop.label}</label>
                            <span class="form-input">
                                <c:choose>
                                    <c:when test="${prop.type == 'textfield'}">
                                        <c:set var="value" value=""/>
                                        <c:if test="${empty propertyMap[prop.name] && empty defaultPropertyMap[prop.name]}">
                                            <c:set var="value" value="${prop.value}"/>
                                        </c:if>
                                        <c:if test="${!empty propertyMap[prop.name]}">
                                            <c:set var="value" value="${propertyMap[prop.name]}"/>
                                        </c:if>
                                        <input class="full-width" type="text" name="${prop.name}" value="<c:out value="${value}" escapeXml="true" />"/>
                                    </c:when>
                                    <c:when test="${prop.type == 'password'}">
                                        <c:set var="value" value=""/>
                                        <c:if test="${empty propertyMap[prop.name] && empty defaultPropertyMap[prop.name]}">
                                            <c:set var="value" value="${prop.value}"/>
                                        </c:if>
                                        <c:if test="${!empty propertyMap[prop.name]}">
                                            <c:set var="value" value="${propertyMap[prop.name]}"/>
                                        </c:if>
                                        <input class="full-width" type="password" name="${prop.name}" value="<c:out value="${value}" escapeXml="true" />"/>
                                    </c:when>
                                    <c:when test="${prop.type == 'textarea'}">
                                        <c:set var="value" value=""/>
                                        <c:if test="${empty propertyMap[prop.name] && empty defaultPropertyMap[prop.name]}">
                                            <c:set var="value" value="${prop.value}"/>
                                        </c:if>
                                        <c:if test="${!empty propertyMap[prop.name]}">
                                            <c:set var="value" value="${propertyMap[prop.name]}"/>
                                        </c:if>
                                        <textarea class="full-width" name="${prop.name}" cols="60" rows="15">${value}</textarea>
                                    </c:when>
                                    <c:when test="${prop.type == 'checkbox'}">
                                        <c:set var="value" value=""/>
                                        <c:if test="${empty propertyMap[prop.name] && empty defaultPropertyMap[prop.name]}">
                                            <c:set var="value" value="${prop.value}"/>
                                        </c:if>
                                        <c:if test="${!empty propertyMap[prop.name]}">
                                            <c:set var="value" value="${propertyMap[prop.name]}"/>
                                        </c:if>
                                        <c:forEach var="option" items="${prop.options}" varStatus="rowCounter">
                                            <c:set var="checked" value=""/>
                                            <c:forEach var="val" items="${fn:split(value, ',')}">
                                                <c:if test="${val == option}">
                                                    <c:set var="checked" value="checked"/>
                                                </c:if>
                                            </c:forEach>
                                            <input type="checkbox" ${checked} name="${prop.name}" value="${option}"/>&nbsp;${option}<br>
                                        </c:forEach>
                                    </c:when>
                                    <c:when test="${prop.type == 'radio'}">
                                        <c:set var="value" value=""/>
                                        <c:if test="${empty propertyMap[prop.name] && empty defaultPropertyMap[prop.name]}">
                                            <c:set var="value" value="${prop.value}"/>
                                        </c:if>
                                        <c:if test="${!empty propertyMap[prop.name]}">
                                            <c:set var="value" value="${propertyMap[prop.name]}"/>
                                        </c:if>
                                        <c:forEach var="option" items="${prop.options}" varStatus="rowCounter">
                                            <c:set var="checked"><c:if test="${value == option}"> checked</c:if></c:set>
                                            <input type="radio" ${checked} name="${prop.name}" value="${option}"/>&nbsp;${option}<br>
                                        </c:forEach>
                                    </c:when>
                                    <c:when test="${prop.type == 'selectbox'}">
                                        <c:set var="value" value=""/>
                                        <c:if test="${empty propertyMap[prop.name] && empty defaultPropertyMap[prop.name]}">
                                            <c:set var="value" value="${prop.value}"/>
                                        </c:if>
                                        <c:if test="${!empty propertyMap[prop.name]}">
                                            <c:set var="value" value="${propertyMap[prop.name]}"/>
                                        </c:if>
                                        <select class="full-width" name="${prop.name}">
                                        <c:forEach var="option" items="${prop.options}" varStatus="rowCounter">
                                            <c:set var="selected"><c:if test="${value == option}"> selected</c:if></c:set>
                                            <option value="${option}" ${selected}>${option}</option>
                                        </c:forEach>
                                        </select>
                                    </c:when>
                                </c:choose>
                                <c:if test="${!empty defaultPropertyMap[prop.name]}">
                                    <i><fmt:message key="general.plugin.configuration.label.default"/>&nbsp;
                                        <c:choose>
                                            <c:when test="${prop.type == 'password'}">
                                                <fmt:message key="general.plugin.configuration.label.secretContent"/>
                                            </c:when>
                                            <c:otherwise>
                                                ${defaultPropertyMap[prop.name]}
                                            </c:otherwise>
                                        </c:choose>
                                    </i>
                                </c:if>
                            </span>
                        </div>
                    </c:forEach>
                </c:catch>
                <c:choose>
                    <c:when test="${exception != null}">
                        <fmt:message key="general.plugin.configuration.label.pluginNoProperties"/>
                    </c:when>
                    <c:otherwise>
                        <div class="form-buttons">
                            <input type="submit" value="<fmt:message key="general.method.label.submit"/>"/>
                        </div>
                    </c:otherwise>
                </c:choose>