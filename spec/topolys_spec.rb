require 'topolys'
require 'open3'

RSpec.describe Topolys do
  it "has a version number" do
    expect(Topolys::VERSION).not_to be nil
  end

  it "checks D3 class functionality" do
    d3_1 = Topolys::D3.new(x:1, y:1, z:1)
    expect(d3_1.is_a?(Topolys::D3)).to eq(true)
    d3_2 = Topolys::D3.new(y:1, x:0) # 
    expect(d3_2.is_a?(Topolys::D3)).to eq(true)
    expect(d3_1 == d3_2).to eq(false)
    expect(d3_1.eql?(d3_2)).to eq(false)
    expect(d3_2.z).to eq(0)
    d3_2.x = d3_2.z = 1
    expect(d3_1 == d3_2).to eq(true)
    expect(d3_1.eql?(d3_2)).to eq(true)
    d3_3 = Topolys::D3.new
    d3_4 = d3_3.clone
    expect(d3_3).to eq(d3_4)
    expect(d3_1.to_s).not_to eq(d3_2.to_s)
    expect(d3_3.object_id).not_to eq(d3_4.object_id)

    d3_array = [d3_1, d3_2, d3_3, d3_4]
    expect(d3_array.size).to eq(4)
    d3_u_array = d3_array.uniq # ensuring D3 object uniqueness
    expect(d3_u_array.size).to eq(2)

    d3_hash = {} # demo: D3 objects as unique hash keys
    d3_hash[d3_1] = d3_1.object_id
    d3_hash[d3_2] = d3_2.object_id
    d3_hash[d3_3] = d3_3.object_id
    d3_hash[d3_4] = d3_4.object_id
    expect(d3_hash.size).to eq(2)
    expect(d3_hash.key?(d3_1)).to eq(true)
    expect(d3_hash.key?(d3_2)).to eq(true)
    expect(d3_hash.key?(d3_3)).to eq(true)
    expect(d3_hash.key?(d3_4)).to eq(true)
    expect(d3_hash.value?(d3_1.object_id)).to eq(false)
    expect(d3_hash.value?(d3_2.object_id)).to eq(true)
    expect(d3_hash.value?(d3_3.object_id)).to eq(false)
    expect(d3_hash.value?(d3_4.object_id)).to eq(true)

    d3_hash2 = {} # demo: D3 as unique hash keys
    d3_hash2[d3_1] = d3_1.object_id unless d3_hash2.key?(d3_1)
    d3_hash2[d3_2] = d3_2.object_id unless d3_hash2.key?(d3_2)
    d3_hash2[d3_3] = d3_3.object_id unless d3_hash2.key?(d3_3)
    d3_hash2[d3_4] = d3_4.object_id unless d3_hash2.key?(d3_4)
    expect(d3_hash2.value?(d3_1.object_id)).to eq(true)
    expect(d3_hash2.value?(d3_2.object_id)).to eq(false)
    expect(d3_hash2.value?(d3_3.object_id)).to eq(true)
    expect(d3_hash2.value?(d3_4.object_id)).to eq(false)

  end
end
