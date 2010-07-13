//require plugin by Mohd Khairi Lamsah (hairiemx at gmail dot com)
//Feel free to modify it. 

(function($){
   $.plg={
		inited:false,
		list:{},
		css:{},
		fn:[],
		queue:[],
		jsBase:'.',
		cssBase:'.',
		complete:function(){
			$.plg.inited=false;
			$(document).ready(function(){
				while($.plg.fn.length)
					$.plg.fn.shift().apply(document);
			});
		},
		next: function(){	  
		  var plugin=$.plg.queue.shift();
			$.plg.inited=true;
			if(typeof $.plg.list[plugin.name]=='undefined'){
			  var src = $.plg.jsBase + '/' + plugin.name + '.js';
			  $.plg.list[plugin.name]=false;
			  $.get(src, function(data){
				$.plg.list[plugin.name]=true;
				//Evaluate later when dom is ready
				$.plg.fn.push(function(){eval.call(window,data);});
				//Run plugin onload after dom is ready
				if(plugin.onload)$.plg.fn.push(plugin.onload);
				//Proceed to next 
				$.plg.proceed();
			  });						
			}
			else if ($.plg.list[plugin.name]){
				//If the plugin is already loaded, 
				//push onload to function queue and 
				//proceed to next plugin.
				if(plugin.onload)
					$.plg.fn.push(plugin.onload);
				$.plg.proceed();
			}
			
		},  
		proceed:function(){
			if($.plg.queue.length)
				$.plg.next();
			else
				$.plg.complete();							
		}
   };
   
   //Try get jquery-require.js base path
   $("head").find("script:last").each(function(){
		var pathArray=this.src.split('/');
		pathArray.pop();
		$.plg.jsBase=pathArray.join('/') || '.';
		$.plg.cssBase=$.plg.jsBase + '/css';
   });
   
   $.extend({
	requirecss: function(c){
	  var cList=c.split(",");
	  for(var i=0;i<cList.length;i++){
		  var cssFile=cList[i];
		  if(typeof $.plg.css[cssFile]=="undefined"){	
				var c = document.createElement('link'); 
				c.type = 'text/css';
				c.rel = 'stylesheet';
				c.href = $.plg.cssBase + '/' + cssFile + '.css';
				$('head')[0].appendChild(c);
				$.plg.css[cssFile]=true;
		  }
	  }			
	},
	require: function(plugin){
	  var p=plugin.split(',');
	  //If no onload function is assigned, assigned load function to null
	  var func=arguments.length > 1?arguments[1]:null;
	  var pLength=p.length;
	  for(var i=0;i<pLength;i++){
	  	  //Push the plugin into queue
		  $.plg.queue.push({name: p[i], onload: (i==pLength-1?func:null)}); 
	  }
	  if(!$.plg.inited){
		  $.plg.next();
	  }
	}	   
  });

 $.fn.extend({
	requireComplete: function(f) {
		//If plugin loading process complete
		if (!$.plg.inited){
			// Execute the function immediately
			f.apply( document );
		}
		// Otherwise, remember the function for later
		else 
			// Add the function to the wait list
			$.plg.fn.push( f );
	
		return this;
	}
  });
})(jQuery);