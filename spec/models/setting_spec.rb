require File.expand_path("../../spec_helper", __FILE__)

describe Setting do
  describe "when assigning setting value" do
    describe "if new value is not nil" do
      it "should try to create new value" do
        lambda{
          Setting[:some_value] = "asd"
        }.should change(Setting, :count).by(1)
      end
      
      it "should change existing value" do
        Setting[:some_value] = "asd"

        lambda{
          Setting[:some_value] = "sdf"
        }.should change{ Setting[:some_value] }.from("asd").to("sdf")
      end
    end

    describe "if new value is nil" do
      it "should try to delete existing value" do
        Setting[:some_value] = "asd"

        lambda{
          Setting[:some_value] = nil
        }.should change(Setting, :count).by(-1)
      end

      it "should not fail if the value doesn't exist" do
        lambda{
          Setting[:non_existent_value] = nil
        }.should_not raise_exception
      end
    end
  end
end