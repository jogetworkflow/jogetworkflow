<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:choose>
    <c:when test="${empty userviewSetupId}">
        <commons:header
            title="wflowClient.userview.new.label.title"
            path1="${pageContext.request.contextPath}/web/admin/userview/list"
            name1="general.tab.designProcess.userview"
            path2="${pageContext.request.contextPath}/web/admin/userview/create"
            name2="wflowClient.userview.list.label.createUserview"
            helpTitle="wflowHelp.userview.new.title"
            help="wflowHelp.userview.new.content"
        />
    </c:when>
    <c:when test="${!empty userviewSetupId}">
        <commons:header
            title="wflowClient.userview.edit.label.title"
            path1="${pageContext.request.contextPath}/web/admin/userview/list"
            name1="general.tab.designProcess.userview"
            path2="${pageContext.request.contextPath}/web/admin/userview/edit/view/${userviewSetupId}"
            name2="wflowClient.userview.edit.label.title"
            helpTitle="wflowHelp.userview.edit.title"
            help="wflowHelp.userview.edit.content"
        />
    </c:when>
</c:choose>

<script type="text/javascript">
    var submit = false;
    var submitExportUserview = false;
    window.onbeforeunload = warning;

    function warning(){
        if(!submit){
            if(!submitExportUserview){
                return "<fmt:message key="wflowClient.userview.msg.closing"/>";
            }else{
                submitExportUserview = false;
                return "<fmt:message key="wflowClient.userview.msg.exportUserView"/>";
            }
        }else{
            submit = false;
        }
    }

    <c:if test="${save == 'true'}">
        submit = true;
    </c:if>
