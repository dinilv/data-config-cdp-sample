class Config::AdminService < ApplicationService

  def create_media(media_data)
    media = Media.new
    media.media_template = media_data[:media_template]
    media.media_name = media_data[:media_name]
    media.media_id = media_data[:media_id]
    media.countryIDs = media_data[:countryIDs]
    media.save
    @@redis_service.set_hashset(MEDIA, media_data[:media_id], media_data[:media_name])
    return true, "success"
  end

  def update_media(media_data)
    media = Media.find_by(media_id: media_data[ConfigConstants::MEDIA_ID])
    media_value = {}
    ConfigConstants::MEDIA_KEY.each do |key, value|
      media_value[value] = media_data[value]
      media.update_attributes(media_value)
    end
    # media.save
    @@redis_service.set_hashset(MEDIA, media_data[:media_id], media_value["media_name"])
    return true, "success"
  end

  def show_media(media_data)
    media_details = Media.find_by(media_id: media_data[:id])
    response_obj = media_details
    return true, response_obj
  end




end
