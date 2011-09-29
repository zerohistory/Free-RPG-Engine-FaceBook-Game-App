(function($){$.ajaxSettings.accepts._default="text/javascript, text/html, application/xml, text/xml, */*"})(jQuery);(function($){$.fn.reset=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};$.fn.enable=function(){return this.each(function(){this.disabled=false})};$.fn.disable=function(){return this.each(function(){this.disabled=true})}})(jQuery);(function($){$.extend({fieldEvent:function(el,obs){var field=el[0]||el,e="change";if(field.type=="radio"||field.type=="checkbox"){e="click"}else{if(obs&&(field.type=="text"||field.type=="textarea"||field.type=="password")){e="keyup"}}return e}});$.fn.extend({delayedObserver:function(delay,callback){var el=$(this);if(typeof window.delayedObserverStack=="undefined"){window.delayedObserverStack=[]}if(typeof window.delayedObserverCallback=="undefined"){window.delayedObserverCallback=function(stackPos){var observed=window.delayedObserverStack[stackPos];if(observed.timer){clearTimeout(observed.timer)}observed.timer=setTimeout(function(){observed.timer=null;observed.callback(observed.obj,observed.obj.formVal())},observed.delay*1000);observed.oldVal=observed.obj.formVal()}}window.delayedObserverStack.push({obj:el,timer:null,delay:delay,oldVal:el.formVal(),callback:callback});var stackPos=window.delayedObserverStack.length-1;if(el[0].tagName=="FORM"){$(":input",el).each(function(){var field=$(this);field.bind($.fieldEvent(field,delay),function(){var observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.oldVal){return}else{window.delayedObserverCallback(stackPos)}})})}else{el.bind($.fieldEvent(el,delay),function(){var observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.oldVal){return}else{window.delayedObserverCallback(stackPos)}})}},formVal:function(){var el=this[0];if(el.tagName=="FORM"){return this.serialize()}if(el.type=="checkbox"||el.type=="radio"){return this.filter("input:checked").val()||""}else{return this.val()}}})})(jQuery);(function($){$.fn.extend({visualEffect:function(o,options){if(options){speed=options.duration*1000}else{speed=null}e=o.replace(/\_(.)/g,function(m,l){return l.toUpperCase()});return eval("$(this)."+e+"("+speed+")")},appear:function(speed,callback){return this.fadeIn(speed,callback)},blindDown:function(speed,callback){return this.show("blind",{direction:"vertical"},speed,callback)},blindUp:function(speed,callback){return this.hide("blind",{direction:"vertical"},speed,callback)},blindRight:function(speed,callback){return this.show("blind",{direction:"horizontal"},speed,callback)},blindLeft:function(speed,callback){this.hide("blind",{direction:"horizontal"},speed,callback);return this},dropOut:function(speed,callback){return this.hide("drop",{direction:"down"},speed,callback)},dropIn:function(speed,callback){return this.show("drop",{direction:"up"},speed,callback)},fade:function(speed,callback){return this.fadeOut(speed,callback)},fadeToggle:function(speed,callback){return this.animate({opacity:"toggle"},speed,callback)},fold:function(speed,callback){return this.hide("fold",{},speed,callback)},foldOut:function(speed,callback){return this.show("fold",{},speed,callback)},grow:function(speed,callback){return this.show("scale",{},speed,callback)},highlight:function(speed,callback){return this.show("highlight",{},speed,callback)},puff:function(speed,callback){return this.hide("puff",{},speed,callback)},pulsate:function(speed,callback){return this.show("pulsate",{},speed,callback)},shake:function(speed,callback){return this.show("shake",{},speed,callback)},shrink:function(speed,callback){return this.hide("scale",{},speed,callback)},squish:function(speed,callback){return this.hide("scale",{origin:["top","left"]},speed,callback)},slideUp:function(speed,callback){return this.hide("slide",{direction:"up"},speed,callback)},slideDown:function(speed,callback){return this.show("slide",{direction:"up"},speed,callback)},switchOff:function(speed,callback){return this.hide("clip",{},speed,callback)},switchOn:function(speed,callback){return this.show("clip",{},speed,callback)}})})(jQuery);