</script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery.jeditable.js"></script>

    <div id="main-body-content">
        <c:if test="${!empty userviewSetupId}">
            <b><fmt:message key="wflowClient.userview.edit.label.linkToPreview"/></b> <br/>
            <a target="blank" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/userview/${userviewSetupId}">${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/userview/${userviewSetupId}</a>
            <br/>
            <br/>
        </c:if>

        <form id="userviewForm" method="POST" action="${pageContext.request.contextPath}/web/admin/userview/submit" class="form">
            <c:forEach items="${errors}" var="error">
                <span class="form-errors"><fmt:message key="${error}"/></span><br/>
            </c:forEach>
            
            <fieldset>
                <legend><fmt:message key="wflowClient.userview.new.label.details"/></legend>
                <div class="form-row">
                    <label><fmt:message key="wflowClient.userview.new.label.id"/></label>
                    <span class="form-input">
                        <c:choose>
                            <c:when test="${empty userviewSetupId}">
                                <input type="text" name="id" id="id"> *
                            </c:when>
                            <c:when test="${!empty userviewSetupId}">
                                ${userviewSetupId}
                                <input type="hidden" name="userviewSetupId" value="${userviewSetupId}">
                            </c:when>
                        </c:choose>
                    </span>
                </div>
                <div class="form-row">
                    <label for="name"><fmt:message key="wflowClient.userview.new.label.name"/></label>
                    <span class="form-input"><input type="text" name="name" id="name"> *</span>
                </div>
                <div class="form-row">
                    <label><fmt:message key="wflowClient.userview.new.label.labelForInbox"/></label>
                    <span class="form-input"><input type="text" name="inboxLabel" id="inboxLabel"></span>
                </div>
            </fieldset>

            <div id="startProcess">
                <div id="main-body-content-subheader" class="collapsible">
                    <span class="collapsibleIcon">[+]</span> <fmt:message key="wflowClient.userview.new.label.startProcess"/>
                </div>
                <div>
                    <div class="form-row">
                        <label><fmt:message key="wflowClient.userview.new.label.selectProcess"/></label>
                        <span class="form-input">
                            <select name="startProcessDefId" id="startProcessDefId">
                                <option></option>
                                <c:forEach items="${processList}" var="process">
                                    <option value="${process.encodedId}" ${selected}>${process.name} (ver ${process.version})</option>
                                </c:forEach>
                            </select>
                        </span>
                    </div>

                    <div class="form-row">
                        <label for="name"><fmt:message key="wflowClient.userview.new.label.labelForProcess"/></label>
                        <span class="form-input"><input type="text" name="startProcessLabel" id="startProcessLabel"></span>
                    </div>

                    <div class="form-row">
                        <label for="runProcessDirectly"><fmt:message key="wflowClient.userview.new.label.runProcessDirectly"/></label>
                        <span class="form-input"><input type="checkbox" name="runProcessDirectly" id="runProcessDirectly" value="1"></span>
                    </div>
                </div>
            </div>

            <div id="userviewDetail">
                <div id="main-body-content-subheader" class="collapsible">
                    <span class="collapsibleIcon">[+]</span> <fmt:message key="wflowClient.userview.new.label.userviewDetails"/>
                </div>
                <div>
                    <div id="addCategory">
                        <div class="form-row">
                            <label><fmt:message key="wflowClient.userview.new.label.addCategory"/></label>
                            <span class="form-input">
                                <input type="text" name="addCategoryField" id="addCategoryField" />
                                <input type="button" onclick="addCategory()" value="<fmt:message key="wflowClient.userview.new.label.add"/>"/>
                            </span>
                        </div>
                    </div>

                    <div id="categoryList">
                        <div id="modalCategory" style="display: none" class="categoryBlock">
                            <div class="categoryBlockHeader">
                                <div class="collapsible">
                                    <span class="collapsibleIcon">[+]</span>
                                </div>
                                <div class="categoryName">
                                    <fmt:message key="wflowClient.userview.new.label.categoryList"/>
                                </div>
                                <div style="clear: both"></div>
                            </div>
                            <div class="categoryBlockContent">
                                <input type="hidden" name="categoryId"/>
                                <input type="hidden" name="categoryLabel"/>
                                <input type="hidden" name="categoryPermission"/>
                                <div class="categoryPermission">
                                    <b style="float:left;"><fmt:message key="wflowClient.userview.new.label.categoryPermission"/></b>
                                    <span class="categoryPermissionValue"><fmt:message key="wflowClient.userview.new.label.categoryPermissionAll"/></span>
                                    <div style="clear: both"></div>
                                </div>
                                <div class="activityList"></div>
                                <div>
                                    <span class="button">
                                        <button type="button" name="addActivity"><fmt:message key="wflowClient.userview.new.label.addActivity"/></button>
                                        <button type="button" onclick="removeCategory(this)"><fmt:message key="wflowClient.userview.new.label.removeCategory"/></button>
                                        <button type="button" onclick="setCategoryPermission(this)"><fmt:message key="wflowClient.userview.new.label.setCategoryPermission"/></button>
                                    </span>
                                    <div style="clear: both"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="modal" class="main-body-subrow">
                        <div class="activityBlock">
                            <input type="hidden" name="process">
                            <input type="hidden" name="processLabel">
                            <input type="hidden" name="permission"/>

                            <dl>
                                <dt><fmt:message key="wflowClient.userview.new.label.activityNameAndLabel"/></dt>
                                <dd><span class="activity"></span><input type="hidden" name="activity">, <span class="activityLabel"></span>
                                    <input type="hidden" name="activityLabel">
                                    <input type="hidden" name="category">
                                    <input type="hidden" name="tableHeader">
                                    <input type="hidden" name="tableFooter">&nbsp;
                                </dd>
                            </dl>

                                <div class="activityDetail">
                                    <dl>
                                    <dt><fmt:message key="wflowClient.userview.new.label.process"/></dt>
                                    <dd>
                                        <span class="process"></span>&nbsp;
                                    </dd>
                                    <dt><fmt:message key="wflowClient.userview.new.label.activityId"/></dt>
                                    <dd>
                                        <span class="activityId"></span>&nbsp;
                                    </dd>
                                    <dt><fmt:message key="wflowClient.userview.new.label.activityForm"/></dt>
                                    <dd>
                                        <span class="activityForm"></span>
                                        <input type="hidden" name="activityFormType">
                                        <input type="hidden" name="activityForm">&nbsp;
                                    </dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.column"/> </dt>
                                    <dd><span class="columns"></span><input type="hidden" name="columns"><input type="hidden" name="tableName">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.filter"/></dt>
                                    <dd><span class="filter"></span><input type="hidden" name="filter">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.sort"/></dt>
                                    <dd><span class="sort"></span><input type="hidden" name="sort">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.viewType"/></dt>
                                    <dd><span class="viewType"></span><input type="hidden" name="viewType">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.permissionType"/></dt>
                                    <dd><span class="permType"></span><input type="hidden" name="permType">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.buttonCompleteLabel"/></dt>
                                    <dd><span class="buttonCompleteLabel"></span><input type="hidden" name="buttonCompleteLabel">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.buttonSaveLabel"/></dt>
                                    <dd><span class="buttonSaveLabel"></span><input type="hidden" name="buttonSaveLabel"><input type="hidden" name="buttonSaveShow">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.buttonWithdrawLabel"/></dt>
                                    <dd><span class="buttonWithdrawLabel"></span><input type="hidden" name="buttonWithdrawLabel"><input type="hidden" name="buttonWithdrawShow">&nbsp;</dd>

                                    <dt><fmt:message key="wflowClient.userview.new.label.buttonCancelLabel"/></dt>
                                    <dd><span class="buttonCancelLabel"></span><input type="hidden" name="buttonCancelLabel">&nbsp;</dd>

                                    </dl>
                                </div>

                                <div class="form-buttons showHide">
                                    <a class="showMoreInfo" onclick="showMoreInfo(this)"><fmt:message key="wflowClient.userview.new.label.showAdditionalInfo"/></a>
                                    <a style="display: none" class="hideMoreInfo" onclick="hideMoreInfo(this)"><fmt:message key="wflowClient.userview.new.label.hideAdditionalInfo"/></a>
                                </div>
                            </dl>
                        </div>
                        <span class="row-button">
                            <button type="button" onclick="editActivity(this)" style="border: none; background: #FAFAFA"><img src="${pageContext.request.contextPath}/images/joget/data_view_activity_edit.png"></img></button>
                            <button type="button" onclick="removeActivity(this)" style="border: none; background: #FAFAFA"><img src="${pageContext.request.contextPath}/images/joget/data_view_activity_delete.png"></img></button>
                        </span>
                        <div style="clear: both"></div>
                    </div>
                </div>
            </div>

            <div id="layout">
                <div id="main-body-content-subheader" class="collapsible">
                    <span class="collapsibleIcon">[+]</span> <fmt:message key="wflowClient.userview.new.label.customLayout"/>
                </div>
                <div>
                    <div class="form-row">
                        <label><fmt:message key="wflowClient.userview.new.label.header"/></label>
                        <span class="form-input">
                            <textarea id="userviewHeader" name="userviewHeader" cols="70" rows="8"></textarea>
                        </span>
                    </div>

                    <div class="form-row">
                        <label><fmt:message key="wflowClient.userview.new.label.footer"/></label>
                        <span class="form-input">
                            <textarea id="userviewFooter" name="userviewFooter" cols="70" rows="8"></textarea>
                        </span>
                    </div>

                    <div class="form-row">
                        <label><fmt:message key="wflowClient.userview.new.label.menu"/></label>
                        <span class="form-input">
                            <textarea id="userviewMenu" name="userviewMenu" cols="70" rows="8"></textarea>
                        </span>
                    </div>

                    <div class="form-row">
                        <label><fmt:message key="wflowClient.userview.new.label.css"/></label>
                        <span class="form-input">
                            <textarea id="userviewCss" name="userviewCss" cols="70" rows="8"></textarea>
                        </span>
                    </div>

                    <div class="form-row">
                        <label><fmt:message key="wflowClient.userview.new.label.cssLink"/></label>
                        <span class="form-input">
                            <input type="text" id="userviewCssLink" name="userviewCssLink" size="60"/>
                        </span>
                    </div>
                </div>
            </div>

            <div class="form-buttons">
                <span class="button">
                    <c:choose>
                        <c:when test="${empty userviewSetupId}">
                            <input type="button" onclick="submitUserview()" value="<fmt:message key="general.method.label.submit"/>"/>
                        </c:when>
                        <c:when test="${!empty userviewSetupId}">
                            <input type="button" onclick="submitUserview()" value="<fmt:message key="general.method.label.save"/>"/>
                        </c:when>
                    </c:choose>
                    <c:if test="${!empty userviewSetupId}">
                        <input type="button" onclick="updateProcessVersion()" value="<fmt:message key="wflowClient.userview.new.label.updateProcessVersion"/>"/>
                        <input type="button" onclick="updateFormVersion()" value="<fmt:message key="wflowClient.userview.new.label.updateActivityFormVersion"/>"/>
                        <input type="button" onclick="exportUserview()" value="<fmt:message key="wflowClient.userview.edit.label.export"/>"/>
                        <input type="button" onclick="deleteUserview()" value="<fmt:message key="general.method.label.delete"/>"/>
                    </c:if>
                </span>
            </div>
        </form>
    </div>

