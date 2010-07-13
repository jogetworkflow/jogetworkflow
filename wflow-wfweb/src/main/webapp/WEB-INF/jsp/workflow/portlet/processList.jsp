<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<script>
    autoDetectJSLibrary(typeof jQuery == 'undefined', '${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/js/jquery/jquery-1.2.6.pack.js');

    function autoDetectJSLibrary(jsObjUndefined, src){
        if (jsObjUndefined) {
            var objHead = window.document.getElementsByTagName('head')[0];
            var objScript = window.document.createElement('script');
            objScript.src = src;
            objScript.type = 'text/javascript';
            objHead.appendChild(objScript);
        }
    }
</script>


<script type="text/javascript" src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/js/json/util.js"></script>

<c:set var="id" value="1"/>
<c:if test="${!empty param.id}"><c:set var="id" value="${param.id}"/></c:if>

<c:set var="rowsPerPage" value="5"/>
<c:if test="${!empty param.rows}"><c:set var="rowsPerPage" value="${param.rows}"/></c:if>

<c:set var="packageId" value="-1"/>
<cif test="${!empty param.packageId}"><c:set var="packageId" value="${param.packageId}"/></cif>

<script>

    var processUrlPath_${id}='${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}';
    var processNumber_${id}=0;
    var processPrevious_${id}=0;
    var processNext_${id};
    var processNoOfPaging_${id};
    var processTotal_${id};
    var processPackageId_${id}='${packageId}';
    var processRows_${id}=${rowsPerPage};
    var processSort_${id}='sort';
    var processDesc_${id}=true;
    var processPageReload_${id}=true;
    var processPaging_${id};

    var packageListCallback_${id} = {
        success : function(data) {
            var packageList = data.data;

            if(!packageList.length) packageList = [packageList];

            $('#processFilterByPackage_${id}').html('<option value="0">Select</option>');
            for(i=0; i<packageList.length; i++){
                var packageObj = packageList[i];

                var id = packageObj.packageId;
                var packageName = packageObj.packageName;

                $('#processFilterByPackage_${id}').append('<option value="'+id+'">'+packageName+'</option>');
            }
            }
    }

    var processListCallback_${id} = {
        success : function(data) {
            var obj = data;
            var data = obj.data;

            if(processPageReload_${id}){
                processTotal_${id} = obj.total;
                processNoOfPaging_${id} = processTotal_${id} / processRows_${id};
                if(processNoOfPaging_${id} > parseInt(processTotal_${id}/processRows_${id})) processNoOfPaging_${id} = parseInt(processTotal_${id}/processRows_${id}) + 1;
                processNext_${id}=processNoOfPaging_${id};

                if(processNext_${id}==1) $('#processNext_${id}').attr("disabled", true);

                /*Reload page selection*/
                $('#processPageTo_${id}').html('');
                for(i=1; i<=processNoOfPaging_${id}; i++){
                    $('#processPageTo_${id}').append('<option value="'+i+'">' + i + '</option>');
                }

                processPageReload_${id}=false;
            }


            $('#processList_${id}').html('');

            if(data!=null){
                if(!data.length) data = [data];

                for(i=0; i<data.length; i++){
                    var processObj = data[i];

                    var id = processObj.id;
                    var packageName = processObj.packageName;
                    var processName = processObj.name;
                    var version = processObj.version;

                    processNumber_${id}++;

                    var process = '<div class="portlet_table_data">';
                    process += '    <span class="portlet_table_number">'+processNumber_${id}+'.</span>';

                    process += '    <a href="javascript: processPopupDialog_${id}(\''+id+'\');" class="portlet_table_activity_accepted">'+processName+'</a>';

                    process += '    <div class="portlet_table_process">'+packageName+' - version '+version+'</div>';
                    process += '</div>';

                    $('#processList_${id}').append(process);
                }
            }
            $('#processRefresh_${id}').attr("disabled", false);
        }
    }

    if(processPackageId_${id}!=-1 && processPackageId_${id}!='') processPaging_${id}='packageId='+processPackageId_${id}+'&start=0&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};
    else processPaging_${id}='start=0&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};

    ConnectionManager.ajaxJsonp(processUrlPath_${id}+'/web/json/workflow/package/list', packageListCallback_${id}, null);
    ConnectionManager.ajaxJsonp(processUrlPath_${id}+'/web/json/workflow/process/list?'+processPaging_${id}, processListCallback_${id}, null);

    function doProcessRefresh_${id}(){
        $('#processRefresh_${id}').attr("disabled", true);

        processNumber_${id}=0;
        processPrevious_${id}=0;
        processDesc_${id}=true;
        processPageReload_${id}=true;
        $('#processNext_${id}').attr("disabled", false);
        $('#processPrevious_${id}').attr("disabled", true);
        $('#processFilterByPackage_${id}').val("0");

        if(processPackageId_${id}!=-1) processPaging_${id} = 'packageId='+processPackageId_${id}+'&start=0&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};
        else processPaging_${id} = 'start=0&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};

        ConnectionManager.ajaxJsonp(processUrlPath_${id}+'/web/json/workflow/process/list?'+processPaging_${id}, processListCallback_${id}, null);
    }

    function doProcessNext_${id}(){
        if(processNext_${id}>0 && processNext_${id}<=processNoOfPaging_${id}) {
            processPrevious_${id}++;
            processNext_${id}--;
            processNumber_${id}=processPrevious_${id}*processRows_${id};

            $('#processNext_${id}').attr("disabled", false);
            $('#processPrevious_${id}').attr("disabled", false);

            $('#processPageTo_${id}').val(processPrevious_${id}+1);

            if(processNext_${id}==1) $('#processNext_${id}').attr("disabled", true);

            if(processPackageId_${id}!=-1) processPaging_${id} = 'packageId='+processPackageId_${id}+'&start='+(processPrevious_${id}*processRows_${id})+'&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};
            else processPaging_${id} = 'start='+(processPrevious_${id}*processRows_${id})+'&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};

            ConnectionManager.ajaxJsonp(processUrlPath_${id}+'/web/json/workflow/process/list?'+processPaging_${id}, processListCallback_${id}, null);
        } else $('#processNext_${id}').attr("disabled", true);
    }

    function doProcessPrevious_${id}(){
        if(processPrevious_${id}>0 && processPrevious_${id}<=processNoOfPaging_${id}) {
            processNext_${id}++;
            processPrevious_${id}--;
            processNumber_${id}=processPrevious_${id}*processRows_${id};

            $('#processNext_${id}').attr("disabled", false);
            $('#processPrevious_${id}').attr("disabled", false);

            $('#processPageTo_${id}').val(processPrevious_${id}+1);

            if(processPrevious_${id}==0) $('#processPrevious_${id}').attr("disabled", true);

            if(processPackageId_${id}!=-1) processPaging_${id} = 'packageId='+processPackageId_${id}+'&start='+(processPrevious_${id}*processRows_${id})+'&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};
            else processPaging_${id} = 'start='+(processPrevious_${id}*processRows_${id})+'&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};

            ConnectionManager.ajaxJsonp(processUrlPath_${id}+'/web/json/workflow/process/list?'+processPaging_${id}, processListCallback_${id}, null);
        } else $('#processPrevious_${id}').attr("disabled", true);
    }

    function processFilterByPackage_${id}(){
        var filterByPackage = $('#processFilterByPackage_${id}').val();

        processNumber_${id}=0;
        processPageReload_${id}=true;

        if(filterByPackage==0) processPaging_${id}='start=0&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};
        else processPaging_${id}='packageId='+filterByPackage+'&start=0&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};

        if(processNoOfPaging_${id}==1) $('#processNext_${id}').attr("disabled", false);
        processPrevious_${id}=0;
        processNext_${id}=processNoOfPaging_${id};
        $('#processPrevious_${id}').attr("disabled", true);


        $('#processPageTo_${id}').val("0");

        ConnectionManager.ajaxJsonp(processUrlPath_${id}+'/web/json/workflow/process/list?'+processPaging_${id}, processListCallback_${id}, null);
    }

    function doProcessPage_${id}(){
        var pageOf = $('#processPageTo_${id}').val();

        processNumber_${id}=(pageOf-1)*processRows_${id};

        if(processPackageId_${id}!=-1) processPaging_${id} = 'packageId='+processPackageId_${id}+'&start='+((pageOf-1)*processRows_${id})+'&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};
        else processPaging_${id} = 'start='+((pageOf-1)*processRows_${id})+'&rows='+processRows_${id}+'&sort='+processSort_${id}+'&desc='+processDesc_${id};

        if(pageOf == processNoOfPaging_${id}) {
                $('#processNext_${id}').attr("disabled", true);
                $('#processPrevious_${id}').attr("disabled", false);
                processNext_${id}=1;
            processPrevious_${id}=processNoOfPaging_${id}-1;
            } else if(pageOf == 1) {
                $('#processPrevious_${id}').attr("disabled", true);
                $('#processNext_${id}').attr("disabled", false);
                processPrevious_${id}=0;
                processNext_${id}=processNoOfPaging_${id};
        } else {
                $('#processPrevious_${id}').attr("disabled", false);
                $('#processNext_${id}').attr("disabled", false);
                processPrevious_${id}=pageOf-1;
            processNext_${id}=processNoOfPaging_${id}-processPrevious_${id};
        }

        ConnectionManager.ajaxJsonp(processUrlPath_${id}+'/web/json/workflow/process/list?'+processPaging_${id}, processListCallback_${id}, null);
    }

    function processPopupDialog_${id}(processId){
        var url = processUrlPath_${id}+"/web/client/process/view/"+escape(processId);
        window.open(url, "_blank", "height=500,width=800,scrollbars=1");
    }

