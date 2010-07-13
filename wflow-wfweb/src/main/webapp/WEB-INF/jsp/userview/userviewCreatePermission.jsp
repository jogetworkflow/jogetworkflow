<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<commons:popupHeader title="asd"/>

<style>
</style>

    <div id="main-body-content" style="text-align: left">
        <div id="group">
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/dynamic/admin/group/list?${pageContext.request.queryString}"
                       var="groupDataTable"
                       divToUpdate="groupList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       height="350"
                       sort="name"
                       desc="false"
                       href=""
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle=""
                       checkbox="true"
                       checkboxId="id"
                       checkboxButton1="general.method.label.submit"
                       checkboxCallback1="submitGroup"
                       checkboxSelection="true"
                       checkboxSelectionTitle="Selected Groups"
                       searchItems="name|Group Name"
                       fields="['id','name','description']"
                       column1="{key: 'name', label: 'wflowAdmin.userview.permission.label.groupName', sortable: true}"
                       column2="{key: 'description', label: 'wflowAdmin.userview.permission.label.groupDescription', sortable: false}"
                       />
        </div>
    </div>

<script>
    function submitGroup(id){
        var div = $('#category-${param.categoryId}', window.parent.document);
        
        if(id.length > 0){

            if( $(div).find('input[name="categoryPermission"]').val().length == 0 ){
                $(div).find('.categoryPermissionValue').html("");
            }

            var text = "";

            var existingGroupId = $(div).find('input[name="permission"]').val();
            var newId = new Array();
            var j = 0;

            for(var i=0; i<id.length; i++) {
                //append if unique
                if( existingGroupId.indexOf(id[i]) == -1){
                    var name = $("table#groupList tbody tr#row"+escapeId(id[i])+" td:eq(1) div").html();
                    text += "<span class=\"category-permission-item\"><a onClick=\"categoryItemRemoveSingle(this,'category-${param.categoryId}','" + escape(id[i]) + "');\"> <img src=\"${pageContext.request.contextPath}/images/joget/cross-circle.png\"/></a><a class=\"category-permission-item-text\" target=\"_blank\" href=\"${pageContext.request.contextPath}/web/directory/admin/group/view/"+escape(id[i])+"\">"+name+"</a></span> ";
                    newId[j] = id[i];
                    j++;
                }
            }
            text = text.substring(0, text.length - 2);

            if(newId.length > 0){
                $(div).find('.categoryPermissionValue').html( $(div).find('.categoryPermissionValue').html() + " " + text);
                $(div).find('input[name="categoryPermission"]').val( $(div).find('input[name="categoryPermission"]').val() + "," + newId);
                $(div).find('input[name="permission"]').val( $(div).find('input[name="permission"]').val() + "," + newId);

                //remove extra comma
                var regex = new RegExp("^,|,$","g");
                $(div).find('input[name="categoryPermission"]').val( $(div).find('input[name="categoryPermission"]').val().replace(regex,""));
                $(div).find('input[name="permission"]').val( $(div).find('input[name="permission"]').val().replace(regex,""));
            }
        }
        window.parent.popupDialog.close();
    }

    function escapeId(str){
        return str.replace(/([#;&,\.\+\*\~':"\!\^$\[\]\(\)=>\|])/g, "\\\\$1");
    }
</script>

<commons:popupFooter />