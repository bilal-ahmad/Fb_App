jQuery(document).ready(function() {
	jQuery('.slider').jcarousel( {
		initCallback: slider_initCallback,
		itemFirstInCallback: slider_firstInCallback,
		scroll: 1,
		auto: 5,
		wrap: 'both',
		// This tells jCarousel NOT to autobuild prev/next buttons
		buttonNextHTML: null,
		buttonPrevHTML: null
	});
});

function slider_initCallback (carousel) {
	
	jQuery('.slider-nav a').bind('click', function() {
		carousel.scroll($.jcarousel.intval($(this).text()));
		return false;
	});
}

function slider_firstInCallback(carousel, item, idx, state) {
	jQuery('.slider-nav a').removeClass('active');
	jQuery('.slider-nav a').eq(idx-1).addClass('active');
}

function social_post(id){
   // alert(id);
    url = "/post_to_wall";
    $.post(url, { post_type: "default" , _method: 'post', 'users[]': id },
        function(data) {
            alert("Data Loaded: " + data);
        });
}


$('#fb_div').click(function() {
    alert("hi");
    $('#facebook_accounts').toggle();
});

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-28041248-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

