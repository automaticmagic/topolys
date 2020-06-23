require 'topolys'
require 'open3'

RSpec.describe Topolys do
  it "has a version number" do
    expect(Topolys::VERSION).not_to be nil
  end

  it "checks if false is false" do
    expect(false).to eq(false)
  end
end
