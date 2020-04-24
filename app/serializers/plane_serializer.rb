class PlaneSerializer < ActiveModel::Serializer
  attributes :id, :status, :readable_status, :title

  def readable_status
    object.status.upcase.gsub('_', ' ')
  end
end