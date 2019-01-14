require 'rails_helper'
require Rails.root.join 'spec/concerns/authenticator_spec'

RSpec.describe User, type: :model do

  it_behaves_like 'authenticator'

end
