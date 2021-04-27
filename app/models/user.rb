class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    validates :id, presence: true
    validates :email, presence: true
    
  end
  