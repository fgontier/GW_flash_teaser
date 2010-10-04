

/*
TWiki Javascripts: copyright TWiki, Arthur Clemens
*/

var twiki = {};
twiki.Event = {

	/**
	Chain a new load handler onto the existing handler chain
	Original code: http://simon.incutio.com/archive/2004/05/26/addLoadEvent
	Modified for TWiki
	@param inFunction : (Function) function to add
	@param inDoPrepend : (Boolean) if true: adds the function to the head of the handler list; otherwise it will be added to the end (executed last)
	*/
	addLoadEvent:function (inFunction, inDoPrepend) {
		if (typeof(inFunction) != "function") {
			return;
		}
		var oldonload = window.onload;
		if (typeof window.onload != 'function') {
			window.onload = function() {
				inFunction();
			};
		} else {
			var prependFunc = function() {
				inFunction(); oldonload();
			};
			var appendFunc = function() {
				oldonload(); inFunction();
			};
			window.onload = inDoPrepend ? prependFunc : appendFunc;
		}
	}
	
};

twiki.Function = {

	/**
	Easy inheritance, see http://blogger.xs4all.nl/peterned/archive/2006/01/12/73948.aspx
	@param inClass : (Function) Function object to extend
	@param inSuperClass : (Function) Function object to extend from
	@return The extended inClass Function object.
	@use
	<pre>
		function AThing() {}
		function BThing(lorem, ipsum, dolor) {}
		BThing = twiki.twikiFunction.extendClass(BThing, AThing);
		// BThing prototype functions here...
	</pre>
	*/
	extendClass:function(inClass, inSuperClass) {
		var Func = function() {
			inSuperClass.apply(this, arguments);
			inClass.apply(this, arguments);
		};
		Func.prototype = new inSuperClass();
		return Func;
	}
};

twiki.CSS = {

	/**
	Remove the given class from an element, if it is there.
	@param inElement : (HTMLElement) element to remove the class of
	@param inClassName : (String) CSS class name to remove
	*/
	removeClass:function(inElement, inClassName) {
		var classes = twiki.CSS.getClassList(inElement);
		if (!classes) return;
		var index = twiki.CSS._indexOf(classes, inClassName);
		if (index >= 0) {
			classes.splice(index,1);
			twiki.CSS.setClassList(inElement, classes);
		}
	},
	
	/**
	Add the given class to the element, unless it is already there.
	@param inElement : (HTMLElement) element to add the class to
	@param inClassName : (String) CSS class name to add
	*/
	addClass:function(inElement, inClassName) {
		var classes = twiki.CSS.getClassList(inElement);
		if (!classes) return;
		if (twiki.CSS._indexOf(classes, inClassName) < 0) {
			classes[classes.length] = inClassName;
			twiki.CSS.setClassList(inElement,classes);
		}
	},
	
	/**
	Replace the given class with a different class on the element.
	The new class is added even if the old class is not present.
	@param inElement : (HTMLElement) element to replace the class of
	@param inOldClass : (String) CSS class name to remove
	@param inNewClass : (String) CSS class name to add
	*/
	replaceClass:function(inElement, inOldClass, inNewClass) {
		twiki.CSS.removeClass(inElement, inOldClass);
		twiki.CSS.addClass(inElement, inNewClass);
	},
	
	/**
	Get an array of the classes on the object.
	@param inElement : (HTMLElement) element to get the class list from
	*/
	getClassList:function(inElement) {
		if (inElement.className && inElement.className != "") {
			return inElement.className.split(' ');
		}
		return [];
	},
	
	/**
	Set the classes on an element from an array of class names.
	@param inElement : (HTMLElement) element to set the class list to
	@param inClassList : (Array) list of CSS class names
	*/
	setClassList:function(inElement, inClassList) {
		inElement.className = inClassList.join(' ');
	},
	
	/**
	Determine if the element has the given class string somewhere in it's
	className attribute.
	@param inElement : (HTMLElement) element to check the class occurrence of
	*/
	hasClass:function(inElement, inClassName) {
		if (inElement.className) {
			var classes = twiki.CSS.getClassList(inElement);
			if (classes) return (twiki.CSS._indexOf(classes, inClassName) >= 0);
			return false;
		}
	},
	
	/* PRIVILIGED METHODS */
	
	/**
	See: twiki.Array.indexOf
	Function copied here to prevent extra dependency on twiki.Array.
	*/
	_indexOf:function(inArray, inElement) {
		if (!inArray || inArray.length == undefined) return null;
		var i, ilen = inArray.length;
		for (i=0; i<ilen; ++i) {
			if (inArray[i] == inElement) return i;
		}
		return -1;
	}

}

