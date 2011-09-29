require 'spec_helper'

describe WallPost do
  it 'should paginate by 10' do
    WallPost.per_page.should == 10
  end

  describe 'associations' do
    before do
      @wall_post = WallPost.new
    end
    
    it 'should belong to character' do
      @wall_post.should belong_to(:character)
    end
    
    it 'should belong to author' do
      @wall_post.should belong_to(:author)
    end
  end

  describe 'attribute protection' do
    before do
      @wall_post = Factory(:wall_post)
    end

    it 'should allow to change text with mass assignment' do
      @wall_post.should allow_mass_assignment_of(:text)
    end

    %w{id character author created_at updated_at}.each do |attribute|
      it "should not allow to change #{attribute} with mass assignment" do
        @wall_post.should_not allow_mass_assignment_of(attribute)
      end
    end
  end

  describe 'when creating' do
    before do
      @wall_post = Factory.build(:wall_post)
    end

    it 'should validate presence of character' do
      @wall_post.should validate_presence_of(:character)
    end
    
    it 'should validate presence of author' do
      @wall_post.should validate_presence_of(:author)
    end

    it 'should validate presence of text' do
      @wall_post.should validate_presence_of(:text)
    end

    it 'should ensure that text is less than 4 kilobytes' do
      @wall_post.should ensure_length_of(:text).is_at_most(4.kilobytes)
    end
  end

  describe 'when checking if post is author post' do
    before do
      @character = Factory(:character)
    end

    it 'should return true when post author is wall owner' do
      @wall_post = Factory(:wall_post, :character => @character, :author => @character)

      @wall_post.author_post?.should be_true
    end
    
    it 'should return false when post author is not wall owner' do
      @wall_post = Factory(:wall_post, :character => @character)

      @wall_post.author_post?.should be_false
    end
  end
end