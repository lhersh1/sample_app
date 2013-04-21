require 'spec_helper'

describe "Micropost pages" do

    subject { page }

    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    describe "micropost creation" do
      before { visit root_path }

      describe "with invalid information" do

        it "should not create a micropost" do
          expect { click_button "Post" }.not_to change(Micropost, :count)
        end

        describe "error messages" do
         before { click_button "Post" }
         it { should have_content('error') }
       end
     end

     describe "with valid information" do

       before { fill_in 'micropost_content', with: "Lorem ipsum" }
       it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
       end
     end
  end

   describe "Micropost destruction" do
     before { FactoryGirl.create(:micropost, user: user) }
     
      describe "as correct user" do
        before { visit root_path }
         
        it "should delete a micropost" do
         expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end
      end

     describe "as incorrect user" do
       let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
       let(:micropost) { FactoryGirl.create(:micropost, user: wrong_user) }
       before { visit user_path wrong_user }

       it { should_not have_link('delete', href: micropost_path(micropost)) }

       it "should not submit a DELETE request to the Micropost#destroy action" do
          expect { delete micropost_path(micropost) }.to_not change(Micropost, :count).by(-1)
      end
    end 
  end
end

  