;(function($){

  $.fn.tabs = function(){
    //Loop Arguments matching options
    var s = {};
    for(var i=0; i<arguments.length; ++i) {
      var a=arguments[i];
      switch(a.constructor){
        case Object: $.extend(s,a); break;
        case Boolean: s.change = a; break;
        case Number: s.start = a; break;
        case Function: s.click = a; break;
        case String:
          if(a.charAt(0)=='.') s.selected = a;
          else if(a.charAt(0)=='!') s.event = a;
          else s.start = a;
        break;
      }
    }

    if(typeof s['return'] == "function") //backwards compatible
      s.change = s['return'];

    return this.each(function(){ $.tabs(this,s); }); //Chainable
  }

  $.tabs = function(tabs,options) {
    //Settings
    var meta = ($.metadata)?$(tabs).metadata():{};
    var s = $.extend({},$.tabs.settings,meta,options);

    //Play nice
    if(s.selected.charAt(0)=='.') s.selected=s.selected.substr(1);
    if(s.event.charAt(0)=='!') s.event=s.event.substr(1);
    if(s.start==null) s.start=-1; //no tab selected

    //Setup Tabs
    var showId = function(){
      if($(this).is('.'+s.selected))
        return s.change; //return if already selected
      var id = "#"+this.href.split('#')[1];
      var aList = []; //save tabs
      var idList = []; //save possible elements
      $("a",tabs).each(function(){
        if(this.href.match(/#/)) {
          aList.push(this);
          idList.push("#"+this.href.split('#')[1]);
        }
      });
      if(s.click && !s.click.apply(this,[id,idList,tabs,s])) return s.change;
      //Clear tabs, and hide all
      for(i in aList) $(aList[i]).removeClass(s.selected);
      for(i in idList) $(idList[i]).hide();
      //Select clicked tab and show content
      $(this).addClass(s.selected);
      $(id).show();
      return s.change; //Option for changing url
    }

    //Bind tabs
    var list = $("a[href*='#']",tabs).unbind(s.event,showId).bind(s.event,showId);
    list.each(function(){ $("#"+this.href.split('#')[1]).hide(); });

    //Select default tab
    var test=false;
    if((test=list.filter('.'+s.selected)).length); //Select tab with selected class
    else if(typeof s.start == "number" &&(test=list.eq(s.start)).length); //Select num tab
    else if(typeof s.start == "string" //Select tab linking to id
         &&(test=list.filter("[href*='#"+s.start+"']")).length);
    if(test) { test.removeClass(s.selected); test.trigger(s.event); } //Select tab

    return s; //return current settings (be creative)
  }

  //Defaults
  $.tabs.settings = {
    start:0,
    change:false,
    click:null,
    selected:".selected",
    event:"!click"
  };

  //Version
  $.tabs.version = "2.2";
})(jQuery);

;(function($) {
  $.dialog = function(data, options) {
    $.dialog.loading()

    if (data.ajax) filldialogFromAjax(data.ajax, options)
    else if (data.image) filldialogFromImage(data.image, options)
    else if (data.div) filldialogFromHref(data.div, options)
    else if ($.isFunction(data)) data.call($)
    else $.dialog.reveal(data, options)
  }

  /*
   * Public, $.dialog methods
   */

  $.extend($.dialog, {
    settings: {
      container    : '#content',
      overlay      : true,
      imageTypes   : [ 'png', 'jpg', 'jpeg', 'gif' ],
      dialogHtml  : '\
    <div id="dialog" style="display:none;"> \
      <div class="popup"> \
        <div class="body"> \
          <div class="header"> \
            <a href="#" class="close"></a> \
          </div> \
          <div class="content clearfix"> \
          </div> \
        </div> \
      </div> \
    </div>'
    },

    loading: function() {
      init()
      if ($('#dialog .loading').length == 1) return true
      showOverlay()

      $('#dialog .content').empty()
      $('#dialog .body').children().hide().end().
        append('<div class="loading"></div>')

      $('#dialog').css({
        top:	getPageScroll()[1] + (getPageHeight() / 10),
        left:	$(window).width() / 2 - 205 
      })//.show()

      $(document).bind('keydown.dialog', function(e) {
        if (e.keyCode == 27) $.dialog.close()
        return true
      })
      $(document).trigger('loading.dialog')
    },

    reveal: function(data, options) {
      if(typeof options == "undefined"){ var options = {}; }
      
      $(document).trigger('beforeReveal.dialog');
      if(options.beforeReveal) options.beforeReveal.call(this);

      if (options.klass) $('#dialog .content').addClass(options.klass);
      $('#dialog .content').append(data)
      $('#dialog .loading').remove();
      $('#dialog').show();
      $('#dialog .body').children().fadeIn('normal')
      $('#dialog').css('left', $(window).width() / 2 - ($('#dialog .body').width() / 2));

      $(document).trigger('reveal.dialog');
      if (options.reveal) options.reveal.call(this);
      
      $(document).trigger('afterReveal.dialog');
      if (options.afterReveal) options.afterReveal.call(this);
    },

    close: function() {
      $(document).trigger('close.dialog')
      return false
    }
  })

  /*
   * Public, $.fn methods
   */

  $.fn.dialog = function(settings) {
    init(settings)

    function clickHandler() {
      $.dialog.loading(true)

      var options = {}
      options.klass = this.rel.match(/dialog\[?\.(\w+)\]?/)

      filldialogFromHref(this.href, options)
      return false
    }

    return this.bind('click.dialog', clickHandler)
  }

  /*
   * Private methods
   */

  // called one time to setup dialog on this page
  function init(settings) {
    if ($.dialog.settings.inited) return true
    else $.dialog.settings.inited = true

    $(document).trigger('init.dialog')

    var imageTypes = $.dialog.settings.imageTypes.join('|')
    $.dialog.settings.imageTypesRegexp = new RegExp('\.(' + imageTypes + ')$', 'i')

    if (settings) $.extend($.dialog.settings, settings)
    $($.dialog.settings.container).append($.dialog.settings.dialogHtml)

    $('#dialog .close').click($.dialog.close);
  }
  
  // getPageScroll() by quirksmode.com
  function getPageScroll() {
    var xScroll, yScroll;
    if (self.pageYOffset) {
      yScroll = self.pageYOffset;
      xScroll = self.pageXOffset;
    } else if (document.documentElement && document.documentElement.scrollTop) {	 // Explorer 6 Strict
      yScroll = document.documentElement.scrollTop;
      xScroll = document.documentElement.scrollLeft;
    } else if (document.body) {// all other Explorers
      yScroll = document.body.scrollTop;
      xScroll = document.body.scrollLeft;	
    }
    return new Array(xScroll,yScroll) 
  }

  // Adapted from getPageSize() by quirksmode.com
  function getPageHeight() {
    var windowHeight
    if (self.innerHeight) {	// all except Explorer
      windowHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
      windowHeight = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
      windowHeight = document.body.clientHeight;
    }	
    return windowHeight
  }


  // Figures out what you want to display and displays it
  // formats are:
  //     div: #id
  //   image: blah.extension
  //    ajax: anything else
  function filldialogFromHref(href, options) {
    // div
    if (href.match(/#/)) {
      var url    = window.location.href.split('#')[0]
      var target = href.replace(url,'')
      $.dialog.reveal($(target).show().replaceWith("<div id='dialog_moved'></div>"), options)

    // image
    } else if (href.match($.dialog.settings.imageTypesRegexp)) {
      filldialogFromImage(href, options)
    // ajax
    } else {
      filldialogFromAjax(href, options)
    }
  }

  function filldialogFromImage(href, options) {
    var image = new Image()
    image.onload = function() {
      $.dialog.reveal('<div class="image"><img src="' + image.src + '" /></div>', options)
    }
    image.src = href
  }

  function filldialogFromAjax(href, options) {
    $.get(href, function(data) { $.dialog.reveal(data, options) })
  }

  function skipOverlay() {
    return $.dialog.settings.overlay == false
  }

  function showOverlay() {
    if (skipOverlay()) return

    if ($('#dialog_overlay').length == 0)
      $("body").append('<div id="dialog_overlay" class="dialog_hide"></div>')

    $('#dialog_overlay').hide().addClass("dialog_overlayBG")
      .click(function() { $(document).trigger('close.dialog') })
      .fadeTo(400, 0.5)
    return false
  }

  function hideOverlay(callback){
    if (skipOverlay()) return false;

    $('#dialog_overlay').fadeOut(400, function(){
      $("#dialog_overlay").removeClass("dialog_overlayBG");
      $("#dialog_overlay").addClass("dialog_hide");
      $("#dialog_overlay").remove();

      callback();
    });
    
    return false;
  }

  /*
   * Bindings
   */

  $(document).bind('close.dialog', function() {
    $(document).unbind('keydown.dialog');

    $('#dialog').fadeOut(function() {
      if ($('#dialog_moved').length == 0) $('#dialog .content').removeClass().addClass('content clearfix')
      else $('#dialog_moved').replaceWith($('#dialog .content').children().hide())
      hideOverlay(function(){
        $('#dialog .loading').remove();

        $(document).trigger('dialog.close_complete');
      })
    });
  })

})(jQuery);

;(function($){
  $.scrollTo = function(target){
    var $target = $(target).eq(0);
    var $offset = $target.offset();
    
    var styles = {
      width: "1px",
      height: "1px",
      border: "0px",
      backgroundColor: "transparent",
      "float": "left",
      position: 'absolute',
      left: $offset.left
    };
    
    var $top = $('#_scroller_top');
    var $bottom = $('#_scroller_bottom');
    
    if ($top.length == 0) {
      var $top = $('<input type="text" id="_scroller_top" />').css(styles).appendTo('body');
    }
    
    if ($bottom.length == 0) {
      var $bottom = $('<input type="text" id="_scroller_bottom" />').css(styles).appendTo('body');
    }
    
    $bottom.
      css({ visibility: 'visible', top: $offset.top + $target.outerHeight() }).
      delay(100).
      focus().
      delay(100).
      css('visibility', 'hidden').
      blur();

    $top.
      css({ visibility: 'visible', top: $offset.top }).
      delay(100).
      focus().
      delay(100).
      css('visibility', 'hidden').
      blur();
  }
})(jQuery);

/*
 * jQuery Tooltip plugin 1.3
 *
 * http://bassistance.de/jquery-plugins/jquery-plugin-tooltip/
 * http://docs.jquery.com/Plugins/Tooltip
 *
 * Copyright (c) 2006 - 2008 Jörn Zaefferer
 *
 * $Id: jquery.tooltip.js 5741 2008-06-21 15:22:16Z joern.zaefferer $
 * 
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
;eval(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}(';(8($){j e={},9,m,B,A=$.2u.2g&&/29\\s(5\\.5|6\\.)/.1M(1H.2t),M=12;$.k={w:12,1h:{Z:25,r:12,1d:19,X:"",G:15,E:15,16:"k"},2s:8(){$.k.w=!$.k.w}};$.N.1v({k:8(a){a=$.1v({},$.k.1h,a);1q(a);g 2.F(8(){$.1j(2,"k",a);2.11=e.3.n("1g");2.13=2.m;$(2).24("m");2.22=""}).21(1e).1U(q).1S(q)},H:A?8(){g 2.F(8(){j b=$(2).n(\'Y\');4(b.1J(/^o\\(["\']?(.*\\.1I)["\']?\\)$/i)){b=1F.$1;$(2).n({\'Y\':\'1D\',\'1B\':"2r:2q.2m.2l(2j=19, 2i=2h, 1p=\'"+b+"\')"}).F(8(){j a=$(2).n(\'1o\');4(a!=\'2f\'&&a!=\'1u\')$(2).n(\'1o\',\'1u\')})}})}:8(){g 2},1l:A?8(){g 2.F(8(){$(2).n({\'1B\':\'\',Y:\'\'})})}:8(){g 2},1x:8(){g 2.F(8(){$(2)[$(2).D()?"l":"q"]()})},o:8(){g 2.1k(\'28\')||2.1k(\'1p\')}});8 1q(a){4(e.3)g;e.3=$(\'<t 16="\'+a.16+\'"><10></10><t 1i="f"></t><t 1i="o"></t></t>\').27(K.f).q();4($.N.L)e.3.L();e.m=$(\'10\',e.3);e.f=$(\'t.f\',e.3);e.o=$(\'t.o\',e.3)}8 7(a){g $.1j(a,"k")}8 1f(a){4(7(2).Z)B=26(l,7(2).Z);p l();M=!!7(2).M;$(K.f).23(\'W\',u);u(a)}8 1e(){4($.k.w||2==9||(!2.13&&!7(2).U))g;9=2;m=2.13;4(7(2).U){e.m.q();j a=7(2).U.1Z(2);4(a.1Y||a.1V){e.f.1c().T(a)}p{e.f.D(a)}e.f.l()}p 4(7(2).18){j b=m.1T(7(2).18);e.m.D(b.1R()).l();e.f.1c();1Q(j i=0,R;(R=b[i]);i++){4(i>0)e.f.T("<1P/>");e.f.T(R)}e.f.1x()}p{e.m.D(m).l();e.f.q()}4(7(2).1d&&$(2).o())e.o.D($(2).o().1O(\'1N://\',\'\')).l();p e.o.q();e.3.P(7(2).X);4(7(2).H)e.3.H();1f.1L(2,1K)}8 l(){B=S;4((!A||!$.N.L)&&7(9).r){4(e.3.I(":17"))e.3.Q().l().O(7(9).r,9.11);p e.3.I(\':1a\')?e.3.O(7(9).r,9.11):e.3.1G(7(9).r)}p{e.3.l()}u()}8 u(c){4($.k.w)g;4(c&&c.1W.1X=="1E"){g}4(!M&&e.3.I(":1a")){$(K.f).1b(\'W\',u)}4(9==S){$(K.f).1b(\'W\',u);g}e.3.V("z-14").V("z-1A");j b=e.3[0].1z;j a=e.3[0].1y;4(c){b=c.2o+7(9).E;a=c.2n+7(9).G;j d=\'1w\';4(7(9).2k){d=$(C).1r()-b;b=\'1w\'}e.3.n({E:b,14:d,G:a})}j v=z(),h=e.3[0];4(v.x+v.1s<h.1z+h.1n){b-=h.1n+20+7(9).E;e.3.n({E:b+\'1C\'}).P("z-14")}4(v.y+v.1t<h.1y+h.1m){a-=h.1m+20+7(9).G;e.3.n({G:a+\'1C\'}).P("z-1A")}}8 z(){g{x:$(C).2e(),y:$(C).2d(),1s:$(C).1r(),1t:$(C).2p()}}8 q(a){4($.k.w)g;4(B)2c(B);9=S;j b=7(2);8 J(){e.3.V(b.X).q().n("1g","")}4((!A||!$.N.L)&&b.r){4(e.3.I(\':17\'))e.3.Q().O(b.r,0,J);p e.3.Q().2b(b.r,J)}p J();4(7(2).H)e.3.1l()}})(2a);',62,155,'||this|parent|if|||settings|function|current||||||body|return|||var|tooltip|show|title|css|url|else|hide|fade||div|update||blocked|||viewport|IE|tID|window|html|left|each|top|fixPNG|is|complete|document|bgiframe|track|fn|fadeTo|addClass|stop|part|null|append|bodyHandler|removeClass|mousemove|extraClass|backgroundImage|delay|h3|tOpacity|false|tooltipText|right||id|animated|showBody|true|visible|unbind|empty|showURL|save|handle|opacity|defaults|class|data|attr|unfixPNG|offsetHeight|offsetWidth|position|src|createHelper|width|cx|cy|relative|extend|auto|hideWhenEmpty|offsetTop|offsetLeft|bottom|filter|px|none|OPTION|RegExp|fadeIn|navigator|png|match|arguments|apply|test|http|replace|br|for|shift|click|split|mouseout|jquery|target|tagName|nodeType|call||mouseover|alt|bind|removeAttr|200|setTimeout|appendTo|href|MSIE|jQuery|fadeOut|clearTimeout|scrollTop|scrollLeft|absolute|msie|crop|sizingMethod|enabled|positionLeft|AlphaImageLoader|Microsoft|pageY|pageX|height|DXImageTransform|progid|block|userAgent|browser'.split('|'),0,{}));

/*!
 * jQuery jCarousellite Plugin v1.3.1
 *
 * Date: Mon Dec 6 19:36:31 2010 -0500
 * Requires: jQuery v1.4+
 *
 * Copyright 2007 Ganeshji Marwaha (gmarwaha.com)
 * Modifications/enhancements by Karl Swedberg
 * Dual licensed under the MIT and GPL licenses (just like jQuery):
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * jQuery plugin to navigate images/any content in a carousel style widget.
 *
*/
(function(e){function p(r,a){return parseInt(e.css(r[0],a),10)||0}e.jCarouselLite={version:"1.3.1"};e.fn.jCarouselLite=function(r){var a=e.extend({},e.fn.jCarouselLite.defaults,r);return this.each(function(){function n(c){if(!s){a.beforeStart&&a.beforeStart.call(this,f.slice(g).slice(0,b));if(a.circular)if(c<=k-b-1){j.css(q,-((i-b*2)*l)+"px");g=c==k-b-1?i-b*2-1:i-b*2-a.scroll}else if(c>=i-b+1){j.css(q,-(b*l)+"px");g=c==i-b+1?b+1:b+a.scroll}else g=c;else{a.$btnPrev.toggleClass(a.btnDisabledClass,a.btnPrev&&
c<=0);a.$btnNext.toggleClass(a.btnDisabledClass,a.btnNext&&c>i-b);g=c<0?0:c>i-b?i-b:c}s=true;v[q]=-(g*l);j.animate(v,a.speed,a.easing,function(){a.afterEnd&&a.afterEnd.call(this,f.slice(g).slice(0,b));s=false})}return false}var s=false,q=a.vertical?"top":"left",v={},w=a.vertical?"height":"width",m=this,d=e(this),j=d.find("ul").eq(0),o=j.children("li"),t=o.length,b=a.visible,k=Math.min(a.start,t-1);if(a.circular){j.prepend(o.slice(t-b-1+1).clone(true)).append(o.slice(0,b).clone(true));k+=b}var f=j.children("li"),
i=f.length,g=k;d.css("visibility","visible");f.css({overflow:a.vertical?"hidden":"visible","float":a.vertical?"none":"left"});j.css({margin:"0",padding:"0",position:"relative",listStyleType:"none",zIndex:1});d.css({overflow:"hidden",position:"relative",zIndex:2,left:"0px"});var l=a.vertical?f[0].offsetHeight+p(f,"marginTop")+p(f,"marginBottom"):f[0].offsetWidth+p(f,"marginLeft")+p(f,"marginRight");o=l*i;var z=l*b;f.css({width:f.width(),height:f.height()});j.css(w,o+"px").css(q,-(g*l));d.css(w,z+"px");
e.each(["btnPrev","btnNext"],function(c,h){if(a[h]){a["$"+h]=e.isFunction(a[h])?a[h].call(d[0]):e(a[h]);a["$"+h].bind("click.jc",function(){return n(c==0?g-a.scroll:g+a.scroll)})}});if(!a.circular){a.btnPrev&&k==0&&a.$btnPrev.addClass(a.btnDisabledClass);a.btnNext&&k+a.visible>=i&&a.$btnNext.addClass(a.btnDisabledClass)}a.btnGo&&e.each(a.btnGo,function(c,h){e(h).bind("click.jc",function(){return n(a.circular?a.visible+c:c)})});a.mouseWheel&&d.mousewheel&&d.bind("mousewheel.jc",function(c,h){return h>
0?n(g-a.scroll):n(g+a.scroll)});if(a.auto){var x=0,y=a.autoStop&&(a.circular?a.autoStop:Math.min(t,a.autoStop)),u=function(){m.setAutoAdvance=setTimeout(function(){if(!y||y>x){n(g+a.scroll);x++;u()}},a.timeout+a.speed)};u();d.bind("pauseCarousel.jc",function(){clearTimeout(m.setAutoAdvance);d.data("pausedjc",true)}).bind("resumeCarousel.jc",function(){u();d.removeData("pausedjc")});a.pause&&d.bind("mouseenter.jc",function(){d.trigger("pauseCarousel")}).bind("mouseleave.jc",function(){d.trigger("resumeCarousel")})}d.bind("endCarousel.jc",
function(){m.setAutoAdvance&&clearTimeout(m.setAutoAdvance);a.btnPrev&&a[$btnPrev].addClass(a.btnDisabledClass).unbind(".jc");a.btnNext&&a[$btnNext].addClass(a.btnDisabledClass).unbind(".jc");a.btnGo&&e.each(a.btnGo,function(c,h){e(h).unbind(".jc")});if(m.setAutoAdvance)m.setAutoAdvance=null;d.removeData("pausejc");d.unbind(".jc")})})};e.fn.jCarouselLite.defaults={btnPrev:null,btnNext:null,btnDisabledClass:"disabled",btnGo:null,mouseWheel:false,speed:200,easing:null,auto:false,autoStop:false,timeout:4E3,
pause:true,vertical:false,circular:true,visible:3,start:0,scroll:1,beforeStart:null,afterEnd:null}})(jQuery);


var Timer = {
  timers: {},

  format: function(value){
    var days    = Math.floor(value / 86400);
    var hours   = Math.floor((value - days * 86400) / 3600);
    var minutes = Math.floor((value - days * 86400 - hours * 3600) / 60);
    var seconds = value - days * 86400 - hours * 3600 - minutes * 60;

    var result = '';

    if(days > 1){
      result = result + days + ' days, ';
    } else if(days > 0) {
      result = result + days + ' day, ';
    }

    if(hours > 0){
      result = result + hours + ":";
    }

    if(minutes < 10){
      result = result + "0" + minutes;
    }else{
      result = result + minutes;
    }

    if(seconds < 10){
      result = result + ":0" + seconds;
    }else{
      result = result + ":" + seconds;
    }

    return(result);
  },

  update: function(id){
    var element = $(id);

    if(element.length === 0){
      this.timers[id].running = false;

      return;
    }

    if(this.timers[id].value > 0){
      element.text(Timer.format(this.timers[id].value));

      this.timers[id].value = this.timers[id].value - 1;

      this.rerun(id);
    } else {
      element.text('');

      this.timers[id].running = false;

      if(this.timers[id].callback){
        this.timers[id].callback(element);
      }
    }
  },

  rerun: function(id){
    setTimeout(function() { Timer.update(id); }, 1000);
    
    this.timers[id].running = true;
  },

  start: function(id, value, callback){
    if(value == 0){ return; }

    if(this.timers[id]){
      this.timers[id].value = value;
      this.timers[id].callback = callback;
    } else {
      this.timers[id] = {value: value, running: false, callback: callback};
    }

    if(!this.timers[id].running){
      this.rerun(id);
    }
  }
};


var Spinner = {
  x: -1,
  y: -1,
  setup: function(){
    $('#spinner').ajaxStart(function(){
        Spinner.show();
      }).ajaxStop(function(){
        Spinner.hide();
      });
      
    $('body').mousemove(this.alignToMouse);
  },
  show: function(speed){
    Spinner.moveToPosition();

    $('#spinner').fadeIn(speed);
  },
  hide: function(speed){
    $('#spinner').fadeOut(speed);
  },
  blink: function(speed, delay){
    Spinner.moveToPosition();

    $('#spinner').fadeIn(speed).delay(delay).fadeOut(speed);
  },
  storePosition: function(x, y){
    Spinner.x = x;
    Spinner.y = y;
  },
  moveToPosition: function(){
    if(this.x > -1 && this.y > -1){
      $('#spinner').css({
        top: this.y - $('#spinner').height() / 2
      });
    }
  },
  alignToMouse: function(e){
    Spinner.storePosition(e.pageX, e.pageY);
  },
  alignTo: function(selector){
    var position = $(selector).offset();

    Spinner.storePosition(position.left, position.top);
  }
};


function if_fb_initialized(callback){
  if(typeof(FB) != 'undefined'){ 
    callback.call();
  } else { 
    alert('The page failed to initialize properly. Please reload it and try again.'); 
  }
}

function bookmark(){
  if(typeof(FB) != 'undefined'){
    FB.ui({method : 'bookmark.add'});
    $(document).trigger('facebook.dialog');
  }

  $.scrollTo('body');
}

function show_result(){
  $('#result').show();

  $.scrollTo('#result');
}

function signedUrl(url){
  var new_url = url + (url.indexOf('?') == -1 ? '?' : '&') + 'stored_signed_request=' + signed_request;

  return new_url;
}

function redirectTo(url){
  document.location = signedUrl(url);
}

function updateCanvasSize() {
  FB.Canvas.setSize({
    height: $('body').height() + 100 // Additional number compensates admin menu margin that is not included into the body height
  });
}


var CollectionList = {
  setup: function(){
    CollectionList.blurItems($('#item_collection_list').find('.info .item:not(.present)'));
  },

  blurItems: function(collection){
    collection.removeClass('present').children().css({opacity: 0.4, filter: ''});
  }
};


var CharacterForm = {
  setup: function(selector){
    var form = $(selector);

    form.find('#character_types .character_type').click(function(){
      CharacterForm.set_character_type(this);
    }).tooltip({
      id: 'tooltip',
      delay: 0,
      bodyHandler: function(){
        return $('#description_character_type_' + $(this).attr('value')).html();
      }
    });

    form.find('input[type=submit]').click(function(e){
      e.preventDefault();

      form.submit();

      Spinner.show(200);
    });

    form.find('a.skip').click(function(e){
      var link = e.target;

      e.preventDefault();

      redirectTo($(link).attr('href'));

      Spinner.show(200);
    });
  },

  set_character_type: function(selector){
    var $this = $(selector);

    $this.addClass('selected').siblings('.character_type').removeClass('selected');

    $('#character_character_type_id').val(
      $this.attr('value')
    );
  }
};


var Character = {
  update: function(a){
    var c = a.character;

    if(c === 'undefined'){ return; }
    
    $("#co .basic_money .value").text(c.formatted_basic_money);
    $("#main_menu .premium .value").text(c.formatted_vip_money);
    $("#bottom_nav .premium .value").text("(" + c.formatted_vip_money + ")");
    $("#co .experience .value").text(c.experience + "/" + c.next_level_experience);

    $("#co .experience .percentage_bar .complete").css({width: c.level_progress_percentage + "%"})

    $("#co .level .value").text(c.level);
    $("#co .health .value").text(c.hp + "/" + c.health_points);
    $("#co .energy .value").text(c.ep + "/" + c.energy_points);
    $("#co .stamina .value").text(c.sp + "/" + c.stamina_points);
    $("#co .defence .value").text(c.defence)
    $("#co .attack .value").text(c.attack)

    $("#co .energy .percentage_bar .complete").width((c.ep/c.energy_points)*100)
    $("#co .health .percentage_bar .complete").width((c.hp/c.health_points)*100)
    $("#co .stamina .percentage_bar .complete").width((c.sp/c.stamina_points)*100)

    Timer.start('#co .health .timer', c.time_to_hp_restore, this.update_from_remote);
    Timer.start('#co .energy .timer', c.time_to_ep_restore, this.update_from_remote);
    Timer.start('#co .stamina .timer', c.time_to_sp_restore, this.update_from_remote);

    $('#co .timer').unbind('click').click(Character.update_from_remote);

    if (c.points > 0) {
      $("#co .level .upgrade").show();
    } else {
      $("#co .level .upgrade").hide();
    }
    
    if (c.hp == c.health_points) {
      $('#co .health .hospital').hide();
    } else {
      $('#co .health .hospital').show();
    }
  },

  update_from_remote: function(){
    $.getJSON('/character_status/?rand=' + Math.random(), function(data){
      Character.update(data);
    });
  },

  initFightAttributes: function(){
    $('#fight_attributes .inventories .inventory').tooltip({
      delay: 0,
      track: true,
      showURL: false,
      bodyHandler: function(){
        return $('#' + $(this).attr('tooltip')).clone();
      }
    });
  }
};


var PropertyList = {
  enableCollection: function(timer_element){
    $(timer_element).parent('.timer').hide();
    $(timer_element).parents('.property_type').find('.button.collect').show();

    var collectables = $('#property_collect_all').find('.value');

    collectables.text(parseInt(collectables.text(), 10) + 1);
    collectables.parent().show();
  }
};


var BossFight = {
  initBlock: function(){
    $(document).bind({
      'boss.won': BossFight.onWin,
      'boss.lost': BossFight.onLose,
      'boss.expired': BossFight.onExpire
    });
  },
  onWin: function(event, fight_id){
    BossFight.hide_reminder(fight_id);
  },
  
  onLose: function(event, fight_id){
    BossFight.hide_reminder(fight_id);
  },

  onExpire: function(event, fight_id){
    BossFight.hide_reminder(fight_id);
  },

  hide_reminder: function(fight_id){
    $('#boss_fight_' + fight_id).hide();

    if($('#boss_fight_block .boss_fight:visible').length == 0){
      $('#boss_fight_block').hide();
    }
  }
};


var AssignmentForm = {
  setup: function(){
    $('#new_assignment .tabs').tabs();

    $('#new_assignment .relations .relation').click(AssignmentForm.select_relation);
  },

  select_relation: function(){
    $('#new_assignment .relations .relation').removeClass('selected');

    var $this = $(this);

    $this.addClass('selected');

    $('#assignment_relation_id').val($this.attr('value'));
  }
};


var GiftForm = {
  setup: function(){
    $('#allies .relations .relation').click(GiftForm.select_relation);
  },

  select_relation: function(){
    $('#allies .relations .relation').removeClass('selected');

    var $this = $(this);

    $this.addClass('selected');

    $('#relation_id').val($this.attr('value'));
  }
}

var Equipment = {
  setup: function(){
    $('#equippables .inventory, #placements .inventory').tooltip({
      delay: 0,
      track: true,
      bodyHandler: function(){
        return $(this).find('.tooltip_content').clone();
      }
    });
  }
};


var Mission = {
  requirementCallback: function(){},
  onRequirementSatisfy: function(){
    $(document).unbind('requirement.satisfy', Mission.onRequirementSatisfy);

    Mission.requirementCallback();
  },
  onItemPurchase: function(){
    $(document).unbind('item.purchase', Mission.onItemPurchase);
    $(document).trigger('requirement.satisfy');
  }
};


(function($){
  $.fn.missionGroups = function(current_group, show_limit){
    var $container = $(this);
    var $items = $container.find('li');
    var $current = $(current_group);

    $container.find('.container').jCarouselLite({
      btnNext:  $container.find('.next'),
      btnPrev:  $container.find('.previous'),
      visible:  show_limit,
      start:    Math.floor($items.index($current) / show_limit) * show_limit,
      circular: false
    });

    $current.addClass('current');

    $items.click(function(e){
      e.preventDefault();
      e.stopPropagation();

      redirectTo($(this).find('a').attr('href'));
    });
  };
  
  $.fn.giftButton = function(options){
    $(this).live('click', function(e){
      e.preventDefault();
      
      var $this = $(this);

      if_fb_initialized(function(){
        FB.ui({
          method: 'apprequests',
          title: options.request_title,
          message: $this.attr('data-message'),
          data: {
            type: 'gift',
            item_id: $this.attr('data-item-id')
          }
        }, function(response){
          if(typeof(response) != 'undefined' && response !== 'null'){
            $this.trigger('request_sent');
            
            $('#ajax').load(options.request_callback_url, {ids: response.request_ids, item_id: $this.attr('data-item-id')});
          }
        });

        $(document).trigger('facebook.dialog');
      });
    });
  };
  
  $.fn.giftForm = function(options){
    var $gifts = $(this).find('.gifts .gift');

    $gifts.css({
      height: $gifts.map(function(e){
          return $(this).outerHeight();
        }).toArray().sort().reverse()[0]
    });

    $gifts.find('.send').giftButton(options);
    
    return $(this);
  };
})(jQuery);


$(function(){
  if(document.cookie.indexOf('access_token') == -1){
    $('a').live('click', function(){
      var href = $(this).attr('href');
      
      if(typeof(href) != 'undefined'){
        $(this).attr('href', signedUrl(href));
      }
    });

    $('form').live('submit', function(){
      $(this).append('<input type="hidden" name="stored_signed_request" value="' + signed_request + '">');
    });

    $.ajaxSetup({
      beforeSend : function(request){
        request.setRequestHeader('signed-request', signed_request);
      }
    });
  }
  
  $('a[data-click-once=true]').live('click', function(){
    $(this).attr('onclick', null).css({opacity: 0.3, filter: '', cursor: 'wait'}).blur();
  });

  $(document).bind('facebook.ready', function(){
    window.setInterval(updateCanvasSize, 100);
  });

  $(document).bind('result.received', function(){
    $(document).trigger('remote_content.received');
    $(document).trigger('result.available');
  });

  $(document).bind('result.available', show_result);

  $(document).bind('remote_content.received', function(){
    if(typeof(FB) != 'undefined'){
      FB.XFBML.parse();
    }
  });

  $(document).bind('loading.dialog', function(){
    $.scrollTo('#dialog .popup');
  });
  
  $(document).bind('afterReveal.dialog', function(){
    $.scrollTo('#dialog .popup .body');
  });

  $(document).bind('facebook.dialog', function(){
    $(document).delay(100).queue(function(){  
      var dialog = $('.fb_dialog').filter(function(){ 
        return $(this).offset().top > 0;
      }).first();

      $.scrollTo(dialog);
      
      Spinner.alignTo(dialog);
      Spinner.blink();
    });
  });

  Spinner.setup();

  $('a.help').live('click', function(e){
    e.preventDefault();
    
    $.dialog({ajax: $(this).attr('href')});
  });

  $(document).bind('dialog.close_complete application.ready', function(){
    $(document).dequeue('dialog');
  });
});

