class PropertiesController < ApplicationController
  def index
    #@properties = current_character.properties
       @properties = current_character.properties.find(:all, :joins => "inner join ownerships on ownerships.target_id = properties.property_type_id and ownerships.character_type_id = #{current_character.character_type.id}")

  end

  def create
    @property_type = PropertyType.available_in(:shop, :special).available_for(current_character).
      find(params[:property_type_id])

    @property = current_character.properties.buy!(@property_type)

    @properties = current_character.properties(true)

    render :create, :layout => "ajax"
  end

  def upgrade
    @property = current_character.properties.find(params[:id])

    @property.upgrade!

    @properties = current_character.properties(true)

    render :upgrade, :layout => "ajax"
  end

  def collect_money
           @properties = current_character.properties.find(:all, :joins => "inner join ownerships on ownerships.target_id = properties.property_type_id and ownerships.character_type_id = #{current_character.character_type.id}")


    if params[:id]
      @property = current_character.properties.find(params[:id])

      @result = @property.collect_money!
    else
      @result = @properties.collect_money!
    end

    render :collect_money, :layout => "ajax"
  end

  def gift
    case request.method
    when :get
      @property = current_character.properties.find(params[:id])
      @amount = 1
      @cost = @property.property_type.gift_cost
      @can_make_gift = current_character.vip_money >= @cost
      render :gift, :layout => "ajax"
    when :post
      property = current_character.properties.find(params[:id])
      if params[:relation_id] && !params[:relation_id].empty?
        relation = FriendRelation.find(params[:relation_id])
        current_character.gift_property!(property, relation.character, params[:cost].to_i) if relation
      end

      redirect_to properties_path
    end
  end
end
