module ItemsHelper
  def item_image(item, format, options = {})
    if item && item.image?
      image_tag(item.image.url(format), options.reverse_merge(:alt => item.name, :title => item.name))
    else
      item.try(:name)
    end
  end

  def item_tooltip(item)
    content_tag(:div,
      content_tag(:h2, item.name) + render("items/effects", :item => item),
      :class  => "payouts tooltip_content",
      :id     => dom_id(item, :tooltip)
    )
  end

  def item_price_inline(item, amount = 1)
    if item.price?
      result = [].tap do |prices|
        if item.basic_price > 0
          prices << content_tag(:span,
            attribute_requirement_text(:basic_money, number_to_currency(item.basic_price * amount)),
            :class => :basic_money
          )
        end

        if item.vip_price > 0
          prices << content_tag(:span,
            attribute_requirement_text(:vip_money, item.vip_price * amount),
            :class => :vip_money
          )
        end
      end

      result.to_sentence.html_safe
    else
      t("items.item.free")
    end
  end

  def item_with_amount(item, amount)
    content_tag(:div, :class => "item") do
      item_image(item, :icon) <<
      content_tag(:span, "#{item.name} x #{amount}")
    end
  end
end
