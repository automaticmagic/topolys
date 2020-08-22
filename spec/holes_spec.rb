require 'topolys'
require 'geometry_helpers'
require "json-schema"

RSpec.describe Topolys do

  it "can build model for holes case 1" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 0))
    hole = model.get_wire(vertices)

    face = model.get_face(outer, [hole])
    expect(model.vertices.size).to eq(8)
    expect(outer.vertices.size).to eq(6)
    expect(hole.vertices.size).to eq(4)

    shared_edges = hole.shared_edges(outer)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(4)

    shared_edges = outer.shared_edges(hole)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(4)
  end

  it "can build model for holes case 2" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(4, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(4, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    hole = model.get_wire(vertices)

    face = model.get_face(outer, [hole])
    expect(model.vertices.size).to eq(7)
    expect(outer.vertices.size).to eq(6)
    expect(hole.vertices.size).to eq(4)

    shared_edges = hole.shared_edges(outer)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(7)

    shared_edges = outer.shared_edges(hole)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(7)
  end

  it "can build model for holes case 3" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 2))
    hole = model.get_wire(vertices)

    face = model.get_face(outer, [hole])
    expect(model.vertices.size).to eq(8)
    expect(outer.vertices.size).to eq(4)
    expect(hole.vertices.size).to eq(4)

    shared_edges = hole.shared_edges(outer)
    expect(shared_edges.size).to eq(0)

    shared_edges = outer.shared_edges(hole)
    expect(shared_edges.size).to eq(0)
  end

  it "can build model for holes case 4" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 0))
    hole1 = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 3))
    hole2 = model.get_wire(vertices)

    face = model.get_face(outer, [hole1, hole2])
    expect(model.vertices.size).to eq(10)
    expect(outer.vertices.size).to eq(6)
    expect(hole1.vertices.size).to eq(4)
    expect(hole2.vertices.size).to eq(4)

    shared_edges = hole1.shared_edges(outer)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(4)

    shared_edges = hole2.shared_edges(hole1)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(4)

    shared_edges = hole2.shared_edges(outer)
    expect(shared_edges.size).to eq(0)
  end

  it "can build model for holes case 5" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 0))
    hole1 = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 3))
    hole2 = model.get_wire(vertices)

    face = model.get_face(outer, [hole1, hole2])
    expect(model.vertices.size).to eq(10)
    expect(outer.vertices.size).to eq(8)
    expect(hole1.vertices.size).to eq(4)
    expect(hole2.vertices.size).to eq(4)

    shared_edges = hole1.shared_edges(outer)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(4)

    shared_edges = hole2.shared_edges(hole1)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(4)

    shared_edges = hole2.shared_edges(outer)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(4)
  end

  it "can build model for holes case 6" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(8, 0, 0))
    hole = model.get_wire(vertices)

    face = model.get_face(outer, [hole])
    expect(model.vertices.size).to eq(8)
    expect(outer.vertices.size).to eq(8)
    expect(hole.vertices.size).to eq(4)

    shared_edges = hole.shared_edges(outer)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(8)

    shared_edges = outer.shared_edges(hole)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(8)
  end

  it "can build model for holes case 7" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(5, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(5, 0, 2))
    hole1 = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 0, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 2))
    hole2 = model.get_wire(vertices)

    face = model.get_face(outer, [hole1, hole2])
    expect(model.vertices.size).to eq(10)
    expect(outer.vertices.size).to eq(4)
    expect(hole1.vertices.size).to eq(4)
    expect(hole2.vertices.size).to eq(4)

    shared_edges = hole1.shared_edges(outer)
    expect(shared_edges.size).to eq(0)

    shared_edges = hole2.shared_edges(outer)
    expect(shared_edges.size).to eq(0)

    shared_edges = hole2.shared_edges(hole1)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(2)

    shared_edges = hole1.shared_edges(hole2)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(2)
  end

  it "can build model for holes case 8" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    outer = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    hole = model.get_wire(vertices)

    face = model.get_face(outer, [hole])
    expect(model.vertices.size).to eq(4)
    expect(outer.vertices.size).to eq(4)
    expect(hole.vertices.size).to eq(4)

    shared_edges = hole.shared_edges(outer)
    expect(shared_edges.size).to eq(4)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length + shared_edges[3].length).to eq(50)

    shared_edges = outer.shared_edges(hole)
    expect(shared_edges.size).to eq(4)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length + shared_edges[3].length).to eq(50)
  end

end # Topolys
