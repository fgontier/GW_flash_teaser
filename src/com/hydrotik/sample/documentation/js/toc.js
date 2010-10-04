

var currentHilight = null;

function setCurrentDocPageId (inId) {
	var id = inId.replace(/^page_/, "");
	if (currentHilight) {
		if (currentHilight.id == id) return;
		twiki.CSS.removeClass(currentHilight, "current");
	}
	var el = document.getElementById(id);
	if (el) {
		currentHilight = el;
		twiki.CSS.addClass(currentHilight, "current");
	}
}


