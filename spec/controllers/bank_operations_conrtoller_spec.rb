require 'spec_helper'

describe BankOperationsController do
  before do
    controller.stub!(:current_facebook_user).and_return(fake_fb_user)
  end

  describe "when routing" do
    it "should map GET /bank_operations/new to a deposit/withdraw form" do
      params_from(:get, "/bank_operations/new").should == {
        :controller   => "bank_operations",
        :action       => "new"
      }
    end

    it "should map POST /bank_operations/deposit to a deposit creation page" do
      params_from(:post, "/bank_operations/deposit").should == {
        :controller   => "bank_operations",
        :action       => "deposit"
      }
    end

    it "should map POST /bank_operations/withdraw to a withdrawal creation page" do
      params_from(:post, "/bank_operations/withdraw").should == {
        :controller   => "bank_operations",
        :action       => "withdraw"
      }
    end
  end

  describe "routing helpers" do
    it "should have helper for deposit/withdraw form" do
      new_bank_operation_path.should == "/bank_operations/new"
    end

    it "should have helper for deposit creation page" do
      deposit_bank_operations_path.should == "/bank_operations/deposit"
    end

    it "should have helper for withdrawal creation page" do
      withdraw_bank_operations_path.should == "/bank_operations/withdraw"
    end
  end
  
  describe "when displaying the form" do
    before :each do
      @deposit = mock_model(BankDeposit)
      @withdrawal = mock_model(BankWithdraw)

      BankDeposit.stub!(:new).and_return(@deposit)
      BankWithdraw.stub!(:new).and_return(@withdrawal)

      @character = mock_model(Character, :basic_money => 1000)

      controller.stub!(:current_character).and_return(@character)
    end

    def do_request
      get :new
    end

    it "should instantiate new deposit with current character money" do
      BankDeposit.should_receive(:new).with(:amount => 1000).and_return(@deposit)

      do_request
    end

    it "should pass new deposit to the template" do
      do_request

      assigns[:deposit].should == @deposit
    end

    it "should pass new withdraw to the template" do
      do_request

      assigns[:withdrawal].should == @withdrawal
    end

    it "should render 'new' as AJAX response" do
      do_request

      response.should render_template(:new)
      response.should use_layout('ajax')
    end
  end

  describe "when depositing money" do
    before :each do
      @deposit = mock_model(BankDeposit, :save => true)
      @character_deposits = mock("deposits", :build => @deposit)
      
      @character = mock_model(Character, 
        :bank_deposits  => @character_deposits,
        :reload         => true
      )

      controller.stub!(:current_character).and_return(@character)
    end

    def do_request
      post :deposit, :bank_operation => {:amount => 1000}
    end

    it "should build new deposit for character" do
      @character_deposits.should_receive(:build).with("amount" => 1000).and_return(@deposit)

      do_request
    end

    it "should save the new deposit" do
      @deposit.should_receive(:save).and_return(true)

      do_request
    end
    
    it "should pass deposit to the template" do
      do_request

      assigns[:deposit].should == @deposit
    end

    describe "if deposit was saved successfully" do
      it "should reload current character" do
        @character.should_receive(:reload).and_return(true)

        do_request
      end

      it "should render 'deposit' as AJAX response" do
        do_request

        response.should render_template(:deposit)
        response.should use_layout('ajax')
      end
    end

    describe "if deposit failed to save" do
      before :each do
        @deposit.stub!(:save).and_return(false)
      end

      it "should render 'new' as AJAX response" do
        do_request

        response.should render_template(:new)
        response.should use_layout('ajax')
      end
    end
  end

  describe "when withdrawing money" do
    before :each do
      @withdrawal = mock_model(BankWithdraw, :save => true)
      @character_withdrawals = mock("withdrawals", :build => @withdrawal)

      @character = mock_model(Character,
        :bank_withdrawals => @character_withdrawals,
        :reload           => true
      )

      controller.stub!(:current_character).and_return(@character)
    end

    def do_request
      post :withdraw, :bank_operation => {:amount => 1000}
    end

    it "should build new withdrawal for character" do
      @character_withdrawals.should_receive(:build).with("amount" => 1000).and_return(@withdrawal)

      do_request
    end

    it "should save the withdrawal" do
      @withdrawal.should_receive(:save).and_return(true)

      do_request
    end

    it "should pass withdrawal to the template" do
      do_request

      assigns[:withdrawal].should == @withdrawal
    end

    describe "if withdrawal was saved successfully" do
      it "should reload current character" do
        @character.should_receive(:reload).and_return(true)

        do_request
      end

      it "should render 'deposit' as AJAX response" do
        do_request

        response.should render_template(:withdraw)
        response.should use_layout('ajax')
      end
    end

    describe "if withdrawal failed to save" do
      before :each do
        @withdrawal.stub!(:save).and_return(false)
      end

      it "should render 'new' as AJAX response" do
        do_request

        response.should render_template(:new)
        response.should use_layout('ajax')
      end
    end
  end
end