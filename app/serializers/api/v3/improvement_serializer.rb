class Api::V3::ImprovementSerializer < ActiveModel::Serializer
  attributes :id, :title, :short_description, :description, :address, :address_comp, 
              :limit_volunteers, :start_date, :end_date, :knowledge_required, :people_benefited,
              :support_materials, :status, :social_entity_id

  belongs_to :social_entity
  
end