<script type="text/javascript">
    <ui:popupdialog var="popupDialog" src=""/>

    function addCategory(category){
        var label = $('#addCategoryField').val().replace(/^\s+|\s+$/g,"");
        var id = new Date().valueOf().toString();

        if(category != null){
            label = category.categoryLabel.replace("&#58;",":").replace("&#44;",",");
            id = category.categoryId;
        }

        if(label == ''){
            return;
        }

        var div = $('#modalCategory').clone();
        $(div).attr('id', 'category-' + id);

        $(div).find('input[name="categoryId"]').val(id);
        $(div).find('input[name="categoryLabel"]').val(label);

        $(div).find('.categoryName').text(label);
        $(div).find('button[name="addActivity"]').click(function(){
            addActivity('category-' + id, id, label);
        });

        $(div).find('.categoryName').editable(function(value, settings){
            $(div).find('input[name="categoryLabel"]').val(value);
            return value;
        },{
            type      : 'text',
            tooltip   : '<fmt:message key="wflowClient.userview.new.label.editCategoryTips"/>' ,
            select    : true ,
            style     : 'inherit',
            cssclass  : 'categoryNameEditable',
            onblur    : 'submit',
            rows      : 3,
            width     : '99%',
            minwidth  : 150
        });

        $(div).hide();
        $('#categoryList').append(div);
        $(div).fadeIn('slow');

        $('#addCategoryField').val('');

        $(div).find('.activityList').sortable({
            connectWith: '.activityList',
            opacity: 0.8,
            axis: 'y',
            handle: '.activityBlock',
            dropOnEmpty: true,
            receive: function(event, ui){
                var newCategoryId = $(ui.item[0]).parents('.categoryBlock').find('input[name="categoryId"]').val();
                $(ui.item[0]).find('input[name="category"]').val(newCategoryId);
            }
        });

        $(div).find('.collapsible').toggle(function(){
            $(this).find(".collapsibleIcon").text('[-]');
            $(this).parents('.categoryBlock').find('.categoryBlockContent').show();
        },function(){
            $(this).find(".collapsibleIcon").text('[+]');
            $(this).parents('.categoryBlock').find('.categoryBlockContent').hide();
        });
    }

    function removeCategory(button){
        if(confirm('<fmt:message key="wflowClient.userview.msg.deleteCategory.comfirm"/>')){
            $(button).parents('.categoryBlock').fadeOut('slow', function(){
                $(this).remove();
            });
        }
    }

    function addActivity(divId, categoryId, categoryName){
        popupDialog.src = '${pageContext.request.contextPath}/web/admin/userview/create/selectActivity?divId=' + divId + '&category=' + categoryId;
        popupDialog.init();
    }

    function editActivity(button){
        var parentDiv = $(button).parent().parent();
        var categoryDiv = $(parentDiv).parent().parent();

        var param = '';
        param += "&activityDivId=" + escape($(parentDiv).attr('id'));
        param += "&category=" + escape($(categoryDiv).find('input[name="categoryId"]').val());
        param += "&divId=" + escape($(categoryDiv).attr('id'));

        popupDialog.src = '${pageContext.request.contextPath}/web/admin/userview/create/selectActivity?mode=edit' + param;
        popupDialog.init();
    }

    function removeActivity(button){
        if(confirm('<fmt:message key="wflowClient.userview.msg.deleteActivity.comfirm"/>')){
            $(button).parent().parent().fadeOut('slow', function(){
                $(this).remove();
            });
        }
    }
    
    function showMoreInfo(link){
        $(link).parent().parent().find('.activityDetail').slideToggle('slow');
        $(link).next('.hideMoreInfo').show();
        $(link).hide();
    }

    function hideMoreInfo(link){
        $(link).parent().parent().find('.activityDetail').slideToggle('slow');
        $(link).prev('.showMoreInfo').show();
        $(link).hide();
    }
    
    <c:if test="${!empty userviewSetupId}">
        $(document).ready(function(){
            var editCallback = {
                success : function(response){
                    var userview = eval('(' + response + ')');

                    $('#userviewForm').find('input[name="name"]').val(userview.userview.name);
                    $('#userviewForm').find('input[name="specifiedId"]').val(userview.userview.specifiedId);
                    $('#userviewForm').find('input[name="inboxLabel"]').val(userview.userview.inboxLabel);
                    $('#userviewForm').find('select[name="startProcessDefId"]').val(userview.processStart.processDefId);
                    $('#userviewForm').find('input[name="startProcessLabel"]').val(userview.processStart.label);
                    $('#userviewForm').find('textarea[name="userviewHeader"]').val(userview.layout.customHeader);
                    $('#userviewForm').find('textarea[name="userviewFooter"]').val(userview.layout.customFooter);
                    $('#userviewForm').find('textarea[name="userviewMenu"]').val(userview.layout.customMenu);
                    $('#userviewForm').find('textarea[name="userviewCss"]').val(userview.layout.customCss);
                    $('#userviewForm').find('input[name="userviewCssLink"]').val(userview.layout.customCssLink);

                    if(userview.processStart.runProcessDirectly == 1){
                        $('#userviewForm').find('input[name="runProcessDirectly"]').attr("checked","true");
                    }

                    if(userview.category != undefined){
                        if(userview.category.constructor == Array){
                            for(var i in userview.category){
                                var category = userview.category[i];
                                addCategory(category);
                            }
                        }else{
                            addCategory(userview.category);
                        }
                    }

                    if(userview.processList != undefined){
                        if(userview.processList.constructor == Array){
                            for(var i in userview.processList){
                                var process = userview.processList[i];
                                loadActivity(process);
                            }
                        }else{
                            loadActivity(userview.processList);
                        }
                    }
                }
            }

            ConnectionManager.get('${pageContext.request.contextPath}/web/json/userview/edit/view/${userviewSetupId}', editCallback);
        })
    </c:if>

    function loadActivity(process){
        var div = $('#modal').clone();

        $(div).find('input[name="process"]').val(process.processDefId);
        $(div).find('.process').html("<a target=\"_blank\" href=\"${pageContext.request.contextPath}/web/admin/process/configure/view/"+escape(process.processDefId)+"\">"+process.processName+"</a>");
        $(div).find('.activity').text(process.activity.activityName);
        $(div).find('.activityId').text(process.activity.activityDefId);
        $(div).find('input[name="activity"]').val(process.activity.activityDefId);
        $(div).find('.activityLabel').text(process.activity.activityLabel);
        $(div).find('input[name="activityLabel"]').val(process.activity.activityLabel);
        $(div).find('input[name="tableName"]').val(process.activity.tableName);
        $(div).find('.columns').text(process.activity.tableColumn.replace("&#58;",":").replace("&#44;",","));
        $(div).find('input[name="columns"]').val(process.activity.tableColumn);
        $(div).find('.filter').text(process.activity.filter);
        $(div).find('input[name="filter"]').val(process.activity.filter);
        $(div).find('.sort').text(process.activity.sort);
        $(div).find('input[name="sort"]').val(process.activity.sort);
        $(div).find('input[name="category"]').val(process.activity.category);
        $(div).find('.category').text($('input[type="hidden"][name="categoryId"][value="' + process.activity.category + '"]').next('input[type="hidden"]').val());
        $(div).find('input[name="tableHeader"]').val(process.activity.tableHeader);
        $(div).find('input[name="tableFooter"]').val(process.activity.tableFooter);

        if(process.activity.viewType == 0){
            $(div).find('.viewType').text('<fmt:message key="wflowClient.userview.new.label.runningAndCompleted"/>');
        }else if(process.activity.viewType == 1){
            $(div).find('.viewType').text('<fmt:message key="wflowClient.userview.new.label.running"/>');
        }
        $(div).find('input[name="viewType"]').val(process.activity.viewType);

        if(process.activity.permType == 0){
            $(div).find('.permType').text('<fmt:message key="wflowClient.userview.new.label.personal"/>');
        }else if(process.activity.permType == 1){
            $(div).find('.permType').text('<fmt:message key="wflowClient.userview.new.label.assigned"/>');
        }else if(process.activity.permType == 2){
            $(div).find('.permType').text('<fmt:message key="wflowClient.userview.new.label.all"/>');
        }
        $(div).find('input[name="permType"]').val(process.activity.permType);

        var buttonSaveLabel = process.activity.buttonSaveLabel;
        var buttonWithdrawLabel = process.activity.buttonWithdrawLabel;
        var buttonCancelLabel = process.activity.buttonCancelLabel;
        var buttonCompleteLabel = process.activity.buttonCompleteLabel;

        $(div).find('input[name="buttonSaveLabel"]').val(buttonSaveLabel);
        if(process.activity.buttonSaveShow == 0){
            $(div).find('.buttonSaveLabel').text(buttonSaveLabel + ' <fmt:message key="wflowClient.userview.new.label.button.hidden"/>');
            $(div).find('input[name="buttonSaveShow"]').val(0);
        }else{
            $(div).find('.buttonSaveLabel').text(buttonSaveLabel);
            $(div).find('input[name="buttonSaveShow"]').val(1);
        }
        
        $(div).find('input[name="buttonWithdrawLabel"]').val(buttonWithdrawLabel);
        if(process.activity.buttonWithdrawShow == 0){
            $(div).find('.buttonWithdrawLabel').text(buttonWithdrawLabel + ' <fmt:message key="wflowClient.userview.new.label.button.hidden"/>');
            $(div).find('input[name="buttonWithdrawShow"]').val(0);
        }else{
            $(div).find('.buttonWithdrawLabel').text(buttonWithdrawLabel);
            $(div).find('input[name="buttonWithdrawShow"]').val(1);
        }

        $(div).find('.buttonCancelLabel').text(buttonCancelLabel);
        $(div).find('input[name="buttonCancelLabel"]').val(buttonCancelLabel);

        $(div).find('.buttonCompleteLabel').text(buttonCompleteLabel);
        $(div).find('input[name="buttonCompleteLabel"]').val(buttonCompleteLabel);

        if(process.activity.activityFormUrl != null){
            $(div).find('.activityForm').text(process.activity.activityFormUrl);
            $(div).find('input[name="activityFormType"]').val('external');
            $(div).find('input[name="activityForm"]').val(process.activity.activityFormUrl);

        }else if(process.activity.activityFormId != null){
            var link = '<a target="_blank" href="${pageContext.request.contextPath}/web/admin/form/general/view/' + process.activity.activityFormId + '">' + process.activity.activityFormName + '</a>';
            $(div).find('.activityForm').html(link);
            $(div).find('input[name="activityFormType"]').val('normal');
            $(div).find('input[name="activityForm"]').val(process.activity.activityFormId);
        }else{
            $(div).find('.activityForm').text('-');
        }

        $('#category-' + process.activity.category + ' .activityList').append(div);
        
        if(process.activity.permission != ''){
            $('#category-' + process.activity.category + ' input[name="categoryPermission"]').val(process.activity.permission);

            if(process.activity.permission != null && process.activity.permissionGroupName != null){
                var text = "";
                var groupIds = process.activity.permission.toString().split(",");
                var groupNames = process.activity.permissionGroupName.toString().split(",");
                for(var i=0; i< groupIds.length; i++) {
                    var name = "";
                    text += "<span class=\"category-permission-item\"><a onClick=\"categoryItemRemoveSingle(this,'category-" + process.activity.category + "','" + escape(groupIds[i]) + "');\"> <img src=\"${pageContext.request.contextPath}/images/joget/cross-circle.png\"/></a><a class=\"category-permission-item-text\" target=\"_blank\" href=\"${pageContext.request.contextPath}/web/directory/admin/group/view/"+escape(groupIds[i])+"\">"+groupNames[i]+"</a></span> ";
                }
                text = text.substring(0, text.length - 2);

                $('#category-' + process.activity.category + ' .categoryPermissionValue').html(text);
                $(div).find('input[name="permission"]').val(process.activity.permission);
            }            
        }
        
        var id = new Date().valueOf().toString();
        $(div).attr('id', id);
    }

    function preview(){
        window.open('${pageContext.request.contextPath}/web/client/userview/${userviewSetupId}');
    }

    function exportUserview(){
        submitExportUserview = true;
        document.location = '${pageContext.request.contextPath}/web/admin/userview/export/${userviewSetupId}';
    }

    $(document).ready(function(){
        if ($.browser.mozilla) {
            $("input:text").keypress(checkForEnter);
        } else {
            $("input:text").keydown(checkForEnter);
        }

        $("input:text[name='id']").change(function(){
            if($(this).val().toString().indexOf(" ") != -1){
                alert("<fmt:message key="wflowClient.userview.msg.idCannotContainsEmptySpace"/>");
            }
        });

        $('#categoryList').sortable({
            opacity: 0.8,
            axis: 'y',
            handle: '.categoryName',
            tolerance: 'intersect'
        });

        initCollapsible();

       <c:if test="${save == 'true'}">
            alert("<fmt:message key="wflowClient.userview.msg.successfullySaved"/>");
        </c:if>
            
    });

    function initCollapsible(){
        //$('.collapsible').next('div').hide();

        $('.collapsible').toggle(function(){
            $(this).find(".collapsibleIcon").text('[-]');
            $(this).next('div').show();
        },function(){
            $(this).find(".collapsibleIcon").text('[+]');
            $(this).next('div').hide();
        });
    }

    function checkForEnter(event) {
        if (event.keyCode == 13) {
            event.preventDefault();
            return false;
        }
    }

    function setCategoryPermission(button){
        var categoryId = $(button).parents('.categoryBlock').find('input[name="categoryId"]').val();

        popupDialog.src = '${pageContext.request.contextPath}/web/admin/userview/create/permission?categoryId=' + categoryId;
        popupDialog.init();
    }
    
    function submitUserview(){
        var idMatch = true;
        var errors = "";

        if($("#id") != undefined){
            if($("#id").attr("value") == ''){
                alert("<fmt:message key="userview.error.idNotEmpty"/>");
            }else{
                idMatch = /^[0-9a-zA-Z_-]+$/.test($("#id").attr("value"));
                if(!idMatch){
                    alert("<fmt:message key="userview.error.invalidId"/>");
                }else{
                    submitCallback = {
                        success: function(json){
                            var data = eval('('+json+')');
                            var exist = data.exist;
                            
                            if(exist=='true') {
                                errors += "<fmt:message key="userview.error.idAlreadyExist"/>";
                            }

                            if($("#name").attr("value") == ''){
                                if(errors != ""){
                                     errors += "\n";
                                }
                                errors += "<fmt:message key="userview.error.nameNotEmpty"/>";
                            }

                            if(errors != ""){
                                alert(errors);
                            }else{
                                submit = true;
                                $('#userviewForm').submit();
                            }
                        }
                    }
                    ConnectionManager.post('${pageContext.request.contextPath}/web/json/userview/checkExist/'+$("#id").attr("value"), submitCallback);
                }
            }
        }else{
            if($("#name").attr("value") == ''){
                alert("<fmt:message key="userview.error.nameNotEmpty"/>");
            }else{
                submit = true;
                $('#userviewForm').submit();
            }
        }
    }

    function updateProcessVersion(){
        var param = '';
        $.each($('input[name="process"]'), function(i, v){
            if($(v).val() != '' && param.indexOf(escape($(v).val())) == -1){
                param += escape($(v).val()) + ',';
            }
        });
        
        if($('#startProcessDefId').val() != ''){
            param += $('#startProcessDefId').val();
        }else{
            param = param.substring(0, param.length-1);
        }
        
        if(param != ''){
            popupDialog.src = '${pageContext.request.contextPath}/web/admin/userview/create/updateProcessVersion?processes=' + param;
            popupDialog.init();
        }
        
    }

    function updateFormVersion(){
        var param = '';
        $.each($('input[name="activityForm"]'), function(i, v){
            if($(v).val() != '' && $(v).prev('input[name="activityFormType"]').val() == 'normal'){
                if(param.indexOf(escape($(v).val())) == -1){
                    param += escape($(v).val()) + ',';
                }
            }
        });
        param = param.substring(0, param.length-1);

        if(param != ''){
            popupDialog.src = '${pageContext.request.contextPath}/web/admin/userview/create/updateFormVersion?formids=' + param;
            popupDialog.init();
        }

    }
    
    function categoryItemRemoveSingle(obj, categoryId, groupId){
            if (confirm("<fmt:message key="wflowClient.userview.new.label.categoryPermissionRemove"/>")) {
                //hide it
                $(obj).parent().remove();
                
                var regex = new RegExp(groupId + ",*","g");
                var regex2 = new RegExp("^,|,$","g");

                var categoryPermission = $('#' + categoryId).find('input[name="categoryPermission"]').val().replace(regex,"").replace(regex2,"");
                var permission = $('#' + categoryId).find('input[name="permission"]').val().replace(regex,"").replace(regex2,"");

                if(categoryPermission.length == 0){
                    $('#' + categoryId).find('.categoryPermission').html( $('#modalCategory').find('.categoryPermission').html() );
                }
                $('#' + categoryId).find('input[name="categoryPermission"]').val(categoryPermission);
                $('#' + categoryId).find('input[name="permission"]').val(permission);
            }
    }

    function deleteUserview(){
        if (confirm("<fmt:message key="formsAdmin.form.view.label.deleteConfirm"/>")) {
            var callback = {
                success : function() {
                    submit = true;
                    document.location = '${pageContext.request.contextPath}/web/admin/userview/list';
                }
            }
            ConnectionManager.post('${pageContext.request.contextPath}/web/admin/userview/removeMultiple', callback, 'userviewIds=${userviewSetupId}');
        }
    }
</script>

<commons:footer />
