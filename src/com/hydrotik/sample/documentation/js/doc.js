


var Member = function (inElement, inDisplay) {
	this.element = inElement;
	this.display = inDisplay;
}
Member.prototype.element;
Member.prototype.display;


var VisDoc = {
	privateMembers:[],
	addToPrivate:function(el) {
		var member = new Member(el, el.style.display);
		this.privateMembers.push(member);
	},
	initBody:function(el) {
		if (!el) el = document.getElementsByTagName('body')[0];
		twiki.CSS.addClass(el, "hasJavascript");
		if (parent.location.href != self.location.href) {
			// page is framed
			// set body class to 'framed': <body class="framed">
			// to address css style 'framed'
			// so that the margins can be defined differently
			twiki.CSS.addClass(el, "framed");
			//top.setCurrentPage(el.id);
		}
	},
	showTOC:function(el) {
		parent.location = "index.html?" + self.location.href;
	},
	hideTOC:function(el) {
		parent.location = self.location;
	},
	showPrivateMembers:function() {
		var i,ilen = this.privateMembers.length;
		for (i=0; i<ilen; ++i) {
			var member = this.privateMembers[i];
			member.element.style.display = member.display;
		}
	},
	hidePrivateMembers:function() {
		var i,ilen = this.privateMembers.length;
		for (i=0; i<ilen; ++i) {
			var member = this.privateMembers[i];
			member.element.style.display = "none";
		}
	},
	updatePrivateState:function(inState){
		if (inState == "show") {
			this.showPrivateMembers();
			twiki.Pref.setPref("showPrivate", "1");
			return;
		} else if (inState == "hide") {
			this.hidePrivateMembers();
			twiki.Pref.setPref("showPrivate", "0");
			return;
		}
		if (!inState) {
			var doShowPrivateMembers = twiki.Pref.getPref("showPrivate");
			if (doShowPrivateMembers == "0") {
				this.hidePrivateMembers();
			} else {
				this.showPrivateMembers();
			}
		}
	}
}

var myrules = {
	'body': function(el){
		VisDoc.initBody(el);
	},
	'.private' : function(el){
		VisDoc.addToPrivate(el);
	},
	'#toggleTOC_on a' : function(el){
		el.onclick = function() {
			VisDoc.showTOC(el);
			return false;
		}
	},
	'#toggleTOC_off a' : function(el){
		el.onclick = function() {
			VisDoc.hideTOC(el);
			return false;
		}
	},
	'#togglePrivate_on a' : function(el) {
		el.onclick = function() {
			VisDoc.updatePrivateState("hide");
			return false;
		}
	},
	'#togglePrivate_off a' : function(el) {
		el.onclick = function() {
			VisDoc.updatePrivateState("show");
			return false;
		}
	}
};

Behaviour.register(myrules);

function initFromCookie () {
	VisDoc.updatePrivateState();
}
twiki.Event.addLoadEvent(initFromCookie);

/*
Tells the toc frame to update and highlight the link that corresponds to the shown page.
*/
function setCurrentPage() {
	var el = document.getElementsByTagName('body')[0];
	if (el) {
		var tocFrame;
		if (top.tocFrame && top.tocFrame.setCurrentDocPageId) {
			tocFrame = top.tocFrame;
		}
		if (top.packageTocFrame && top.packageTocFrame.tocFrame && top.packageTocFrame.tocFrame.setCurrentDocPageId) {
			tocFrame = top.packageTocFrame.tocFrame;
		}
		if (tocFrame) {
			tocFrame.setCurrentDocPageId(el.id);
		}
	}
}
twiki.Event.addLoadEvent(setCurrentPage);


