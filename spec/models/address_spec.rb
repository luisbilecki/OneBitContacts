require 'rails_helper'

describe Address, :type => :model do

  context 'Valid Factory' do
    it 'has a valid factory' do
      expect(build(:address)).to be_valid
    end
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'Associations' do
    it { is_expected.to belong_to(:contact) }
  end

end