/*
Contains:
Cookie Functions -- "Night of the Living Cookie" Version (25-Jul-96)
Written by:  Bill Dortch, hIdaho Design <bdortch@hidaho.com>
The following functions are released to the public domain.

Refactored for TWiki by Arthur Clemens 2006.
*/

/**
The preferred way for reading and writing cookies is using getPref and setPref, otherwise the limit of 20 cookies per domain is reached soon. See http://twiki.org/cgi-bin/view/TWiki/TWikiSettingsCookie.
*/

twiki.Pref = {
	
	TWIKI_PREF_COOKIE_NAME:"TWIKIPREF",
	/**
	Separates key-value pairs
	*/
	COOKIE_PREF_SEPARATOR:"|",
	/**
	Separates key from value
	*/
	COOKIE_PREF_VALUE_SEPARATOR:"=",
	/**
	By default expire one year from now.
	*/
	COOKIE_EXPIRY_TIME:365 * 24 * 60 * 60 * 1000,

	/**
	Writes a TWiki preference value. If the TWiki preference of given name already exists, a new value is written. If the preference name is new, a new preference is created.
	Characters '|' and '=' are reserved as separators.
	@param inPrefName : (String) name of the preference to write, for instance 'SHOWATTACHMENTS'
	@param inPrefValue : (String) stringified value to write, for instance '1'
	*/
	setPref:function(inPrefName, inPrefValue) {
		var prefName = twiki.Pref._getSafeString(inPrefName);
		var prefValue = (isNaN(inPrefValue)) ? twiki.Pref._getSafeString(inPrefValue) : inPrefValue;
		var cookieString = twiki.Pref._getPrefCookie();
		var prefs = cookieString.split(twiki.Pref.COOKIE_PREF_SEPARATOR);
		var index = twiki.Pref._getKeyValueLoc(prefs, prefName);
		if (index != -1) {
			// updating this entry is done by removing the existing entry from the array and then pushing the new key-value onto it
			prefs.splice(index, 1);
		}
		// else not found, so don't remove an existing entry
		var keyvalueString = prefName + twiki.Pref.COOKIE_PREF_VALUE_SEPARATOR + prefValue;
		prefs.push(keyvalueString);
		twiki.Pref._writePrefValues(prefs);
	},
	
	/**
	Reads the value of a preference.
	Characters '|' and '=' are reserved as separators.
	@param inPrefName (String): name of the preference to read, for instance 'SHOWATTACHMENTS'
	@return The value of the preference; an empty string when no value is found.
	*/
	getPref:function(inPrefName) {
		var prefName = twiki.Pref._getSafeString(inPrefName);
		return twiki.Pref.getPrefValueFromPrefList(prefName, twiki.Pref.getPrefList());
	},
	
	/**
	Reads the value of a preference from an array of key-value pairs. Use in conjunction with getPrefList() when you want to store the key-value pairs for successive look-ups.
	@param inPrefName (String): name of the preference to read, for instance 'SHOWATTACHMENTS'
	@param inPrefList (Array): list of key-value pairs, retrieved with getPrefList()
	@return The value of the preference; an empty string when no value is found.
	*/
	getPrefValueFromPrefList:function(inPrefName, inPrefList) {
		var keyvalue = twiki.Pref._getKeyValue(inPrefList, inPrefName);
		if (keyvalue != null) return keyvalue[1];
		return '';
	},
	
	/**
	Gets the list of all values set with setPref.
	@return An Array of key-value pair pref values; null if no value has been set before.
	*/
	getPrefList:function() {
		var cookieString = twiki.Pref._getPrefCookie();
		if (!cookieString) return null;
		return cookieString.split(twiki.Pref.COOKIE_PREF_SEPARATOR);
	},
	
	/**
	To write a TWiki preference cookie (TWIKIPREF), use twiki.Pref.setPref.
	
	Retrieves the value of the cookie specified by "name".
	@param inName : (String) identifier name of the cookie
	@return (String) the cookie value; null if no cookie with name inName has been set.
	*/
	getCookie:function(inName) {
		var arg = inName + "=";
		var alen = arg.length;
		var clen = document.cookie.length;
		var i = 0;
		while (i < clen) {
			var j = i + alen;
			if (document.cookie.substring(i, j) == arg) {
				return twiki.Pref._getCookieVal(j);
			}
			i = document.cookie.indexOf(" ", i) + 1;
			if (i == 0) break; 
		}
		return null;
	},
	
	/**
	Creates a new cookie or updates an existing cookie.
	@param inName : (String) identifier name of the cookie
	@param inValue : (String) stringified cookie value, for instance '1'
	@param inExpires : (Date) (optional) the expiration data of the cookie; if omitted or null, expires the cookie at the end of the current session
	@param inPath : (String) (optional) the path for which the cookie is valid; if omitted or null, uses the path of the current document
	@param inDomain : (String) (optional) the domain for which the cookie is valid; if omitted or null, uses the domain of the current document
	@param inUsesSecure : (Boolean) (optional) whether cookie transmission requires a secure channel (https)
	@use
	To call setCookie using name, value and path, write:
	<pre>
	twiki.Pref.setCookie ("myCookieName", "myCookieValue", null, "/");
	</pre>	
	To set a secure cookie for path "/myPath", that expires after the current session, write:
	<pre>
	twiki.Pref.setCookie ("myCookieName", "myCookieValue", null, "/myPath", null, true);
	</pre>
	*/
	setCookie:function(inName, inValue, inExpires, inPath, inDomain, inUsesSecure) {
		var cookieString = inName + "=" + escape (inValue) +
			((inExpires) ? "; expires=" + inExpires.toGMTString() : "") +
			((inPath) ? "; path=" + inPath : "") +
			((inDomain) ? "; domain=" + inDomain : "") +
			((inUsesSecure) ? "; secure" : "");
		document.cookie = cookieString;
	},
	
	/**
	Function to delete a cookie. (Sets expiration date to start of epoch)
	@param inName : (String) identifier name of the cookie
	@param inPath : (String) The path for which the cookie is valid. This MUST be the same as the path used to create the cookie, or null/omitted if no path was specified when creating the cookie.
	@param inDomain : (String) The domain for which the cookie is valid. This MUST be the same as the domain used to create the cookie, or null/omitted if no domain was specified when creating the cookie.
	*/
	deleteCookie:function(inName, inPath, inDomain) {
		if (twiki.Pref.getCookie(inName)) {
			document.cookie = inName + "=" + ((inPath) ? "; path=" + inPath : "") + ((inDomain) ? "; domain=" + inDomain : "") + "; expires=Thu, 01-Jan-70 00:00:01 GMT";
		}
	},
	
	/* PRIVILIGED METHODS */
	
	/**
	Finds a key-value pair in an array.
	@param inKeyValues: (Array) the array to iterate
	@param inKey: (String) the key to find in the array
	@return The first occurrence of a key-value pair, where key == inKey; null if none is found.
	*/
	_getKeyValue:function(inKeyValues, inKey) {
		if (!inKeyValues) return null;
		var i = inKeyValues.length;
		while (i--) {
			var keyvalue = inKeyValues[i].split(twiki.Pref.COOKIE_PREF_VALUE_SEPARATOR);
			if (keyvalue[0] == inKey) return keyvalue;	
		}
		return null;
	},
	
	/**
	Finds the location of a key-value pair in an array.
	@param inKeyValues: (Array) the array to iterate
	@param inKey: (String) the key to find in the array
	@return The location of the first occurrence of a key-value tuple, where key == inKey; -1 if none is found.
	*/
	_getKeyValueLoc:function(inKeyValues, inKey) {
		if (!inKeyValues) return null;
		var i = inKeyValues.length;
		while (i--) {
			var keyvalue = inKeyValues[i].split(twiki.Pref.COOKIE_PREF_VALUE_SEPARATOR);
			if (keyvalue[0] == inKey) return i;	
		}
		return -1;
	},
	
	/**
	Writes a cookie with the stringified array values of inValues.
	@param inValues: (Array) an array with key-value tuples
	*/
	_writePrefValues:function(inValues) {
		var cookieString = (inValues != null) ? inValues.join(twiki.Pref.COOKIE_PREF_SEPARATOR) : '';
		var expiryDate = new Date ();
		twiki.Pref._fixCookieDate (expiryDate); // Correct for Mac date bug - call only once for given Date object!
		expiryDate.setTime (expiryDate.getTime() + twiki.Pref.COOKIE_EXPIRY_TIME);
		twiki.Pref.setCookie(twiki.Pref.TWIKI_PREF_COOKIE_NAME, cookieString, expiryDate, '/');
	},
	
	/**
	Gets the TWiki pref cookie; creates a new cookie if it does not exist.
	@return The TWiki pref cookie.
	*/
	_getPrefCookie:function() {
		var cookieString = twiki.Pref.getCookie(twiki.Pref.TWIKI_PREF_COOKIE_NAME);
		if (cookieString == undefined) {
			cookieString = "";
		}
		return cookieString;
	},
	
	/**
	Strips reserved characters '|' and '=' from the input string.
	@return The stripped string.
	*/
	_getSafeString:function(inString) {
		var regex = new RegExp(/[|=]/);
		return inString.replace(regex, "");
	},
	
	/**
	Retrieves the decoded value of a cookie.
	@param inOffset : (Number) location of value in full cookie string.
	*/
	_getCookieVal:function(inOffset) {
		var endstr = document.cookie.indexOf (";", inOffset);
		if (endstr == -1) {
			endstr = document.cookie.length;
		}
		return unescape(document.cookie.substring(inOffset, endstr));
	},
	
	/**
	Function to correct for 2.x Mac date bug.  Call this function to
	fix a date object prior to passing it to setCookie.
	IMPORTANT:  This function should only be called *once* for
	any given date object!  See example at the end of this document.
	*/
	_fixCookieDate:function(inDate) {
		var base = new Date(0);
		var skew = base.getTime(); // dawn of (Unix) time - should be 0
		if (skew > 0) {	// Except on the Mac - ahead of its time
			inDate.setTime(inDate.getTime() - skew);
		}
	}
}

