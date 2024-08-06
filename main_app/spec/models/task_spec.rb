require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:user_id) }
  it { should define_enum_for(:status).with_values(%i[pending in_progress completed]) }
end
