<script type="text/javascript">
    var parentUrlQueryString = parent.location.search;
    if(parentUrlQueryString == '')
        parent.location.href = parent.location.href + "?tab=activityList";
    else{
        if(parentUrlQueryString.indexOf('tab') == -1)
            parent.location.href = parent.location.href + "&tab=activityList";
        else{

            parent.location.href = parent.location.href.replace(parentUrlQueryString, '') + "?tab=activityList";
        }
    }
</script>