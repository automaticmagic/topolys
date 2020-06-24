require 'topolys'
require 'open3'

RSpec.describe Topolys do
  it "has a version number" do
    expect(Topolys::VERSION).not_to be nil
  end

  it "checks D3 class functionality" do
    d3_1 = Topolys::D3.new(x:1, y:1, z:1)
    expect(d3_1.is_a?(Topolys::D3)).to eq(true)
    d3_2 = Topolys::D3.new(y:1, x:0)    # dimensions or order: optional
    expect(d3_2.is_a?(Topolys::D3)).to eq(true)
    expect(d3_1 == d3_2).to eq(false)
    expect(d3_1.eql?(d3_2)).to eq(false)
    expect(d3_2.z).to eq(0)
    d3_2.x = d3_2.z = 1
    expect(d3_1 == d3_2).to eq(true)    # overridden '==' & 'eql?', so
    expect(d3_1.eql?(d3_2)).to eq(true) # equality based on coordinates/class

    d3_3 = Topolys::D3.new
    d3_4 = d3_3.clone
    expect(d3_3).to eq(d3_4)

    # ... but not 'equal?', so can always rely on uniqueness of objects
    expect(d3_3.equal?(d3_4)).to eq(false)
    # ... variants
    expect(d3_3.to_s).not_to eq(d3_4.to_s)
    expect(d3_3.object_id).not_to eq(d3_4.object_id)

    # if instead d3_4 is assigned d3_3 ...
    d3_4 = d3_3
    expect(d3_3).to eq(d3_4)
    expect(d3_3.equal?(d3_4)).to eq(true)
    expect(d3_3.to_s).to eq(d3_4.to_s)
    expect(d3_3.object_id).to eq(d3_4.object_id)

    # reverting back to a new object
    d3_4 = d3_3.clone

    d3_array = [d3_1, d3_2, d3_3, d3_4] # demo: array of D3 objects
    expect(d3_array.size).to eq(4)
    d3_u_array = d3_array.uniq          # uniqueness based on coordinates/class
    expect(d3_u_array.size).to eq(2)

    d3_hash = {}                        # demo: D3 objects as unique hash keys
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

    d3_hash2 = {}                       # demo: D3 as unique hash keys
    d3_hash2[d3_1] = d3_1.object_id unless d3_hash2.key?(d3_1)
    d3_hash2[d3_2] = d3_2.object_id unless d3_hash2.key?(d3_2)
    d3_hash2[d3_3] = d3_3.object_id unless d3_hash2.key?(d3_3)
    d3_hash2[d3_4] = d3_4.object_id unless d3_hash2.key?(d3_4)
    expect(d3_hash2.value?(d3_1.object_id)).to eq(true)
    expect(d3_hash2.value?(d3_2.object_id)).to eq(false)
    expect(d3_hash2.value?(d3_3.object_id)).to eq(true)
    expect(d3_hash2.value?(d3_4.object_id)).to eq(false)
  end # D3

  it "checks basic P3D & V3D class functionality" do
    p3D_1 = Topolys::P3D.new(x:0, y:0, z:0)
    p3D_2 = Topolys::P3D.new(x:0, y:0, z:0)

    # inherits D3 ... '==', 'eql?' & 'equal?' overridden methods
    expect(p3D_1.is_a?(Topolys::P3D)).to eq(true)
    expect(p3D_1).to eq(p3D_2)
    expect(p3D_1.eql?(p3D_2)).to eq(true)
    expect(p3D_1 == p3D_2).to eq(true)
    expect(p3D_1.equal?(p3D_2)).to eq(false)

    p3D_2.x = p3D_2.y = p3D_2.z = 2

    v3D_1 = p3D_1 - p3D_2                 # basic point & vector operation
    unless v3D_1.nil?
      expect(p3D_2 == v3D_1).to eq(false)   # despite having same XYZ coordinates
      expect(p3D_2.eql?(v3D_1)).to eq(false)
      expect(v3D_1.magnitude).to be_within(0.0001).of(3.4641016151377544)
    end

  end # P3D & V3D
end # Topolys
