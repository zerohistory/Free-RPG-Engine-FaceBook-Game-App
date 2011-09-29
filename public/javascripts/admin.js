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