/**
Required javascript:
- behaviour.js
- twikiFunction.js

ui.Toggle element switches between 2 states: on and off. This might be useful to show 2 alternating buttons, for instance: "Show left bar" "Hide left bar".

ui.Toggle HTML will look like this;

<pre>
<div id="togglePrivate_on" class="toggleTrigger toggleMakeVisible">
  <a href="#">Show private members</a>
</div>
<script type="text/javascript">twiki.ui.Toggle.getInstance().init("togglePrivate_on");</script>
<div id="togglePrivate_off" class="toggleTrigger toggleMakeVisible">
  <a href="#">Hide private members</a>
</div>
<script type="text/javascript">twiki.ui.Toggle.getInstance().init("togglePrivate_off");</script>
</pre>

Line by line:

<pre><div id="togglePrivate_on"</pre><br />
The syntax is: toggle id + "on". The same toggle id is used for all toggled elements.

<pre>class="toggleTrigger toggleMakeVisible"</pre><br />
CSS class "toggleTrigger" is a behaviour class that will init the button at window onload. CSS class "toggleMakeVisible" makes the button invisible when the user does not have javascript enabled.

<pre><a href="#">Show private members</a></pre><br />
The link has an empty url. Rather the click event is caught using a behaviour (see below).

<pre><script type="text/javascript">twiki.ui.Toggle.getInstance().init("togglePrivate_on");</script></pre>
This line is optional, but makes sure the toggle element is initialized as soon as it is rendered on the page and not at onload (after the complete page has been rendered).

<pre><div id="togglePrivate_off"</pre>
The "off" button.

To call a function when the ui.Toggle is clicked, use a Behaviour:
<pre>
var ToggleUIbehaviour = {	
	'#togglePrivate_on' : function(e) {
		onclick = function (e) {
			// your function call
			return false;
		}
	},
	'#togglePrivate_off' : function(e) {
		onclick = function (e) {
			// your function call
			return false;
		}
	}
};
Behaviour.register(ToggleUIbehaviour);
</pre>

Other settings:
- toggleRememberSetting
- toggleForgetSetting
- toggleStartHide
- toggleStartShow
- toggleFirstStartShow
- toggleFirstStartHide

See TwistyPlugin for examples.

*/

