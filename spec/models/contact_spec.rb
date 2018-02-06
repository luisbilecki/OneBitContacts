require 'rails_helper'

describe Contact, :type => :model do

  context 'Valid Factory' do
    it 'has a valid factory' do
      expect(build(:contact)).to be_valid
    end
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user) }
  end

  context 'Associations' do
    it { is_expected.to have_many(:addresses) }
    it { is_expected.to belong_to(:user) }
  end

end
