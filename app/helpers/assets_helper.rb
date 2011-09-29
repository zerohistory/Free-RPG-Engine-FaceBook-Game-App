module AssetsHelper
  def asset_image_path(asset_alias)
    if asset = Asset[asset_alias]
      url = asset.image.url
    else
      url = "1px.gif"
    end

    image_path(url)
  end

  def asset_image_tag(asset_alias, options = {})
    image_tag(asset_image_path(asset_alias), options)
  end
end