if (twiki.ui == undefined) twiki.ui = {};
twiki.ui.Toggle = function () {
						
	var self = this;
	
	/**
	Overridable properties.
	*/
	this.BUTTON_ON_NAME = "on";
	this.BUTTON_OFF_NAME = "off";
	this.BUTTON_NAME_OPTIONS = this.BUTTON_ON_NAME + "|"+ this.BUTTON_OFF_NAME;
	this.ELEMENT_OPTIONS = this.BUTTON_NAME_OPTIONS;
	this.DATA_CLASS = twiki.ui.ToggleData;
	this.CSS_CLASS_HIDDEN = 			"toggleHidden";
	this.CSS_CLASS_MAKEHIDDEN =			"toggleMakeHidden";
	this.CSS_CLASS_MAKEVISIBLE =		"toggleMakeVisible";
	this.CSS_CLASS_REMEMBERSETTING =	"toggleRememberSetting";
	this.CSS_CLASS_FORGETSETTING =		"toggleForgetSetting";
	this.CSS_CLASS_STARTHIDE =			"toggleStartHide";
	this.CSS_CLASS_STARTSHOW =			"toggleStartShow";
	this.CSS_CLASS_FIRSTSTARTSHOW =		"toggleFirstStartShow";
	this.CSS_CLASS_FIRSTSTARTHIDE =		"toggleFirstStartHide";

	/**
	Retrieves the name of the twisty from an HTML element id. For example 'demotoggle' will return 'demo'.
	@param inId : (String) HTML element id
	@return String
	@privileged
	*/
	this._getName = function (inId) {
		var re = new RegExp("(.*)(" + this.ELEMENT_OPTIONS + ")", "g");
		var m = re.exec(inId);
		var name = (m && m[1]) ? m[1] : "";
		return name;
	}
	
	/**
	Retrieves the type of the twisty from an HTML element id. For example 'demotoggle' will return 'toggle'.
	@param inId : (String) HTML element id
	@return String
	@privileged
	*/
	this._getType = function (inId) {
		var re = new RegExp("(.*)(" + this.ELEMENT_OPTIONS + ")", "g");
		var m = re.exec(inId);
		var type = (m && m[2]) ? m[2] : "";
		return type;
	}
	
	/**
	Toggles the collapsed state. Calls _update().
	@param data
	@param inState : (Number) (optional) the state to toggle to: either twiki.ui.Toggle.STATE_ON or twiki.ui.Toggle.STATE_OFF
	@privileged
	*/
	this._toggle = function (data, inState) {
		if (!data) return;
		var state;
		if (inState != undefined) {
			state = inState;
		} else {
			state = (data.state == twiki.ui.Toggle.STATE_OFF) ? twiki.ui.Toggle.STATE_ON : twiki.ui.Toggle.STATE_OFF;
		}
		data.state = state;
		this._update(data, true);
	}
	
	/**
	Updates the states of UI trinity 'show', 'hide' and 'content'.
	Saves new state in a cookie if one of the elements has CSS class 'toggleRememberSetting'.
	@param data : (Object) twiki.ui.ToggleData object
	@privileged
	*/
	this._update = function (data, inMaySave) {
		if (data.state == twiki.ui.Toggle.STATE_ON) {
			this._updateOn(data);
		} else {
			this._updateOff(data);
		}
		if (inMaySave && data.saveSetting) {
			this._updateSave(data, inMaySave);
		}
		if (data.clearSetting) {
			this._updateClear(data);
		}
	}
	
	this._updateOff = function (data) {
		var showControl = data[this.BUTTON_ON_NAME];
		var hideControl = data[this.BUTTON_OFF_NAME];
		twiki.CSS.removeClass(showControl, this.CSS_CLASS_HIDDEN); // show 'show'	
		twiki.CSS.addClass(hideControl, this.CSS_CLASS_HIDDEN); // hide 'hide'
	}
	this._updateOn = function (data) {
		var showControl = data[this.BUTTON_ON_NAME];
		var hideControl = data[this.BUTTON_OFF_NAME];
		twiki.CSS.addClass(showControl, this.CSS_CLASS_HIDDEN);	// hide 'show'
		twiki.CSS.removeClass(hideControl, this.CSS_CLASS_HIDDEN); // show 'hide'
	}
	this._updateSave = function (data, inMaySave) {
		twiki.Pref.setPref(twiki.ui.Toggle.COOKIE_PREFIX + data.name, data.state);
	}
	this._updateClear = function (data) {
		twiki.Pref.setPref(twiki.ui.Toggle.COOKIE_PREFIX + data.name, "");
	}
	
	/**
	Stores a twisty HTML element (either show control, hide control or content 'toggle').
	@param e : (Object) HTMLElement
	@privileged
	*/
	this._register = function (inElement) {
		if (!inElement) return;
		var name = this._getName(inElement.id);
		var data = this._storage[name];
		if (!data) {
			data = new this.DATA_CLASS();
		}
		if (twiki.CSS.hasClass(inElement, this.CSS_CLASS_REMEMBERSETTING))	data.saveSetting = true;
		if (twiki.CSS.hasClass(inElement, this.CSS_CLASS_FORGETSETTING)) 		data.clearSetting = true;
		if (twiki.CSS.hasClass(inElement, this.CSS_CLASS_STARTSHOW)) 			data.startShown = true;
		if (twiki.CSS.hasClass(inElement, this.CSS_CLASS_STARTHIDE)) 			data.startHidden = true;
		if (twiki.CSS.hasClass(inElement, this.CSS_CLASS_FIRSTSTARTSHOW)) 	data.firstStartShown = true;
		if (twiki.CSS.hasClass(inElement, this.CSS_CLASS_FIRSTSTARTHIDE)) 	data.firstStartHidden = true;
		data.name = name;
		var type = this._getType(inElement.id);

		data[type] = inElement;
		this._storage[name] = data;
		
		var re = new RegExp("(" + this.BUTTON_NAME_OPTIONS + ")", "g");
		var m = re.exec(type);
		if (m) {
			inElement.onclick = function() {
				self._toggle(data);
				return false;
			}
		}
		return data;
	}
	
	/**
	Returns true if all toggle elements are stored.
	*/
	this._allElementsInited = function (inData) {
		if (inData && inData.on && inData.off) return inData;
	}
	
	/**
	Key-value set of twiki.ui.ToggleData objects. The value is accessed by twisty id identifier name.
	@example var data = this._storage["demo"];
	@privileged
	*/
	this._storage = {};

};
twiki.ui.Toggle.__instance__ = null; //define the static property
twiki.ui.Toggle.getInstance = function () {
	if (this.__instance__ == null) {
		this.__instance__ = new twiki.ui.Toggle();
	}
	return this.__instance__;
}
	
