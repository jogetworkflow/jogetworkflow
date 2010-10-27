<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<commons:popupHeader />

<style>
    #main-body-content-subheader{
        margin-top: 0px;
    }
</style>

    <div id="main-body-header">
        <div id="main-body-header-title">
            <fmt:message key="wflowClient.userview.new.label.userviewSetup"/>
        </div>
    </div>

    <div id="main-body-content" style="text-align: left">
        <div class="steps">
            <div id="main-body-content-subheader">
                <fmt:message key="wflowClient.userview.new.label.Step1"/>
            </div>

            <div class="form-row">
                <label><fmt:message key="wflowClient.userview.new.label.selectProcess"/></label>
                <span class="form-input">
                    <input type="text" id="process" name="processDefId" size="40" disabled/>
                    <input type="hidden" id="processName" name="processName"/>
                    <input type="button" id="showProcessJsonTable" value="<fmt:message key="wflowClient.userview.new.label.selectProcess"/>" />
                </span>
                <div id="processJsonTable" style="display:none; margin-top:15px">
                    <fieldset>
                        <legend><fmt:message key="wflowClient.userview.new.label.selectProcess"/></legend>
                        <div id="main-body-content-filter">
                            <form style="display:block">
                            <fmt:message key="wflowClient.filter.by.package"/>
                            <select id="packageFilter" onchange="filter(processTable, '&allVersion=' + $('#versionFilter').val() + '&packageId=', this.options[this.selectedIndex].value)">
                                <option></option>
                                <c:forEach items="${packageList}" var="workflowPackage">
                                    <c:set var="selected"><c:if test="${workflowPackage.packageId == param.packageId}"> selected</c:if></c:set>
                                    <option value="${workflowPackage.packageId}" ${selected}>${workflowPackage.packageName}</option>
                                </c:forEach>
                            </select>
                            </form>
                            <form style="display:block">
                            <fmt:message key="wflowClient.filter.by.version"/>
                            <select id="versionFilter" onchange="filter(processTable, '&packageId=' + $('#packageFilter').val() + '&allVersion=', this.options[this.selectedIndex].value)">
                                <option selected value="no">No</option>
                                <option value="yes">Yes</option>
                            </select>
                            </form>
                        </div>

                        <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/process/list?${pageContext.request.queryString}"
                                       var="processTable"
                                       divToUpdate="processList"
                                       jsonData="data"
                                       rowsPerPage="10"
                                       width="680px"
                                       sort="name"
                                       desc="false"
                                       checkbox="true"
                                       checkboxId="id"
                                       checkboxButton1="general.method.label.select"
                                       checkboxCallback1="updateProcessDefId"
                                       checkboxButton2="general.method.label.cancel"
                                       checkboxCallback2="hideProcessDiv"
                                       checkboxSelectSingle="true"
                                       fields="['id','packageId', 'packageName', 'name','version']"
                                       column1="{key: 'packageName', label: 'wflowClient.startProcess.list.label.packageName', sortable: true}"
                                       column2="{key: 'name', label: 'wflowClient.startProcess.list.label.name', sortable: true}"
                                       column3="{key: 'version', label: 'wflowClient.startProcess.list.label.version', sortable: false}"
                                       />
                    </fieldset>
                </div>

                <label><fmt:message key="wflowClient.userview.new.label.selectActivity"/></label>
                <div id="activityList">
                    <span class="form-input">
                        <select name="activityDefId" id="activity" onchange="selectActivity()">
                            <option></option>
                            
                        </select>
                    </span>
                </div>
            </div>

            <div class="form-row">
                 <label for="activityLabel"><fmt:message key="wflowClient.userview.new.label.labelForActivity"/></label>
                 <span class="form-input"><input type="text" name="activityLabel" id="activityLabel"></span>
            </div>

            <div class="form-row">
                 <label for="buttonSaveLabel"><fmt:message key="wflowClient.userview.new.label.saveButton"/></label>
                 <span class="form-input"><input type="text" name="buttonSaveLabel" id="buttonSaveLabel"><input type="checkbox" name="buttonSaveShow" id="buttonSaveShow"/><fmt:message key="wflowClient.userview.new.label.button.show"/></span>
            </div>

            <div class="form-row">
                 <label for="buttonCancelLabel"><fmt:message key="wflowClient.userview.new.label.cancelButton"/></label>
                 <span class="form-input"><input type="text" name="buttonCancelLabel" id="buttonCancelLabel"></span>
            </div>

            <div class="form-row">
                 <label for="buttonWithdrawLabel"><fmt:message key="wflowClient.userview.new.label.withdrawButton"/></label>
                 <span class="form-input"><input type="text" name="buttonWithdrawLabel" id="buttonWithdrawLabel"><input type="checkbox" name="buttonWithdrawShow" id="buttonWithdrawShow"/><fmt:message key="wflowClient.userview.new.label.button.show"/></span>
            </div>

            <div class="form-row">
                 <label for="buttonCompleteLabel"><fmt:message key="wflowClient.userview.new.label.completeButton"/></label>
                 <span class="form-input"><input type="text" name="buttonCompleteLabel" id="buttonCompleteLabel"></span>
            </div>

            <div class="step-buttons">
                <button type="button" class="step-next"><fmt:message key="wflowClient.userview.new.label.next"/></button>
            </div>
        </div>

        <div class="steps">
            <div id="main-body-content-subheader">
                <fmt:message key="wflowClient.userview.new.label.Step2"/>
            </div>

            <div id="activityDetailPlaceHolder">
                <div id="activityDetailColumnList">
                    <div id="availableColumnsContainer">
                        <fmt:message key="wflowClient.userview.new.label.availableColumns"/>
                        <select multiple id="availableColumns"></select>
                        <a href="#" id="add"><fmt:message key="wflowClient.userview.new.label.addColumns"/></a>
                    </div>

                    <div id="selectedColumnsContainer">
                        Selected Columns
                        <select name="selectedColumns" multiple id="selectedColumns"></select>
                        <a href="#" id="remove"><fmt:message key="wflowClient.userview.new.label.removeColumns"/></a>
                    </div>
                    <div id="columnSequenceControl">
                        <a href="#" id="moveUp"><img src="${pageContext.request.contextPath}/images/joget/arrow_up.png"></img></a>
                        <a href="#" id="moveDown"><img src="${pageContext.request.contextPath}/images/joget/arrow_down.png"></img></a>
                    </div>
                </div>

                <div style="clear: both"></div>
            </div>

            <div id="selectedColumnLabels"></div>

            <br/>

            <div id="activityViewType">
                <label><fmt:message key="wflowClient.userview.new.label.viewType"/></label>
                <span class="form-input">
                    <span><input type="radio" name="viewTypeRadio" value="Running" checked="true"/><span>&nbsp;<fmt:message key="wflowClient.userview.new.label.running"/></span></span>
                    <span><input type="radio" name="viewTypeRadio" value="Running and Completed"/><span>&nbsp;<fmt:message key="wflowClient.userview.new.label.runningAndCompleted"/></span></span>
                </span>
            </div>

            <div id="activityPermType">
                <label><fmt:message key="wflowClient.userview.new.label.permissionType"/></label>
                <span class="form-input">
                    <span><input type="radio" name="permTypeRadio" value="Personal"/><span>&nbsp;<fmt:message key="wflowClient.userview.new.label.personal"/></span></span>
                    <span><input type="radio" name="permTypeRadio" value="Assigned" checked="true"/><span>&nbsp;<fmt:message key="wflowClient.userview.new.label.assigned"/></span></span>
                    <span><input type="radio" name="permTypeRadio" value="All" checked="true"/><span>&nbsp;<fmt:message key="wflowClient.userview.new.label.all"/></span></span>
                </span>
            </div>

            <div class="step-buttons">
                <button type="button" class="step-prev"><fmt:message key="wflowClient.userview.new.label.prev"/></button>
                <button type="button" class="step-next"><fmt:message key="wflowClient.userview.new.label.next"/></button>
            </div>
        </div>

        <div class="steps">
            <div id="main-body-content-subheader">
                <fmt:message key="wflowClient.userview.new.label.Step3"/>
            </div>

            <div id="formTabView">
                <ul>
                    <li class="selected"><a href="#formList"><span><fmt:message key="wflowClient.userview.new.label.formList"/></span></a></li>
                    <li><a href="#externalForm"><span><fmt:message key="wflowClient.userview.new.label.externalForm"/></span></a></li>
                </ul>
                <div>
                    <div id="formList">
                        <br/>
                        <div class="form-row">
                            <label for="externalFormUrl"><fmt:message key="wflowClient.userview.new.label.formId"/></label>
                            <span class="form-input">
                                <input type="text" id="formId" name="formId" size="40" disabled/>
                                <input type="hidden" id="formName" name="formName"/>
                                <input type="button" id="showFormJsonTable" value="<fmt:message key="wflowClient.userview.new.label.selectForm"/>" />
                                <input type="button" id="clearForm" value="<fmt:message key="wflowClient.userview.new.label.clearForm"/>" />
                            </span>
                        </div>
                        <div id="formJsonTable" style="display:none; margin-top:15px">
                            <fieldset>
                                <legend><fmt:message key="wflowClient.userview.new.label.selectForm"/></legend>
                                <div id="main-body-content-filter">
                                    <form>
                                    <fmt:message key="formsAdmin.form.list.label.categoryFilter"/>
                                    <select onchange="filter(activityFormList, '&categoryId=', this.options[this.selectedIndex].value)">
                                        <option></option>
                                    <c:forEach items="${categoryList}" var="category">
                                        <c:set var="selected"><c:if test="${category.id == param.categoryId}"> selected</c:if></c:set>
                                        <option value="${category.id}" ${selected}>${category.name}</option>
                                    </c:forEach>
                                    </select>
                                    </form>
                                </div>
                                <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/list?${pageContext.request.queryString}"
                                               var="activityFormList"
                                               divToUpdate="activityFormList"
                                               jsonData="data"
                                               rowsPerPage="10"
                                               width="680px"
                                               sort="name"
                                               desc="false"
                                               checkbox="true"
                                               checkboxId="id"
                                               checkboxButton1="general.method.label.select"
                                               checkboxCallback1="updateFormId"
                                               checkboxButton2="general.method.label.cancel"
                                               checkboxCallback2="hideFormDiv"
                                               checkboxSelectSingle="true"
                                               fields="['id','name','version','created','modified','categoryName']"
                                               column1="{key: 'name', label: 'wflowAdmin.activityAddForm.view.label.formList.formName', sortable: true}"
                                               column2="{key: 'version', label: 'wflowAdmin.activityAddForm.view.label.formList.version', sortable: false}"
                                               column3="{key: 'categoryName', label: 'wflowAdmin.activityAddForm.view.label.formList.categoryName', sortable: false}"
                                               column4="{key: 'created', label: 'wflowAdmin.activityAddForm.view.label.formList.created', sortable: false}"
                                               column5="{key: 'modified', label: 'wflowAdmin.activityAddForm.view.label.formList.modified', sortable: false}"
                                               />
                            </fieldset>
                        </div>
                    </div>
                    <div id="externalForm">
                        <br/>
                        <div class="form-row">
                            <label for="externalFormUrl"><fmt:message key="wflowAdmin.activityAddForm.view.label.formExternalUrl"/></label>
                            <span class="form-input">
                                <input type="text" id="externalFormUrl" name="externalFormUrl" size="80"/>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="step-buttons">
                <button type="button" class="step-prev"><fmt:message key="wflowClient.userview.new.label.prev"/></button>
                <button type="button" class="step-next"><fmt:message key="wflowClient.userview.new.label.next"/></button>
            </div>
        </div>

        <div class="steps">
            <div id="main-body-content-subheader">
                <fmt:message key="wflowClient.userview.new.label.Step4"/>
            </div>

            <div class="optional">
                 <div class="form-row">
                     <label for="name"><fmt:message key="wflowClient.userview.new.label.tableHeader"/></label>
                     <span class="form-input"><textarea name="tableHeader" id="tableHeader" cols="110" rows="8"></textarea></span>
                </div>

                <div class="form-row">
                     <label for="name"><fmt:message key="wflowClient.userview.new.label.tableFooter"/></label>
                     <span class="form-input"><textarea name="tableFooter" id="tableFooter" cols="110" rows="8"></textarea></span>
                </div>

            </div>

            <div class="step-buttons">
                <button type="button" class="step-prev"><fmt:message key="wflowClient.userview.new.label.prev"/></button>

                <button type="button" class="step-submit" onclick="addToUserview()">
                    <c:choose>
                        <c:when test="${param.mode == 'edit'}">
                            <fmt:message key="wflowClient.userview.new.label.done"/>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="wflowClient.userview.new.label.addToUserview"/>
                        </c:otherwise>
                    </c:choose>
                </button>
            </div>
        </div>
    </div>

