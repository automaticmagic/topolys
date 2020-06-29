require 'topolys'

RSpec.describe Topolys do

  it "has Point3D class" do
    
    p0 = Topolys::Point3D.new(0, 0, 0)    
    expect(p0.is_a?(Topolys::Point3D)).to eq(true)
    expect(p0.x).to eq(0)
    expect(p0.y).to eq(0)
    expect(p0.z).to eq(0)
    expect(p0 == p0).to eq(true)
    expect(p0.eql?(p0)).to eq(true)
    
    p1 = Topolys::Point3D.new(1, 1, 1)
    expect(p1.is_a?(Topolys::Point3D)).to eq(true)
    expect(p1.x).to eq(1)
    expect(p1.y).to eq(1)
    expect(p1.z).to eq(1)
    expect(p1 == p1).to eq(true)
    expect(p1.eql?(p1)).to eq(true)
    expect(p0 == p1).to eq(false)
    expect(p0.eql?(p1)).to eq(false)
    
    p2 = Topolys::Point3D.new(1, 1, 1)
    expect(p2.is_a?(Topolys::Point3D)).to eq(true)
    expect(p2.x).to eq(1)
    expect(p2.y).to eq(1)
    expect(p2.z).to eq(1)
    expect(p2 == p2).to eq(true)
    expect(p2.eql?(p2)).to eq(true)
    expect(p2 == p1).to eq(false)
    expect(p2.eql?(p1)).to eq(false)
    
    v = p1-p0
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(1)
    expect(v.y).to eq(1)
    expect(v.z).to eq(1)
    
    v = p2-p1
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(0)
    expect(v.y).to eq(0)
    expect(v.z).to eq(0)
    
  end
 
  it "has Vector3D class" do
    
    v0 = Topolys::Vector3D.new(0, 0, 0)    
    expect(v0.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v0.x).to eq(0)
    expect(v0.y).to eq(0)
    expect(v0.z).to eq(0)
    expect(v0 == v0).to eq(true)
    expect(v0.eql?(v0)).to eq(true)
    
    v1 = Topolys::Vector3D.new(1, 1, 1)
    expect(v1.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v1.x).to eq(1)
    expect(v1.y).to eq(1)
    expect(v1.z).to eq(1)
    expect(v1 == v1).to eq(true)
    expect(v1.eql?(v1)).to eq(true)
    expect(v0 == v1).to eq(false)
    expect(v0.eql?(v1)).to eq(false)
    
    v2 = Topolys::Vector3D.new(1, 1, 1)
    expect(v2.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v2.x).to eq(1)
    expect(v2.y).to eq(1)
    expect(v2.z).to eq(1)
    expect(v2 == v2).to eq(true)
    expect(v2.eql?(v2)).to eq(true)
    expect(v2 == v1).to eq(false)
    expect(v2.eql?(v1)).to eq(false)
    
    v = v1-v0
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(1)
    expect(v.y).to eq(1)
    expect(v.z).to eq(1)
    
    v = v2-v1
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(0)
    expect(v.y).to eq(0)
    expect(v.z).to eq(0)
    
    v = v1+v0
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(1)
    expect(v.y).to eq(1)
    expect(v.z).to eq(1)
    
    v = v2+v1
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(2)
    expect(v.y).to eq(2)
    expect(v.z).to eq(2)
    
    v = v1*3.0
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(3)
    expect(v.y).to eq(3)
    expect(v.z).to eq(3)
    
    v = v1/2.0
    expect(v.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v.x).to eq(0.5)
    expect(v.y).to eq(0.5)
    expect(v.z).to eq(0.5)
    
  end 

  it "checks basic Point3D & Vector3D class functionality" do
    p3D_1 = Topolys::Point3D.new(0, 0, 0)
    p3D_2 = Topolys::Point3D.new(2, 2, 2)

    v3D_1 = p3D_2 - p3D_1
    expect(v3D_1.x).to eq(2)
    expect(v3D_1.y).to eq(2)
    expect(v3D_1.z).to eq(2)

    expect(p3D_2 == v3D_1).to eq(false)   # despite having same XYZ values
    expect(p3D_2.eql?(v3D_1)).to eq(false)
    expect(v3D_1.magnitude).to be_within(0.0001).of(3.4641016151377544)

    v3D_2 = Topolys::Vector3D.new(1, 2, 3)
    v3D_3 = v3D_1 + v3D_2                   # overridden '+' operator
    expect(v3D_3.x).to be_within(0.0001).of(3)
    expect(v3D_3.y).to be_within(0.0001).of(4)
    expect(v3D_3.z).to be_within(0.0001).of(5)

    v3D_3 += v3D_2
    expect(v3D_3.x).to be_within(0.0001).of(4)
    expect(v3D_3.y).to be_within(0.0001).of(6)
    expect(v3D_3.z).to be_within(0.0001).of(8)

    v3D_3 = v3D_1 - v3D_2                   # overridden '-' operator
    expect(v3D_3.x).to be_within(0.0001).of(1)
    expect(v3D_3.y).to be_within(0.0001).of(0)
    expect(v3D_3.z).to be_within(0.0001).of(-1)

    v3D_3 -= v3D_2
    expect(v3D_3.x).to be_within(0.0001).of(0)
    expect(v3D_3.y).to be_within(0.0001).of(-2)
    expect(v3D_3.z).to be_within(0.0001).of(-4)

    v3D_4 = v3D_3 * 2                     # overridden '*' operator
    expect(v3D_4.x).to be_within(0.0001).of(0)
    expect(v3D_4.y).to be_within(0.0001).of(-4)
    expect(v3D_4.z).to be_within(0.0001).of(-8)

    v3D_4 *= 2
    expect(v3D_4.x).to be_within(0.0001).of(0)
    expect(v3D_4.y).to be_within(0.0001).of(-8)
    expect(v3D_4.z).to be_within(0.0001).of(-16)

    v3D_5 = v3D_4 / 2                     # overridden '/' operator
    expect(v3D_5.x).to be_within(0.0001).of(0)
    expect(v3D_5.y).to be_within(0.0001).of(-4)
    expect(v3D_5.z).to be_within(0.0001).of(-8)

    v3D_5 /= 2
    expect(v3D_5.x).to be_within(0.0001).of(0)
    expect(v3D_5.y).to be_within(0.0001).of(-2)
    expect(v3D_5.z).to be_within(0.0001).of(-4)

    v3D_5.normalize                       # unit vector & dot product
    expect(v3D_5.x).to be_within(0.0001).of(0)
    expect(v3D_5.y).to be_within(0.0001).of(-0.4472135954999579)
    expect(v3D_5.z).to be_within(0.0001).of(-0.8944271909999159)
    expect(v3D_5.magnitude).to be_within(0.00001).of(1)
    expect(v3D_5.dot(v3D_2)).to be_within(0.0001).of(-3.5777087639996634)
    v3D_6 = Topolys::Vector3D.new(1, 0, 0)
    v3D_7 = Topolys::Vector3D.new(0, 1, 0)
    expect(v3D_6.dot(v3D_7)).to be_within(0.0001).of(0)

    # angle between vectors
    expect(v3D_6.angle(v3D_7)).to be_within(0.0001).of(1.5707963267948966)

    v3D_8 = v3D_7.cross(v3D_6)            # cross product
    expect(v3D_8.x).to be_within(0.0001).of(0)
    expect(v3D_8.y).to be_within(0.0001).of(0)
    expect(v3D_8.z).to be_within(0.0001).of(-1)

    v3D_9 = v3D_8 / 0
    expect(v3D_9).to eq(nil)
  end 

end # Topolys