/**
Public constants.
*/
twiki.ui.Toggle.STATE_OFF = 0;
twiki.ui.Toggle.STATE_ON = 1;
twiki.ui.Toggle.COOKIE_PREFIX = "TWiki_HTML_ToggleButton_";

/**
The cached full twiki cookie string so the data has to be read only once during init.
*/
twiki.ui.Toggle.prefList;

/**
Initializes a twisty HTML element (either show control, hide control or content 'toggle') by registering and setting the visible state.
Calls _register() and _update().
@public
@param inId : (String) id of HTMLElement
@return The stored twiki.ui.ToggleData object.
*/
twiki.ui.Toggle.prototype.init = function(inId) {

	var e = document.getElementById(inId);
	if (!e) return;

	// check if already inited
	var name = this._getName(inId);
	var data = this._storage[name];

	if (this._allElementsInited(data)) return data;

	// else register
	data = this._register(e);

	if (twiki.CSS.hasClass(e, this.CSS_CLASS_MAKEHIDDEN)) twiki.CSS.replaceClass(e, this.CSS_CLASS_MAKEHIDDEN, this.CSS_CLASS_HIDDEN);
	if (twiki.CSS.hasClass(e, this.CSS_CLASS_MAKEVISIBLE)) twiki.CSS.removeClass(e, this.CSS_CLASS_MAKEVISIBLE);
	
	if (this._allElementsInited(data)) {
		// all ui.Toggle elements present
		if (twiki.ui.Toggle.prefList == null) {
			// cache complete cookie string
			twiki.ui.Toggle.prefList = twiki.Pref.getPrefList();
		}
		var cookie = twiki.Pref.getPrefValueFromPrefList(twiki.ui.Toggle.COOKIE_PREFIX + data.name, twiki.ui.Toggle.prefList);
		if (data.firstStartHidden) data.state = twiki.ui.Toggle.STATE_OFF;
		if (data.firstStartShown) data.state = twiki.ui.Toggle.STATE_ON;
		// cookie setting may override  firstStartHidden and firstStartShown
		if (cookie && cookie == "0") data.state = twiki.ui.Toggle.STATE_OFF;
		if (cookie && cookie == "1") data.state = twiki.ui.Toggle.STATE_ON;
		// startHidden and startShown may override cookie
		if (data.startHidden) data.state = twiki.ui.Toggle.STATE_OFF;
		if (data.startShown) data.state = twiki.ui.Toggle.STATE_ON;
		this._update(data, false);
	}
	return data;	
}

