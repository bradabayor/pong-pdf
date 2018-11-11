#spec/pong_spec.rb

require_relative '../lib/pong_lib.rb'

RSpec.describe "#get_folders" do
  path = Dir.pwd + "/01 Correspondence/*"
  it "returns nil if path is incorrect" do
    expect(get_folders(path + "abc")).to eql(nil)
  end
  it "returns an array" do
    expect(get_folders(path)).to be_a(Array)
  end
  it "contains a list of strings" do
    expect(get_folders(path)).to all( be_a(String))
  end
end
