require 'spec_helper'

describe Jobs::RequestDelete do
  describe 'when performing' do
    before do
      @job = Jobs::RequestDelete.new([123, 456])
      
      @request1 = mock_model(AppRequest, :delete_from_facebook! => true)
      @request2 = mock_model(AppRequest, :delete_from_facebook! => true)
      
      AppRequest::Base.stub!(:find_all_by_id).and_return([@request1, @request2])
    end
    
    it 'should find all requests by passed ID' do
      AppRequest::Base.should_receive(:find_all_by_id).and_return([@request1, @request2])
      
      @job.perform
    end
    
    it 'should delete requests' do
      @request1.should_receive(:delete_from_facebook!).and_return(true)
      @request2.should_receive(:delete_from_facebook!).and_return(true)
      
      @job.perform
    end
  end
end