/**
Sets the toggle to inState. If no state is passed, the toggle is set from its current state.
@param inId : (String) (required) id of on of the ui.Toggle elements
@param inState : (Number) (optional) the state to toggle to: either twiki.ui.Toggle.STATE_ON or twiki.ui.Toggle.STATE_OFF
*/
twiki.ui.Toggle.prototype.toggle = function(inId, inState) {
	var name = this._getName(inId);
	var data = this._storage[name];
	this._toggle(data, inState);
}

/**
Returns the ui.Toggle state.
@param inId : (String) (required) id of one of the Toggled elements
*/
twiki.ui.Toggle.prototype.getState = function(inId) {
	var name = this._getName(inId);
	var data = this._storage[name];
	return data.state;
}

/**
Toggles all elements on the page to inState.
@param inState : (Number) (required) the state to toggle to: either twiki.ui.Toggle.STATE_ON or twiki.ui.Toggle.STATE_OFF
*/
twiki.ui.Toggle.prototype.toggleAll = function(inState) {
	for (var name in this._storage) {
		var e = this._storage[name];
		e.state = inState;
		this._update(e, true);
	}
}

/**
Data container for properties of a ui.Toggle element.
*/
twiki.ui.ToggleData = function () {
	this.name;									// String
	this.state = twiki.ui.Toggle.STATE_OFF;		// Number
	this.off;									// HTMLElement
	this.on;									// HTMLElement
	this.saveSetting = false;					// Boolean; default not saved
	this.clearSetting = false;					// Boolean; default not cleared
	this.startShown;							// Boolean
	this.startHidden;							// Boolean
	this.firstStartShown;						// Boolean
	this.firstStartHidden;						// Boolean
}

