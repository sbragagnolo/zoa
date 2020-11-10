/* initialise variables */
 var $j = jQuery.noConflict();
var crawled = document.querySelector('textarea');


function getActiveTab() {
  return browser.tabs.query({active: true, currentWindow: true});
}

/* apply backgrounds to buttons */
/* add listener so that when clicked, button applies background to page HTML */
getActiveTab().then((tabs) => {
	browser.tabs.sendMessage(tabs[0].id, {fetchContent: true}).then(function(response) {
		crawled.removeChild(crawled.firstChild); 
		crawled.value=response.content; 
	} );
 } ); 
