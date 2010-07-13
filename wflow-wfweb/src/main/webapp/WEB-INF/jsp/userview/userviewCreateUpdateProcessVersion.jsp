<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<commons:popupHeader />

    <div id="main-body-header">
        <div id="main-body-header-title">
            <fmt:message key="wflowClient.userview.new.label.updateProcessVersion"/>
        </div>
    </div>

    <div id="main-body-content" style="text-align: left">
        <c:forEach var="entry" items="${processVersionMap}">
            <c:set var="currentVersion" value="${fn:split(entry.key, '#')[1]}"/>

            <div class="form-row">
                <label class="long-label">${processNameMap[entry.key]}</label>
                <span class="form-input">
                    <select class="updateProcess" id="${entry.key}">
                        <c:forEach var="i" begin="1" end="${entry.value}" step="1">
                            <c:set var="selected"><c:if test="${i == currentVersion}"> selected</c:if></c:set>
                           <option ${selected}>${i}</option>
                        </c:forEach>
                    </select>
                        <c:if test="${!empty processVersionIsLatestMap[entry.key]}">
                            <fmt:message key="wflowClient.userview.new.label.isLatest"/>
                        </c:if>
                </span>
            </div>
   
        </c:forEach>

        <div class="form-buttons">
            <span class="button">
                <input type="button" onclick="submitProcessVersion()" value="<fmt:message key="general.method.label.submit"/>"/>
            </span>
        </div>
    </div>

<script type="text/javascript">
    function isActivityExists(response, activityId){
        if(response.data.length == undefined){
            return (activityId == response.data.id);
        }else{
            for(var i in response.data){
                if(activityId == response.data[i].id){
                    return true;
                }
            }
        }
        return false;
    }

    function columnToArray(response){
        var columnList = new Array();

        if(response.data.length == undefined){
            columnList.push(response.data);
        }else{
            for(var i in response.data){
                columnList.push(response.data[i]);
            }
        }
        return columnList;
    }

    function getMismatchColumn(response, columnString){
        var mismatchColumnList = new Array();

        var pairList = columnString.split(', ');
        var responseColumnList = columnToArray(response);
        
        for(var i in pairList){
            var column = pairList[i].split(':')[0];

            var found = false;
            for(var j in responseColumnList){
                if(column.replace('(System)', '') == responseColumnList[j].replace('c_', '')){
                    found = true;
                    break;
                }
            }

            if(!found){
                mismatchColumnList.push(column);
            }
        }

        return mismatchColumnList
    }

    var activityStatusMap = new Array();
    function submitProcessVersion(){
        //initialize status map
        $.each($(".activityBlock", window.parent.document), function(i, v){
            var processIdInput = $(v).find('input[name="process"]');
            if($(processIdInput).val() != ''){
                activityStatusMap.push(false);
            }
        });

        $.each($('.updateProcess'), function(i, v){
            var processId = $(v).attr('id');
            var selectedVersion = $(v).val();
            var newProcessId = processId.replace(/#([0-9]+)#/, '#' + selectedVersion + '#');
            
            var startProcessDefId = $("#startProcessDefId", window.parent.document).val();
            if(startProcessDefId == escape(processId)){
                $("#startProcessDefId", window.parent.document).val(escape(newProcessId));
            }

            $.each($(".activityBlock", window.parent.document), function(i2, v2){
                var processIdInput = $(v2).find('input[name="process"]');
                if($(processIdInput).val() != ''){
                    if($(processIdInput).val() == processId){
                        $(processIdInput).val(newProcessId);
                        var link = $(v2).find('.process').html();
                        $(v2).find('.process').html(link.replace(escape(processId), escape(newProcessId)));

                        var getActivityCallback = function(response){
                            var response = eval('(' + response + ')');
                            var selectedActivity = $(v2).find('input[name="activity"]').val();

                            if(!isActivityExists(response, selectedActivity)){
                                $(v2).parent().remove();
                                activityStatusMap[i2] = true;
                                checkActivityStatus();

                            }else{

                                var getColumnCallback = function(response){
                                    var response = eval('(' + response + ')');
                                    var selectedColumns = $(v2).find('input[name="columns"]').val();
                                    var selectedFilter = $(v2).find('input[name="filter"]').val();
                                    var selectedSort = $(v2).find('input[name="sort"]').val();

                                    var mismatchColumn = getMismatchColumn(response, selectedColumns);

                                    for(var k in mismatchColumn){
                                        var regex = new RegExp(mismatchColumn[k] + '(, )?', 'g');
                                        selectedColumns = selectedColumns.replace(regex, '');
                                        selectedFilter = selectedFilter.replace(regex, '');
                                        selectedSort = selectedSort.replace(regex, '');
                                    }

                                    $(v2).find('input[name="columns"]').val(selectedColumns);
                                    $(v2).find('.columns').text(selectedColumns);
                                    $(v2).find('input[name="filter"]').val(selectedFilter);
                                    $(v2).find('.filter').text(selectedFilter);
                                    $(v2).find('input[name="sort"]').val(selectedSort);
                                    $(v2).find('.sort').text(selectedSort);

                                    activityStatusMap[i2] = true;
                                    checkActivityStatus();
                                }
                                $.get('${pageContext.request.contextPath}/web/json/userview/getColumnList/' + escape(newProcessId) + '/' + selectedActivity, getColumnCallback);
                            }
                        }

                        $.get('${pageContext.request.contextPath}/web/json/userview/getActivityListWithFormMapping/' + escape(newProcessId), getActivityCallback);
                    }
                }
            });
        })
    }

    function checkActivityStatus(){
        var done = true;
        for(i in activityStatusMap){
            if(activityStatusMap[i] == false){
                done = false;
                break;
            }
        }

        if(done){
            window.parent.popupDialog.close();
        }
    }
</script>

<commons:popupFooter />