<script type="text/javascript">
    var tabView = new TabView('formTabView', 'top');
    tabView.init();

    var tableName = '';

    var ACTIVITY_FORM_TYPE_NORMAL = 'normal';
    var ACTIVITY_FORM_TYPE_EXTERNAL = 'external';

    function addColumnToSelected(){
        $("#availableColumns option:selected").each(function () {
              $('#selectedColumnLabels').append('<div class="form-row" id=\"' + $(this).text() + '\">'
                                                + '<label>' + $(this).text() + '</label>'
                                                + '<span class="form-input"><span><fmt:message key="wflowClient.userview.msg.label.columnLabel"/><input type=\"text\" class="columnLabel" name=\"' + $(this).text() + '_label\" id=\"' + $(this).text() + '_label\" />'
                                                + '&nbsp;&nbsp;</span><span><fmt:message key="wflowClient.userview.msg.label.columnFilterable"/><input type=\"checkbox\" name=\"' + $(this).text() + '_filter\" id=\"' + $(this).text() + '_filter\" />'
                                                + '&nbsp;&nbsp;</span><span><fmt:message key="wflowClient.userview.msg.label.columnSortable"/><input type=\"checkbox\" name=\"' + $(this).text() + '_sort\" id=\"' + $(this).text() + '_sort\" /></span></span></div>');
          });

        $('#availableColumns option:selected').remove().appendTo('#selectedColumns');

        return false;
    }

    $(document).ready(function(){
        <c:if test="${param.mode == 'edit'}">

            var div = $('#${param.activityDivId}', window.parent.document);

            var processDefId = $(div).find('input[name="process"]').val();
            $('#process').val(processDefId);
            $('#processName').val($(div).find('.process a').html());

            loadActivity(function(){

                tableName = $(div).find('input[name="tableName"]').val();
                $('#activity').val($(div).find('input[name="activity"]').val());
                $('#activityLabel').val($(div).find('input[name="activityLabel"]').val());

                selectActivity(function(){
                    var columnString = $(div).find('input[name="columns"]').val();
                    var pair = columnString.split(', ');
                    var columnList = new Array();
                    var columnLabelList = new Array();
                    for(var i in pair){
                        var temp = pair[i].split(':');
                        columnList.push(temp[0]);
                        columnLabelList.push(temp[1]);
                    }

                    for(var i in columnList){
                        $('#availableColumns option[value="' + columnList[i] + '"]').attr('selected', 'selected');
                        addColumnToSelected();
                    }
                    for(var i in columnList){
                        $('#selectedColumnLabels input[name="' + columnList[i] + '_label"]').val(columnLabelList[i]);
                    }

                    var filterString = $(div).find('input[name="filter"]').val();
                    filterString = filterString.replace(/, /g, ",");
                    var filterList = filterString.split(",");

                    for(var i in filterList){
                        $('#selectedColumnLabels input[name="' + filterList[i] + '_filter"]').attr("checked","checked");
                    }

                    var sortString = $(div).find('input[name="sort"]').val();
                    sortString = sortString.replace(/, /g, ",");
                    var sortList = sortString.split(",");

                    for(var i in sortList){
                        $('#selectedColumnLabels input[name="' + sortList[i] + '_sort"]').attr("checked","checked");
                    }
                })
            });

            //view type
            var viewType = $(div).find('input[name="viewType"]').val();
            if(viewType == 0){
                $("input[value='Running and Completed']").attr('checked', 'true');
            }else if(viewType == 1){
                $("input[value='Running']").attr('checked', 'true');
            }

            //perm type
            var permType = $(div).find('input[name="permType"]').val();
            if(permType == 0){
                $("input[value='Personal']").attr('checked', 'true');
            }else if(permType == 1){
                $("input[value='Assigned']").attr('checked', 'true');
            }else if(permType == 2){
                $("input[value='All']").attr('checked', 'true');
            }

            //buttons label
            $('#activity').val($(div).find('input[name="activity"]').val());
            $('#activityLabel').val($(div).find('input[name="activityLabel"]').val());

            $('#buttonSaveLabel').val($(div).find('input[name="buttonSaveLabel"]').val());
            $('#buttonCancelLabel').val($(div).find('input[name="buttonCancelLabel"]').val());
            $('#buttonWithdrawLabel').val($(div).find('input[name="buttonWithdrawLabel"]').val());
            $('#buttonCompleteLabel').val($(div).find('input[name="buttonCompleteLabel"]').val());

            var buttonWithdrawShow = $(div).find('input[name="buttonWithdrawShow"]').val();
            if(buttonWithdrawShow == 1){
                $("input[name='buttonWithdrawShow']").attr('checked', 'true');
            }
            
            var buttonSaveShow = $(div).find('input[name="buttonSaveShow"]').val();
            if(buttonSaveShow == 1){
                $("input[name='buttonSaveShow']").attr('checked', 'true');
            }

            //form
            var activityFormType = $(div).find('input[name="activityFormType"]').val();
            if(activityFormType == ACTIVITY_FORM_TYPE_NORMAL){
                $('#formId').val($(div).find('input[name="activityForm"]').val());
                $('#formName').val($(div).find('.activityForm a').html());
            }else if(activityFormType == ACTIVITY_FORM_TYPE_EXTERNAL){
                $('#externalFormUrl').val($(div).find('input[name="activityForm"]').val());
            }

            $('#tableHeader').val($(div).find('input[name="tableHeader"]').val());
            $('#tableFooter').val($(div).find('input[name="tableFooter"]').val());

        </c:if>

        $('.steps:first').addClass('current').show();

        $('.step-next').click(function(){
            var div = $('.steps.current');

            $(div).removeClass('current');
            $(div).hide();

            $(div).next('.steps').addClass('current').show();
        })

        $('.step-prev').click(function(){
            var div = $('.steps.current');

            $(div).removeClass('current');
            $(div).hide();

            $(div).prev('.steps').addClass('current').show();
        })

        $('#add').click(addColumnToSelected);

        $('#remove').click(function() {
            $("#selectedColumns option:selected").each(function () {
                  $('#'+ escapeId($(this).text())).remove();
              });

            $('#selectedColumns option:selected').remove().appendTo('#availableColumns');
            return false;
        });

        $('#moveUp').click(columnMoveUp);

        $('#moveDown').click(columnMoveDown);

        $('#showFormJsonTable').click(function(){
            $('#formJsonTable').show();
            $('#showFormJsonTable').attr("disabled", "true");
        });

        $('#showProcessJsonTable').click(function(){
            $('#processJsonTable').show();
            $('#showProcessJsonTable').attr("disabled", "true");
        });

        $('#clearForm').click(function(){
            $('#formId').val("");
        });
    })

    function hideFormDiv(id){
        $('#formJsonTable').slideToggle('hide');
        $('#showFormJsonTable').attr('disabled', false);
    }

    function updateFormId(id){
        $('#formId').val(id);
        $('#formName').val($("table#activityFormList tbody tr#row"+escapeId(id[0])+" td:eq(1) div").html());
        hideFormDiv(id);
    }

    function hideProcessDiv(id){
        $('#processJsonTable').slideToggle('hide');
        $('#showProcessJsonTable').attr('disabled', false);
    }

    function updateProcessDefId(id){
        $('#process').val(id);
        $('#processName').val($("table#processList tbody tr#row"+escapeId(id[0])+" td:eq(2) div").html());
        loadActivity();
        hideProcessDiv(id);
    }

    function escapeId(str){
        return str.replace(/([#;&,\.\+\*\~':"\!\^$\[\]\(\)=>\|])/g, "\\\\\\\\$1");
    }

    function addToActivityList(activity){
        var option = new Option(activity.name, activity.id);
        $('#activity').attr("options").add(option);
    }

    function columnMoveUp(){
        var selected = $('#selectedColumns option:selected');
        var prev = $('#selectedColumns option:selected:first').prev('option');
        if($(prev).text() != ""){
            $(selected).remove();
            $(prev).before($(selected));
        }
    }

    function columnMoveDown(){
        var selected = $('#selectedColumns option:selected');
        var next = $('#selectedColumns option:selected:last').next('option');
        if($(next).text() != ""){
            $(selected).remove();
            $(next).after($(selected));
        }
    }

    function loadActivity(callback){
        var getCallback = function(response){
            var selectedActivity = $('#activity').val();

            $('#activity').html('');
            addToActivityList({name:'', id:''});
            var response = eval('(' + response + ')');

            if(response.data.length == undefined){
                addToActivityList(response.data);
            }else{
                for(var i in response.data){
                    addToActivityList(response.data[i]);
                }
            }

            if(selectedActivity != ''){
                $('#activity').val(selectedActivity);
                selectActivity();
            }

            if(callback){
                callback();
            }
        }

        $.get('${pageContext.request.contextPath}/web/json/userview/getActivityListWithFormMapping/' + escape($('#process').val()), getCallback);
    }

    function selectActivity(callback){
        if($('#activity').val() == ''){
            $('#availableColumns').html('');
            $('#selectedColumns').html('');
            $('#selectedColumnLabels').html('');
        }else{
            var getCallback = function(response){
                var selectedColumns = $('#selectedColumns').val();
                var selectedColumnLabels = new Array();
                var selectedColumnFilter = new Array();
                var selectedColumnSort = new Array();
                for(var i in selectedColumns){
                    selectedColumnLabels.push($('#selectedColumnLabels input[name="' + selectedColumns[i] + '_label"]').val());
                    selectedColumnFilter.push($('#selectedColumnLabels input[name="' + selectedColumns[i] + '_filter"]').attr('checked'));
                    selectedColumnSort.push($('#selectedColumnLabels input[name="' + selectedColumns[i] + '_sort"]').attr('checked'));
                }

                $('#availableColumns').html('');
                $('#selectedColumns').html('');
                $('#selectedColumnLabels').html('');
                var response = eval('(' + response + ')');

                tableName = response.tableName;

                if(response.data.length == undefined){
                    addToColumnList(response.data);
                }else{
                    for(var i in response.data){
                        addToColumnList(response.data[i]);
                    }
                }
                
                if(selectedColumns != null && selectedColumns.length != 0){
                    for(var i in selectedColumns){
                        $('#availableColumns option[value="' + selectedColumns[i] + '"]').attr('selected', 'selected');
                        addColumnToSelected();
                    }
                    for(var i in selectedColumns){
                        $('#selectedColumnLabels input[name="' + selectedColumns[i] + '_label"]').val(selectedColumnLabels[i]);
                    }
                    for(var i in selectedColumns){
                        if(selectedColumnFilter[i] == true){
                            $('#selectedColumnLabels input[name="' + selectedColumns[i] + '_filter"]').attr('checked', 'checked');
                        }
                        if(selectedColumnSort[i] == true){
                            $('#selectedColumnLabels input[name="' + selectedColumns[i] + '_sort"]').attr('checked', 'checked');
                        }
                    }
                }                
               
                if(callback){
                    callback();
                }
            }

            $.get('${pageContext.request.contextPath}/web/json/userview/getColumnList/' + escape($('#process').val()) + '/' + $('#activity').val(), getCallback);
        }

    }

    function addToColumnList(column){
        if(/^c_/.test(column)){
            column = column.replace(/^c_/, '');
        }else{
            column = column + "(System)";
        }

        $('#availableColumns').append('<option>' + column + '</option>');
    }

    function addToUserview(){
        <c:choose>
            <c:when test="${param.mode == 'edit'}">
                var div = $('#${param.activityDivId}', window.parent.document);
            </c:when>
            <c:otherwise>
                var div = window.parent.$('#modal').clone();
                var id = new Date().valueOf().toString();
                $(div).attr('id', id);
            </c:otherwise>
        </c:choose>

        //check validation
        var valid = true;
        var errorMsg = "";
        //activity not empty
        if($('#activity').val() == ""){
            valid = false;
            errorMsg += "-<fmt:message key="wflowClient.userview.msg.pleaseSelectAnActivity"/>\n";
        }

        if(!valid){
            alert(errorMsg);

            var div = $('.steps.current');

            $(div).removeClass('current');
            $(div).hide();

            $('div.steps:eq(0)').addClass('current').show();

            return false;
        }

        var processLabel = $('#${param.divId}', window.parent.document).find("#processDefLabel").val();

        $(div).find('input[name="process"]').val($('#process').val());
        $(div).find('input[name="processLabel"]').val(processLabel);
        $(div).find('.process').html("<a target=\"_blank\" href=\"${pageContext.request.contextPath}/web/admin/process/configure/view/"+escape($('#process').val())+"\">"+$('#processName').val()+"</a>");
        $(div).find('.activity').text($('#activity option:selected').html());
        $(div).find('.activityId').text($('#activity').val());
        $(div).find('input[name="activity"]').val($('#activity').val());
        $(div).find('.activityLabel').text($('#activityLabel').val());
        $(div).find('input[name="activityLabel"]').val($('#activityLabel').val());
        $(div).find('input[name="tableName"]').val(tableName);
        $(div).find('input[name="category"]').val('${param.category}');
        $(div).find('input[name="tableHeader"]').val($('#tableHeader').val());
        $(div).find('input[name="tableFooter"]').val($('#tableFooter').val());

        var columns = '';
        var columnsText = '';
        var filter = '';
        var sort = '';
        $('#selectedColumns option').attr('selected','true');
        $.each($('#selectedColumns').val(), function(i, v){
            columns += v + ':' + $('input[name=' + v + '_label]').val().replace(":","&#58;").replace(",","&#44;") + ', ';

            if($('input[name=' + v + '_filter]:checked').val()){
                filter += v + ", ";
            }
            if($('input[name=' + v + '_sort]:checked').val()){
                sort += v + ", ";
            }
        })

        columns = columns.substring(0, columns.length - 2);
        filter = filter.substring(0, filter.length - 2);
        sort = sort.substring(0, sort.length - 2);
        $(div).find('.columns').text(columns.replace("&#58;",":").replace("&#44;",","));
        $(div).find('input[name="columns"]').val(columns);
        $(div).find('.filter').text(filter);
        $(div).find('input[name="filter"]').val(filter);
        $(div).find('.sort').text(sort);
        $(div).find('input[name="sort"]').val(sort);

        var viewType = '';
        var viewTypeCount = 0;

        viewType = $("input[name='viewTypeRadio']:checked").val();
        if($("input[name='viewTypeRadio']:checked").val() == 'Running and Completed'){
            viewTypeCount = 0;
        }else if($("input[name='viewTypeRadio']:checked").val() == 'Running'){
            viewTypeCount = 1;
        }

        $(div).find('.viewType').text(viewType);
        $(div).find('input[name="viewType"]').val(viewTypeCount);

        var permType = '';
        var permTypeCount = 0;

        permType = $("input[name='permTypeRadio']:checked").val();
        if($("input[name='permTypeRadio']:checked").val() == 'Personal'){
            permTypeCount = 0;
        }else if($("input[name='permTypeRadio']:checked").val() == 'Assigned'){
            permTypeCount = 1;
        }else if($("input[name='permTypeRadio']:checked").val() == 'All'){
            permTypeCount = 2;
        }

        $(div).find('.permType').text(permType);
        $(div).find('input[name="permType"]').val(permTypeCount);

        $(div).find('input[name="buttonWithdrawLabel"]').val($('#buttonWithdrawLabel').val());
        $(div).find('input[name="buttonSaveLabel"]').val($('#buttonSaveLabel').val());
        $(div).find('.buttonCancelLabel').text($('#buttonCancelLabel').val());
        $(div).find('input[name="buttonCancelLabel"]').val($('#buttonCancelLabel').val());
        $(div).find('.buttonCompleteLabel').text($('#buttonCompleteLabel').val());
        $(div).find('input[name="buttonCompleteLabel"]').val($('#buttonCompleteLabel').val());
        if($('#buttonSaveShow').attr("checked") == 1){
            $(div).find('.buttonSaveLabel').text($('#buttonSaveLabel').val());
            $(div).find('input[name="buttonSaveShow"]').val(1);
        }else{
            $(div).find('.buttonSaveLabel').text($('#buttonSaveLabel').val() + ' (Hidden)');
            $(div).find('input[name="buttonSaveShow"]').val(0);
        }
        if($('#buttonWithdrawShow').attr("checked") == 1){
            $(div).find('.buttonWithdrawLabel').text($('#buttonWithdrawLabel').val());
            $(div).find('input[name="buttonWithdrawShow"]').val(1);
        }else{
            $(div).find('.buttonWithdrawLabel').text($('#buttonWithdrawLabel').val() + ' (Hidden)');
            $(div).find('input[name="buttonWithdrawShow"]').val(0);
        }
        
        if($('#formId').val() != ''){
            var activityFormId = $('#formId').val();
            var activityFormName = $('#formName').val();
            var link = '<a target="_blank" href="${pageContext.request.contextPath}/web/admin/form/general/view/' + activityFormId + '">' + activityFormName + '</a>';
            $(div).find('.activityForm').html(link);
            $(div).find('input[name="activityFormType"]').val(ACTIVITY_FORM_TYPE_NORMAL);
            $(div).find('input[name="activityForm"]').val(activityFormId);

        }else if($('#externalFormUrl').val() != ''){
            var activityFormUrl = $('#externalFormUrl').val();
            $(div).find('.activityForm').text(activityFormUrl);
            $(div).find('input[name="activityFormType"]').val(ACTIVITY_FORM_TYPE_EXTERNAL);
            $(div).find('input[name="activityForm"]').val(activityFormUrl);
        }else{
            $(div).find('.activityForm').text('');
            $(div).find('input[name="activityFormType"]').val('');
            $(div).find('input[name="activityForm"]').val('');
        }

        <c:if test="${param.mode != 'edit'}">
            var permission = $('#category-${param.category}', window.parent.document).find('input[name="categoryPermission"]').val();
            $(div).find('input[name="permission"]').val(permission);
            $('#${param.divId} .activityList', window.parent.document).append(div);
        </c:if>

        window.parent.popupDialog.close();
    }
</script>

<commons:popupFooter />
