class TaskType < ApplicationRecord

    validates_presence_of :name

    has_many :tasks, dependent: :destroy
end
