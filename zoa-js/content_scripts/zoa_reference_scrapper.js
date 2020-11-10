browser.runtime.onMessage.addListener(updateBg);

function updateBg(request, sender, sendResponse) {
  var html = document.querySelector('html');
  var body = document.querySelector('body');
 	
  if(request)
 	 if (request.fetchContent) {
		 var contents = document.URL + ' Is not a valid cite to crawl ';
		 if( document.domain == "ieeexplore.ieee.org" ) {
			 contents = '';
			 var refs = document.querySelector("#references-section-container");
			 var cits = document.querySelector("#citations-section-container");
			 var cits2 =  document.querySelector("#anchor-paper-citations-ieee");
			 if(refs != null) {
				 contents += '<references>' + refs.innerHTML + '</references>';
			 }
			 if(cits != null) {
				 contents += '<citations>' + cits.innerHTML + '</citations>' ;
			 }
			 if(cits2 != null) {
				 contents += '<citations>' + cits2.innerHTML + '</citations>' ;
			 }
		 }
		 if( document.domain == "onlinelibrary.wiley.com" ) {
			 contents = 'Remeber to click on the References tab before using the plugin';
			 var refs = (document.querySelector('.rlist .lot'));
			 if(refs != null) {
				 contents += '<references>' + refs.innerHTML + '</references>';
			 }
		 }
			 
  	  sendResponse({content: contents });  
  	}
}
