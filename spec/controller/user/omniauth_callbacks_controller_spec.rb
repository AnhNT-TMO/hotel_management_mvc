require "rails_helper"
require "spec_helper"
require "cancan/matchers"
RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: "1234512345",
      info: {name: "asdasdasdsa",email: "asdsaadsaa@gmail.com"},
      password: Devise.friendly_token[0, 20]
    })
    request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  describe "Login with google_oauth2" do
    context "when account persisted" do
      it "flash notice" do
        get :google_oauth2

        value = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
        expect(flash[:notice]).to eq value
      end
    end

    context "when account first login" do
      it "redirect_to new_user_registration_url" do
        allow_any_instance_of(User).to receive(:persisted?).and_return(false)
        get :google_oauth2

        expect(response).to redirect_to new_user_registration_url
      end
    end
  end
end
