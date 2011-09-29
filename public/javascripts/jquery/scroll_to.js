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