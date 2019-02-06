class Api::V3::BillingSerializer < ActiveModel::Serializer
  attributes :id, :document, :doc_date, :ref_ini_date, :ref_end_date, :link_document, :status, :user_id, :created_at, :updated_at

  belongs_to :user  
end
