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

    expect(d3_1.tol).to be_within(0.01).of(0.01)  # default Topolys tolerance
    d3_1.setTolerance(0.001)                 # ... which can be reset by user
    expect(d3_2.tol).to be_within(0.001).of(0.001)        # ... global impact
    d3_2.resetTolerance                             # back to Topolys default
    expect(d3_1.tol).to be_within(0.01).of(0.01)
    expect(d3_1.tol).to be_within(0.01).of(d3_2.tol)

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
    v3D_1 = p3D_1 - p3D_2                   # basic point & vector operation
    unless v3D_1.nil?
      expect(p3D_2 == v3D_1).to eq(false)   # despite having same XYZ values
      expect(p3D_2.eql?(v3D_1)).to eq(false)
      expect(v3D_1.magnitude).to be_within(0.0001).of(3.4641016151377544)
    end

    v3D_2 = Topolys::V3D.new(x:1, y:2, z:3)
    v3D_3 = v3D_1 + v3D_2                   # overridden '+' operator
    unless v3D_3.nil?
      expect(v3D_3.x).to be_within(0.0001).of(3)
      expect(v3D_3.y).to be_within(0.0001).of(4)
      expect(v3D_3.z).to be_within(0.0001).of(5)
    end
    v3D_3 += v3D_2
    unless v3D_3.nil?
      expect(v3D_3.x).to be_within(0.0001).of(4)
      expect(v3D_3.y).to be_within(0.0001).of(6)
      expect(v3D_3.z).to be_within(0.0001).of(8)
    end

    v3D_3 = v3D_1 - v3D_2                   # overridden '-' operator
    unless v3D_3.nil?
      expect(v3D_3.x).to be_within(0.0001).of(1)
      expect(v3D_3.y).to be_within(0.0001).of(0)
      expect(v3D_3.z).to be_within(0.0001).of(-1)
    end
    v3D_3 -= v3D_2
    unless v3D_3.nil?
      expect(v3D_3.x).to be_within(0.0001).of(0)
      expect(v3D_3.y).to be_within(0.0001).of(-2)
      expect(v3D_3.z).to be_within(0.0001).of(-4)
    end

    v3D_4 = v3D_3 * 2                     # overridden '*' operator
    unless v3D_4.nil?
      expect(v3D_4.x).to be_within(0.0001).of(0)
      expect(v3D_4.y).to be_within(0.0001).of(-4)
      expect(v3D_4.z).to be_within(0.0001).of(-8)
    end
    v3D_4 *= 2
    unless v3D_4.nil?
      expect(v3D_4.x).to be_within(0.0001).of(0)
      expect(v3D_4.y).to be_within(0.0001).of(-8)
      expect(v3D_4.z).to be_within(0.0001).of(-16)
    end

    v3D_5 = v3D_4 / 2                     # overridden '/' operator
    unless v3D_5.nil?
      expect(v3D_5.x).to be_within(0.0001).of(0)
      expect(v3D_5.y).to be_within(0.0001).of(-4)
      expect(v3D_5.z).to be_within(0.0001).of(-8)
    end
    v3D_5 /= 2
    unless v3D_5.nil?
      expect(v3D_5.x).to be_within(0.0001).of(0)
      expect(v3D_5.y).to be_within(0.0001).of(-2)
      expect(v3D_5.z).to be_within(0.0001).of(-4)
    end

    v3D_5.normalize                       # unit vector & dot product
    expect(v3D_5.x).to be_within(0.0001).of(0)
    expect(v3D_5.y).to be_within(0.0001).of(-0.4472135954999579)
    expect(v3D_5.z).to be_within(0.0001).of(-0.8944271909999159)
    expect(v3D_5.magnitude).to be_within(0.00001).of(1)
    expect(v3D_5.dot(v3D_2)).to be_within(0.0001).of(-3.5777087639996634)
    v3D_6 = Topolys::V3D.new(x:1, y:0, z:0)
    v3D_7 = Topolys::V3D.new(x:0, y:1, z:0)
    expect(v3D_6.dot(v3D_7)).to be_within(0.0001).of(0)
    v3D_6.x = -1
    v3D_7.y = -1
    expect(v3D_6.dot(v3D_7)).to be_within(0.0001).of(0)

    # angle between vectors
    expect(v3D_6.angle(v3D_7)).to be_within(0.0001).of(1.5707963267948966)

    v3D_8 = v3D_7.cross(v3D_6)            # cross product
    expect(v3D_8.x).to be_within(0.0001).of(0)
    expect(v3D_8.y).to be_within(0.0001).of(0)
    expect(v3D_8.z).to be_within(0.0001).of(-1)

    v3D_9 = v3D_8 / 0
    expect(v3D_9).to eq(nil)
  end # P3D & V3D

  it "checks basic E3D, W3D & F3D class functionality" do
    p3D_1 = Topolys::P3D.new(x:0, y:1, z:3)
    p3D_2 = Topolys::P3D.new(x:1, y:1, z:0)
    e3D_1 = Topolys::E3D.new(p3D_1, p3D_2)
    e3D_2 = Topolys::E3D.new(p3D_1, p3D_2)

    # each point will respectively link to only one edge, given edge equality
    expect(p3D_1.edges.size).to eq(1)
    expect(p3D_2.edges.size).to eq(1)
    expect(e3D_1.v0 == p3D_1).to be(true)
    expect(e3D_1.v == p3D_2).to be(true)

    # '==', 'eql?' & 'equal?' overridden methods
    expect(e3D_1.is_a?(Topolys::E3D)).to eq(true)
    expect(e3D_1 == e3D_2).to eq(true)
    expect(e3D_1.eql?(e3D_2)).to eq(true)
    expect(e3D_1).to eq(e3D_2)
    expect(e3D_1.equal?(e3D_2)).to be(false)
    expect(e3D_1.inverted?(e3D_2)).to eq(false)
    e3D_2.invert
    expect(e3D_1.inverted?(e3D_2)).to eq(true) # useful in getting 'direction'

    v3D_1 = p3D_2 - p3D_1
    expect(v3D_1.magnitude).to be_within(0.0001).of(e3D_1.length)

    # demo on accessing edges linked to vertices
    p3D_1.edges.each do |e, id|
      expect(e.v0 == p3D_1).to be(true)     # value comparison
      expect(id == e.object_id).to be(true) # or vs object uniqueness
    end

  end # E3D, W3D & F3D
end # Topolys
