(function($){$.ajaxSettings.accepts._default="text/javascript, text/html, application/xml, text/xml, */*"})(jQuery);(function($){$.fn.reset=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};$.fn.enable=function(){return this.each(function(){this.disabled=false})};$.fn.disable=function(){return this.each(function(){this.disabled=true})}})(jQuery);(function($){$.extend({fieldEvent:function(el,obs){var field=el[0]||el,e="change";if(field.type=="radio"||field.type=="checkbox"){e="click"}else{if(obs&&(field.type=="text"||field.type=="textarea"||field.type=="password")){e="keyup"}}return e}});$.fn.extend({delayedObserver:function(delay,callback){var el=$(this);if(typeof window.delayedObserverStack=="undefined"){window.delayedObserverStack=[]}if(typeof window.delayedObserverCallback=="undefined"){window.delayedObserverCallback=function(stackPos){var observed=window.delayedObserverStack[stackPos];if(observed.timer){clearTimeout(observed.timer)}observed.timer=setTimeout(function(){observed.timer=null;observed.callback(observed.obj,observed.obj.formVal())},observed.delay*1000);observed.oldVal=observed.obj.formVal()}}window.delayedObserverStack.push({obj:el,timer:null,delay:delay,oldVal:el.formVal(),callback:callback});var stackPos=window.delayedObserverStack.length-1;if(el[0].tagName=="FORM"){$(":input",el).each(function(){var field=$(this);field.bind($.fieldEvent(field,delay),function(){var observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.oldVal){return}else{window.delayedObserverCallback(stackPos)}})})}else{el.bind($.fieldEvent(el,delay),function(){var observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.oldVal){return}else{window.delayedObserverCallback(stackPos)}})}},formVal:function(){var el=this[0];if(el.tagName=="FORM"){return this.serialize()}if(el.type=="checkbox"||el.type=="radio"){return this.filter("input:checked").val()||""}else{return this.val()}}})})(jQuery);(function($){$.fn.extend({visualEffect:function(o,options){if(options){speed=options.duration*1000}else{speed=null}e=o.replace(/\_(.)/g,function(m,l){return l.toUpperCase()});return eval("$(this)."+e+"("+speed+")")},appear:function(speed,callback){return this.fadeIn(speed,callback)},blindDown:function(speed,callback){return this.show("blind",{direction:"vertical"},speed,callback)},blindUp:function(speed,callback){return this.hide("blind",{direction:"vertical"},speed,callback)},blindRight:function(speed,callback){return this.show("blind",{direction:"horizontal"},speed,callback)},blindLeft:function(speed,callback){this.hide("blind",{direction:"horizontal"},speed,callback);return this},dropOut:function(speed,callback){return this.hide("drop",{direction:"down"},speed,callback)},dropIn:function(speed,callback){return this.show("drop",{direction:"up"},speed,callback)},fade:function(speed,callback){return this.fadeOut(speed,callback)},fadeToggle:function(speed,callback){return this.animate({opacity:"toggle"},speed,callback)},fold:function(speed,callback){return this.hide("fold",{},speed,callback)},foldOut:function(speed,callback){return this.show("fold",{},speed,callback)},grow:function(speed,callback){return this.show("scale",{},speed,callback)},highlight:function(speed,callback){return this.show("highlight",{},speed,callback)},puff:function(speed,callback){return this.hide("puff",{},speed,callback)},pulsate:function(speed,callback){return this.show("pulsate",{},speed,callback)},shake:function(speed,callback){return this.show("shake",{},speed,callback)},shrink:function(speed,callback){return this.hide("scale",{},speed,callback)},squish:function(speed,callback){return this.hide("scale",{origin:["top","left"]},speed,callback)},slideUp:function(speed,callback){return this.hide("slide",{direction:"up"},speed,callback)},slideDown:function(speed,callback){return this.show("slide",{direction:"up"},speed,callback)},switchOff:function(speed,callback){return this.hide("clip",{},speed,callback)},switchOn:function(speed,callback){return this.show("clip",{},speed,callback)}})})(jQuery);

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

var SerializableList = {
  init: function(selector, object_name){
    $(selector).parents('form').submit(function(){
      $(selector).find('.serializable_item').each(function(index){
        $('<input type="hidden" />').
          attr({
            name:   object_name + '[' + this.id + '][position]',
            value:  index
          }).
          prependTo(this);
      })
    });

    SerializableList.updateBorderClasses(selector);
  },
  moveUp: function(id){
    var $element = $(id);
    var $before = $element.prev('.serializable_item');

    $element.hide().detach().insertBefore($before).fadeIn('slow');
    
    SerializableList.updateBorderClasses($element.parent());
  },

  moveDown: function(id){
    var $element = $(id);
    var $after = $element.next('.serializable_item');

    $element.hide().detach().insertAfter($after).fadeIn('slow');
    
    SerializableList.updateBorderClasses($element.parent());
  },

  remove: function(id){
    var $list = $(id).parent();

    $(id).remove();

    SerializableList.updateBorderClasses($list);
  },

  updateBorderClasses: function(selector){
    $(selector).find('.serializable_item').removeClass('first last').
      first().addClass('first').end().
      last().addClass('last');
  }
}

$(function(){
  $.dialog.settings.container = 'body';
  
  $('form input.submit_and_continue[type=submit]').click(function(){
    $('<input type="hidden" name="continue" value="true">').appendTo($(this).parents('form'));
  });

  $('form a.remove_attachment').click(function(e){
    e.preventDefault();
    
    var $this = $(this);

    $('<input type="hidden" name="' + $this.attr('data-field') + '" value="1" />').insertBefore($this);

    $(this).hide().parent().css({opacity: 0.4});
  })

  $('#flash').click(function(){$(this).remove()}).delay(3000).fadeOut(3000);

  $('a.help').live('click', function(e){
    e.preventDefault();

    $.dialog({ajax: $(this).attr('href')});
  });

  $('#character_list #all_ids').click(function(){
    $('#character_list td :checkbox').attr({checked : $(this).attr('checked')});
  });

  $('#character_list :checkbox').click(function(){
    $('#character_list :checked').length > 0 ? $('#character_batch').show() : $('#character_batch').hide();
  })
});