require 'rails_helper'
require 'models/concerns/authenticator_spec'

RSpec.describe User, type: :model do

  it_behaves_like 'authenticator'

end
