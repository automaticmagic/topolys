require 'topolys'
require 'geometry_helpers'

RSpec.describe Topolys do

  tol = 0.000000000001

  it "Wire can compute normal" do

    model = Topolys::Model.new

    points = []
    points << Topolys::Point3D.new(0, 10, 0)
    points << Topolys::Point3D.new(10, 10, 0)
    points << Topolys::Point3D.new(10, 0, 0)
    points << Topolys::Point3D.new(0, 0, 0)

    plane1 =  Topolys::Plane3D.from_points(points[0], points[1], points[2])

    expect(plane1.normal.magnitude).to be_within(tol).of(1)
    expect(plane1.normal.x).to be_within(tol).of(0)
    expect(plane1.normal.y).to be_within(tol).of(0)
    expect(plane1.normal.z).to be_within(tol).of(-1)

    vertices = []
    points.each {|p| vertices << model.get_vertex(p)}
    wire1 = model.get_wire(vertices)
    expect(wire1.vertices.size).to be(4)

    expect(wire1.normal.magnitude).to be_within(tol).of(1)
    expect(wire1.normal.x).to be_within(tol).of(0)
    expect(wire1.normal.y).to be_within(tol).of(0)
    expect(wire1.normal.z).to be_within(tol).of(-1)

    points = []
    points << Topolys::Point3D.new(0, 10, 0)
    points << Topolys::Point3D.new(0, 0, 0)
    points << Topolys::Point3D.new(10, 0, 0)
    points << Topolys::Point3D.new(10, 10, 0)

    plane2 =  Topolys::Plane3D.from_points(points[0], points[1], points[2])

    expect(plane2.normal.magnitude).to be_within(tol).of(1)
    expect(plane2.normal.x).to be_within(tol).of(0)
    expect(plane2.normal.y).to be_within(tol).of(0)
    expect(plane2.normal.z).to be_within(tol).of(1)

    vertices = []
    points.each {|p| vertices << model.get_vertex(p)}
    wire2 = model.get_wire(vertices)
    expect(wire2.vertices.size).to be(4)

    expect(wire2.normal.magnitude).to be_within(tol).of(1)
    expect(wire2.normal.x).to be_within(tol).of(0)
    expect(wire2.normal.y).to be_within(tol).of(0)
    expect(wire2.normal.z).to be_within(tol).of(1)

    # add a bunch of vertices on each edge
    (1..9).each do |x|
      model.get_vertex(Topolys::Point3D.new(x, 0, 0))
      model.get_vertex(Topolys::Point3D.new(x, 10, 0))
    end
    (1..9).each do |y|
      model.get_vertex(Topolys::Point3D.new(0, y, 0))
      model.get_vertex(Topolys::Point3D.new(10, y, 0))
    end

    expect(wire1.vertices.size).to be(40)
    expect(wire1.normal.magnitude).to be_within(tol).of(1)
    expect(wire1.normal.x).to be_within(tol).of(0)
    expect(wire1.normal.y).to be_within(tol).of(0)
    expect(wire1.normal.z).to be_within(tol).of(-1)

    expect(wire2.vertices.size).to be(40)
    expect(wire2.normal.magnitude).to be_within(tol).of(1)
    expect(wire2.normal.x).to be_within(tol).of(0)
    expect(wire2.normal.y).to be_within(tol).of(0)
    expect(wire2.normal.z).to be_within(tol).of(1)

  end


end # Topolys
