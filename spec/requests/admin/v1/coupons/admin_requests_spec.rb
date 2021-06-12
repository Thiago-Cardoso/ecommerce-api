require 'rails_helper'

RSpec.describe "Admin V1 Coupons as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /coupons" do
      let(:url) { "/admin/v1/coupons" }
      let!(:coupons) { create_list(:coupon, 5) }

      it "returns all coupons" do
        get url, headers: auth_header(user)
        expect(body_json['coupons']).to eq coupons.as_json(only: %i(id name code status discount_value max_use due_date)) 
      end

      it "returns success status" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end
  end

  context "POST /coupons" do
    let(:url) { "/admin/v1/coupons" }
    let(:coupon) { attributes_for(:coupon) } 

    context "with valid params" do
      let(:coupon_params) { { coupon: attributes_for(:coupon) }.to_json }

      it 'adds a new Coupon' do
        expect do
          post url, headers: auth_header(user), params: coupon_params
        end.to change(Coupon, :count).by(1)
      end

      it 'return last added Coupon' do
        post url, headers: auth_header(user), params: coupon_params
        expected_coupon = Coupon.last.as_json(
          only: %i(id name code status discount_value max_use due_date)
        )
        expect(body_json['coupon']).to eq expected_coupon
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: coupon_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:coupon_invalid_params) do 
        { coupon: attributes_for(:coupon, name: nil) }.to_json
      end

      it 'does not add a new Coupon' do
        expect do
          post url, headers: auth_header(user), params: coupon_invalid_params
        end.to_not change(Coupon, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: coupon_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: auth_header(user), params: coupon_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "GET /coupons/:id" do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    it "returns requested Coupon" do
      get url, headers: auth_header(user)
      expected_coupon = coupon.as_json(
        only: %i(id name code status discount_value max_use due_date)
      )
      expect(body_json['coupon']).to eq expected_coupon
    end

    it "returns success status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "PATCH /coupons/:id" do
      let(:coupon) { create(:coupon) }
      let(:url) { "/admin/v1/coupons/#{coupon.id}" }

      context "with valid params" do
        let(:new_name) { 'My new Coupon' }
        let(:coupon_params) { { coupon: { name: new_name } }.to_json }

        it 'updates Coupons' do
          patch url, headers: auth_header(user), params: coupon_params
          coupon.reload
          expect(coupon.name).to eq new_name
        end

        it 'returns updated Coupon' do
          patch url, headers: auth_header(user), params: coupon_params
          coupon.reload
          expected_coupon = coupon.as_json(
            only: %i(id name code status discount_value max_use due_date)
          )
          expect(body_json['coupon']).to eq expected_coupon
        end

        it 'returns success status' do
          patch url, headers: auth_header(user), params: coupon_params
          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:coupon_invalid_params) do
          { coupon: attributes_for(:coupon, name: nil) }.to_json
        end

        it 'does not update Coupon' do
          old_name = coupon.name
          patch url, headers: auth_header(user), params: coupon_invalid_params
          coupon.reload
          expect(coupon.name).to eq old_name
        end

        it 'returns error message' do
          patch url, headers: auth_header(user), params: coupon_invalid_params
          expect(body_json['errors']['fields']).to have_key('name')
        end

        it 'returns unprocessable_entity status' do
          patch url, headers: auth_header(user), params: coupon_invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
  end

  context "DELETE /coupons/:id" do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    it 'removes Coupon' do
      expect do
        delete url, headers: auth_header(user)
      end.to change(Coupon, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end
end