/**
UI element behaviour; inits HTML element if no javascript 'trigger' tags has been inserted right after in the HTML
*/
var UIbehaviour = {	
	/**
	Show control, hide control
	*/
	'.toggleTrigger' : function(e) {
		twiki.ui.Toggle.getInstance().init(e.id);
	}
};
Behaviour.register(UIbehaviour);

/*
To compress this file you can use Dojo ShrinkSafe compressor at
http://alex.dojotoolkit.org/shrinksafe/
*/

/**
Singleton class.
Requires scripts:
- twikilib.js
- twikiUIToggle.js
- twikiFunction.js
- behaviour.js from BehaviourContrib
*/
var twiki;
if (twiki == undefined) twiki = {};

twiki.Twisty = function () {
	this.BUTTON_ON_NAME = "hide";
	this.BUTTON_OFF_NAME = "show";
	this.TOGGLE_NAME = "toggle";
	this.BUTTON_NAME_OPTIONS = this.BUTTON_ON_NAME + "|"+ this.BUTTON_OFF_NAME;
	this.ELEMENT_OPTIONS = this.BUTTON_NAME_OPTIONS + "|" + "toggle";
	this.DATA_CLASS = twiki.TwistyData;
	this.CSS_CLASS_HIDDEN = 			"twistyHidden";
	this.CSS_CLASS_MAKEHIDDEN =			"twistyMakeHidden";
	this.CSS_CLASS_MAKEVISIBLE =		"twistyMakeVisible";
	this.CSS_CLASS_REMEMBERSETTING =	"twistyRememberSetting";
	this.CSS_CLASS_FORGETSETTING =		"twistyForgetSetting";
	this.CSS_CLASS_STARTHIDE =			"twistyStartHide";
	this.CSS_CLASS_STARTSHOW =			"twistyStartShow";
	this.CSS_CLASS_FIRSTSTARTSHOW =		"twistyFirstStartShow";
	this.CSS_CLASS_FIRSTSTARTHIDE =		"twistyFirstStartHide";
	
	this._allElementsInited = function (inData) {
		if (inData && inData.hide && inData.show && inData.toggle) {
			return inData;
		}
	}
	this._updateOn = function (data) {
		var showControl = data[this.BUTTON_ON_NAME];
		var hideControl = data[this.BUTTON_OFF_NAME];
		var contentElem = data[this.TOGGLE_NAME];
		twiki.CSS.removeClass(showControl, this.CSS_CLASS_HIDDEN); // show 'show'	
		twiki.CSS.addClass(hideControl, this.CSS_CLASS_HIDDEN); // hide 'hide'
		if (contentElem) twiki.CSS.removeClass(contentElem, this.CSS_CLASS_HIDDEN); // show content
	}
	this._updateOff = function (data) {
		var showControl = data[this.BUTTON_ON_NAME];
		var hideControl = data[this.BUTTON_OFF_NAME];
		var contentElem = data[this.TOGGLE_NAME];
		twiki.CSS.addClass(showControl, this.CSS_CLASS_HIDDEN);	// hide 'show'
		twiki.CSS.removeClass(hideControl, this.CSS_CLASS_HIDDEN); // show 'hide'
		if (contentElem) twiki.CSS.addClass(contentElem, this.CSS_CLASS_HIDDEN); // hide content
	}
}
twiki.Twisty = twiki.Function.extendClass(twiki.Twisty, twiki.ui.Toggle);
twiki.Twisty.prototype.toggleAll = function (inState) {
	for (var name in this._storage) {
		var e = this._storage[name];
		e.state = inState;
		this._update(e, true);
	}
}
twiki.Twisty.__instance__ = null; //define the static property
twiki.Twisty.getInstance = function () {
	if (this.__instance__ == null) {
		this.__instance__ = new twiki.Twisty();
	}
	return this.__instance__;
}

/**
UI element behaviour; inits HTML element if no javascript 'trigger' tags has been inserted right after in the HTML
*/
var UIbehaviour = {	
	'.twistyTrigger' : function(e) {
		twiki.Twisty.getInstance().init(e.id);
	},
	'.twistyContent' : function(e) {
		twiki.Twisty.getInstance().init(e.id);
	},
	'.twistyExpandAll' : function(e) {
		e.onclick = function() {
			twiki.Twisty.getInstance().toggleAll(twiki.ui.Toggle.STATE_ON);
		}
	},
	'.twistyCollapseAll' : function(e) {
		e.onclick = function() {
			twiki.Twisty.getInstance().toggleAll(twiki.ui.Toggle.STATE_OFF);
		}
	}
};
Behaviour.register(UIbehaviour);

twiki.TwistyData = function () {
	this.toggle;	// HTMLElement (content element)
	this.hide;		// HTMLElement
	this.show;		// HTMLElement
}
twiki.TwistyData = twiki.Function.extendClass(twiki.TwistyData, twiki.ui.ToggleData);

/* maintain compatibility with previous version */
var TWiki;
if (TWiki == undefined) TWiki = {};
TWiki.TwistyPlugin = twiki.Twisty.getInstance();


