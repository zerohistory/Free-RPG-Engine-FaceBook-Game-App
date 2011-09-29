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