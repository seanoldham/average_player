# == Schema Information
#
# Table name: snapshots
#
#  id             :integer          not null, primary key
#  league_average :decimal(, )
#  mr_average_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Snapshot < ActiveRecord::Base
end
