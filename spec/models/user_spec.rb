require "spec_helper"

describe User do
  shared_examples_for 'schedules social data update' do
    it 'should schedule social data update' do
      lambda{
        @user.save!
      }.should change(Delayed::Job, :count).by(1)
      
      Delayed::Job.last.payload_object.should be_kind_of(Jobs::UserDataUpdate)
      Delayed::Job.last.payload_object.user_ids.should == [@user.id]
    end    
  end
  
  
  describe 'scopes' do
    before :each do 
      @user = Factory(:user)
    end
    
    it 'should not return users without email' do
      User.with_email.should be_empty
    end
    
    it 'should return users with email' do
      @user.update_attribute(:email, "test@test.com")
      User.with_email.should == [@user]
    end
  end


  describe 'when creating' do
    before do
      @user = Factory.build(:user)
    end
    
    it_should_behave_like 'schedules social data update'
  end
  
  
  describe 'when updating' do
    before do
      @user = Factory(:user)
    end
    
    describe 'when access token changes' do
      before do
        @user.access_token = 'someothertoken'
      end
      
      it_should_behave_like 'schedules social data update'
    end
  end
  
  
  describe "when assigning signup IP" do
    before do
      @user = User.new
    end
    
    it 'should covert string value to integer' do
      lambda{
        @user.signup_ip = '127.0.0.1'
      }.should change(@user, :signup_ip).from(nil).to(2130706433)
    end
    
    it 'should store integer value as is' do
      lambda{
        @user.signup_ip = 64000
      }.should change(@user, :signup_ip).from(nil).to(64000)
    end
  end
  
  describe "when retrieving signup IP" do
    before do
      @user = Factory.build(:user)
      @user.signup_ip = '127.0.0.1'
    end
    
    it 'should return parsed IP value as IPAddr object' do
      @user.signup_ip.should be_kind_of(IPAddr)
      @user.signup_ip.should == IPAddr.new('127.0.0.1')
    end
    
    it 'should return nil if IP is not set' do
      @user.signup_ip = nil
      
      @user.signup_ip.should be_nil
    end
    
    it 'should correctly store values after 127.*' do
      @user.signup_ip = '250.250.250.250'
      @user.save!
      
      @user.reload.signup_ip.should == IPAddr.new('250.250.250.250')
    end
  end
  
  describe "when assigning last visit IP" do
    before do
      @user = User.new
    end
    
    it 'should covert string value to integer' do
      lambda{
        @user.last_visit_ip = '127.0.0.1'
      }.should change(@user, :last_visit_ip).from(nil).to(2130706433)
    end
    
    it 'should store integer value as is' do
      lambda{
        @user.last_visit_ip = 64000
      }.should change(@user, :last_visit_ip).from(nil).to(64000)
    end
  end

  describe "when retrieving last visit IP" do
    before do
      @user = Factory.build(:user)
      @user.last_visit_ip = '127.0.0.1'
    end
    
    it 'should return parsed IP value as IPAddr object' do
      @user.last_visit_ip.should be_kind_of(IPAddr)
      @user.last_visit_ip.should == IPAddr.new('127.0.0.1')
    end
    
    it 'should return nil if IP is not set' do
      @user.last_visit_ip = nil
      
      @user.last_visit_ip.should be_nil
    end
    
    it 'should correctly store values after 127.*' do
      @user.last_visit_ip = '250.250.250.250'
      @user.save!
      
      @user.reload.last_visit_ip.should == IPAddr.new('250.250.250.250')
    end
  end
  
  describe 'when updating social data' do
    before do
      @user = Factory(:user)
      
      @mogli_user = mock('Mogli::User',
        :client= => true,
        :fetch => true,
        
        :first_name => 'Fake Name',
        :last_name => 'Fake Surname',
        :timezone => 5,
        :locale => 'ab_CD',
        :gender => 'male',
        :email => 'user@test.com',
        
        :third_party_id => 'abcd1234',
        
        :friends => [
          mock('user 1', :id => 123),
          mock('user 2', :id => 456),
          mock('user 3', :id => 789)
        ]
      )
      
      Mogli::User.stub!(:find).and_return(@mogli_user)
    end
    
    it 'should successfully update data' do
      @user.update_social_data!.should be_true
    end
    
    it 'should return false if user doesn\'t have access token' do
      @user.access_token = ''
      
      @user.update_social_data!.should be_false
    end
    
    it 'should return false if access token is already expired' do
      @user.access_token_expire_at = 1.minute.ago
      
      @user.update_social_data!.should be_false
    end
    
    it 'should fetch user data using Facebook API' do
      Mogli::User.should_receive(:find).and_return(@mogli_user)
      
      @user.update_social_data!
    end
    
    it "should update first name to received value" do
      lambda{
        @user.update_social_data!
      }.should change(@user, :first_name).from('').to('Fake Name')
    end

    it "should update last name to received value" do
      lambda{
        @user.update_social_data!
      }.should change(@user, :last_name).from('').to('Fake Surname')
    end
    
    it "should update time zone to received value" do
      lambda{
        @user.update_social_data!
      }.should change(@user, :timezone).from(nil).to(5)
    end

    it "should update locale to received value" do
      lambda{
        @user.update_social_data!
      }.should change(@user, :locale).from('en_US').to('ab_CD')
    end

    it 'should update gender to received value' do
      lambda{
        @user.update_social_data!
      }.should change(@user, :gender).from(nil).to(:male)
    end
    
    it 'should not try to update gender is there is no gender in received data' do
      @mogli_user.should_receive(:gender).and_return(nil)
      
      lambda{
        @user.update_social_data!
      }.should_not change(@user, :gender)
    end
    
    it "should update third-party id to received value" do
      lambda{
        @user.update_social_data!
      }.should change(@user, :third_party_id).from('').to('abcd1234')
    end
    
    it 'should update friend_ids field to a list of friend UIDs' do
      lambda{
        @user.update_social_data!
      }.should change(@user, :friend_ids).from(nil).to([123, 456, 789])
    end

    it 'should save user' do
      @user.update_social_data!
      
      @user.should_not be_changed
    end
  end
  
  describe 'when assigning friend UID list' do
    before do
      @user = Factory(:user)
    end
    
    it 'should store UIDs to attributes as a comma-separated list' do
      @user.friend_ids = [123, 456, 789]
      
      @user[:friend_ids].should == '123,456,789'
    end
  end
  
  describe 'when fetching friend UID list' do
    before do
      @user = Factory(:user)
    end
    
    it 'should return empty array when there are no UIDs' do
      @user.friend_ids.should be_empty
    end
    
    it 'should return an array of UIDs' do
      @user.update_attribute(:friend_ids, '123,456,789')
      
      @user.friend_ids.should == [123, 456, 789]
    end
  end
  
  describe 'when checking if access token is valid' do
    before do
      @user = Factory(:user)
    end
    
    it 'should return true' do
      @user.access_token_valid?.should be_true
    end
    
    it 'should return false if token is blank' do
      @user.access_token = ''
      
      @user.access_token_valid?.should be_false
    end
    
    it 'should return false if token is already expired' do
      @user.access_token_expire_at = 1.minute.ago
      
      @user.access_token_valid?.should be_false
    end
    
    it 'should return false if token expiration date is not set' do
      @user.access_token_expire_at = nil
      
      @user.access_token_valid?.should be_false
    end
  end
  
  describe '#gender=' do
    before do
      @user = Factory(:user, :gender => nil)
    end
    
    it 'should store gender value as integer' do
      @user.gender = :male
      @user[:gender].should == 1

      @user.gender = :female
      @user[:gender].should == 2
    end
    
    it 'should accept string values' do
      @user.gender = 'male'
      @user[:gender].should == 1
    end

    it 'should change value to nil if passed blank value' do
      @user.gender = :male
      @user.gender = nil
      
      @user[:gender].should be_nil

      @user.gender = :male
      @user.gender = ''

      @user[:gender].should be_nil
    end
        
    it 'should raise exception if passed wrong value' do
      lambda{
        @user.gender = :something
      }.should raise_exception(ArgumentError)
    end
  end
  
  describe '#gender' do
    before do
      @user = Factory(:user)
    end
    
    it 'should return symbols from stored values' do
      @user[:gender] = 1
      @user.gender.should == :male
      
      @user[:gender] = 2
      @user.gender.should == :female
    end
    
    it 'should return nil if there is no stored value' do
      @user[:gender] = nil
      @user.gender.should be_nil
    end
  end
end