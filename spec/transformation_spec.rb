require 'topolys'
require 'geometry_helpers'

RSpec.describe Topolys do

  it "has Transformation class" do
  
    # Identity
    
    t1 = Topolys::Transformation.new
    expect(t1.is_a?(Topolys::Transformation)).to eq(true)
    
    p = Topolys::Point3D.new(1,0,0)
    p1 = t1*p
    expect(p1.is_a?(Topolys::Point3D)).to eq(true)
    expect(p1.x).to be_within(0.0001).of(1)
    expect(p1.y).to be_within(0.0001).of(0)
    expect(p1.z).to be_within(0.0001).of(0)
    
    v = Topolys::Vector3D.new(1,0,0)
    v1 = t1*v
    expect(v1.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v1.x).to be_within(0.0001).of(1)
    expect(v1.y).to be_within(0.0001).of(0)
    expect(v1.z).to be_within(0.0001).of(0)
    
    # Rotation
    
    t2 = Topolys::Transformation.rotation(Topolys::Vector3D.y_axis, degToRad(-90))
    expect(t2.is_a?(Topolys::Transformation)).to eq(true)
    p = Topolys::Point3D.new(1,0,0)
    p1 = t2*p
    expect(p1.is_a?(Topolys::Point3D)).to eq(true)
    expect(p1.x).to be_within(0.0001).of(0)
    expect(p1.y).to be_within(0.0001).of(0)
    expect(p1.z).to be_within(0.0001).of(1)
    
    v = Topolys::Vector3D.new(1,0,0)
    v1 = t2*v
    expect(v1.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v1.x).to be_within(0.0001).of(0)
    expect(v1.y).to be_within(0.0001).of(0)
    expect(v1.z).to be_within(0.0001).of(1)
    
    # Translation
    
    t3 = Topolys::Transformation.translation(Topolys::Vector3D.x_axis*4)
    expect(t3.is_a?(Topolys::Transformation)).to eq(true)
    
    p = Topolys::Point3D.new(1,0,0)
    p1 = t3*p
    expect(p1.is_a?(Topolys::Point3D)).to eq(true)
    expect(p1.x).to be_within(0.0001).of(5)
    expect(p1.y).to be_within(0.0001).of(0)
    expect(p1.z).to be_within(0.0001).of(0)
    
    v = Topolys::Vector3D.new(1,0,0)
    v1 = t3*v
    expect(v1.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v1.x).to be_within(0.0001).of(5)
    expect(v1.y).to be_within(0.0001).of(0)
    expect(v1.z).to be_within(0.0001).of(0)
    
    # Translation then rotation
    
    p = Topolys::Point3D.new(1,0,0)
    p1 = t2*t3*p
    expect(p1.is_a?(Topolys::Point3D)).to eq(true)
    expect(p1.x).to be_within(0.0001).of(0)
    expect(p1.y).to be_within(0.0001).of(0)
    expect(p1.z).to be_within(0.0001).of(5)
    
    v = Topolys::Vector3D.new(1,0,0)
    v1 = t2*t3*v
    expect(v1.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v1.x).to be_within(0.0001).of(0)
    expect(v1.y).to be_within(0.0001).of(0)
    expect(v1.z).to be_within(0.0001).of(5)
    
    # Rotation then translation
    
    p = Topolys::Point3D.new(1,0,0)
    p1 = t3*t2*p
    expect(p1.is_a?(Topolys::Point3D)).to eq(true)
    expect(p1.x).to be_within(0.0001).of(4)
    expect(p1.y).to be_within(0.0001).of(0)
    expect(p1.z).to be_within(0.0001).of(1)
    
    v = Topolys::Vector3D.new(1,0,0)
    v1 = t3*t2*v
    expect(v1.is_a?(Topolys::Vector3D)).to eq(true)
    expect(v1.x).to be_within(0.0001).of(4)
    expect(v1.y).to be_within(0.0001).of(0)
    expect(v1.z).to be_within(0.0001).of(1)
    
    # Array multiplication
    p = make_rectangle(1,1)
    p1 = t3*p
    expect(p.size).to eq(4)
    expect(p.size).to eq(p1.size)
    p.each_index do |i|
      expect(p1[i].x).to be_within(0.0001).of(p[i].x + 4)
      expect(p1[i].y).to be_within(0.0001).of(p[i].y)
      expect(p1[i].z).to be_within(0.0001).of(p[i].z)
    end
    
    p2 = move_points(p, Topolys::Vector3D.new(4,0,0))
    expect(p2.size).to eq(p1.size)
    p2.each_index do |i|
      expect(p2[i].x).to be_within(0.0001).of(p1[i].x)
      expect(p2[i].y).to be_within(0.0001).of(p1[i].y)
      expect(p2[i].z).to be_within(0.0001).of(p1[i].z)
    end
  end 
  
end # Topolys