</script>

<div id="portlet_process_${id}">
    <div class="portlet_div_search">
        <div class="portlet_div_sorting">
            <span id="processFilterByPackageLabel_${id}" class="portlet_label"><fmt:message key="wflowClient.process.label.filter.by.package"/></span>
            <span id="processFilterByPackageInput_${id}" class="portlet_input">
                <select id="processFilterByPackage_${id}" name="package" onchange="processFilterByPackage_${id}()"></select>
            </span>
            <span>
                <input class="button" type="button" id="processRefresh_${id}" value="<fmt:message key='general.method.label.refresh'/>" onclick="doProcessRefresh_${id}();">
            </span>
        </div>

        <div class="portlet_div_paging">
            <span class="portlet_label"><fmt:message key="wflowClient.process.label.page"/></span>
            <span class="portlet_input">
                <select id="processPageTo_${id}" name="pageTo" onchange="doProcessPage_${id}()"></select>
            </span>
            <span><input class="button" type="button" id="processPrevious_${id}" value="<fmt:message key='general.method.label.previous'/>" onclick="doProcessPrevious_${id}();" disabled></span>
            <span><input class="button" type="button" id="processNext_${id}" value="<fmt:message key='general.method.label.next'/>" onclick="doProcessNext_${id}();"></span>
        </div>
    </div>

    <div class="portlet_table_list" id="processList_${id}"></div>
</div>

<script>
        if(processPackageId_${id}!=-1 && processPackageId_${id}!=''){
            $('#processFilterByPackageLabel_${id}').hide();
            $('#processFilterByPackageInput_${id}').hide();
        }
</script>