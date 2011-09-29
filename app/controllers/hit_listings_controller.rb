class HitListingsController < ApplicationController
  before_filter :check_hitlist_enabled

  def index
    fetch_incomplete_listings
  end

  def new
    @victim = Character.find(params[:character_id])

    @hit_listing = current_character.ordered_hit_listings.build(
      :victim => @victim,
      :reward => Setting.i(:hit_list_minimum_reward)
    )

    render :new, :layout => "ajax"
  end

  def create
    @victim = Character.find(params[:character_id])

    @hit_listing = current_character.ordered_hit_listings.build(
      :victim => @victim,
      :reward => params[:hit_listing][:reward]
    )

    if @hit_listing.save
      fetch_incomplete_listings

      # Reloading current character to show changed attributes
      current_character(true)

      render :create, :layout => "ajax"
    else
      render :new, :layout => "ajax"
    end
  end

  def update
    @hit_listing = HitListing.find(params[:id])

    @fight = @hit_listing.execute!(current_character)

    fetch_incomplete_listings if @hit_listing.completed?

    render :action => :update, :layout => "ajax"
  end

  protected

  def fetch_incomplete_listings
    @hit_listings = HitListing.incomplete.available_for(current_character).paginate(
      :page     => params[:page],
      :per_page => Setting.i(:hit_list_display_limit)
    )
  end

  def check_hitlist_enabled
    redirect_from_iframe root_url(:canvas => true) unless Setting.b(:hit_list_enabled)
  end
end
