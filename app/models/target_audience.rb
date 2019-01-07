class TargetAudience < ApplicationRecord
    validates_presence_of :name

    has_many :social_entities, dependent: :destroy
end
