require 'topolys'
require 'geometry_helpers'

RSpec.describe Topolys do

  it "can build model for faces case 1" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    expect(model.vertices.size).to eq(10)
    expect(wire1.vertices.size).to eq(8)
    expect(wire2.vertices.size).to eq(6)

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(12+5)

  end

  it "can build model for faces case 1 - reverse" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])

    expect(model.vertices.size).to eq(10)
    expect(wire1.vertices.size).to eq(8)
    expect(wire2.vertices.size).to eq(6)

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(12+5)

  end

  it "can build model for faces case 2" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    wire1 = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 0))
    hole1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [hole1])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    expect(model.vertices.size).to eq(10)
    expect(wire1.vertices.size).to eq(6)
    expect(hole1.vertices.size).to eq(4)
    expect(wire2.vertices.size).to eq(6)

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(3)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length).to eq(20)

  end

  it "can build model for faces case 2 - reverse" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    wire1 = model.get_wire(vertices)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 2))
    vertices << model.get_vertex(Topolys::Point3D.new(15, 5, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(12, 5, 0))
    hole1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [hole1])

    expect(model.vertices.size).to eq(10)
    expect(wire1.vertices.size).to eq(6)
    expect(hole1.vertices.size).to eq(4)
    expect(wire2.vertices.size).to eq(6)

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(3)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length).to eq(20)

  end

  it "can build model for faces case 3" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 3))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 1))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])

    expect(model.vertices.size).to eq(10)
    expect(wire1.vertices.size).to eq(10)
    expect(wire2.vertices.size).to eq(4)
    expect(wire3.vertices.size).to eq(4)

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(2)

    shared_edges = face1.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(4)

    shared_edges = face2.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(5)
  end

  it "can build model for faces case 3 - reverse" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 1))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 3))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 3))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])

    expect(model.vertices.size).to eq(10)
    expect(wire1.vertices.size).to eq(10)
    expect(wire2.vertices.size).to eq(4)
    expect(wire3.vertices.size).to eq(4)

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(2)

    shared_edges = face1.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(2)
    expect(shared_edges[0].length + shared_edges[1].length).to eq(4)

    shared_edges = face2.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(5)
  end

  it "can build model for faces case 5" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 1))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 0))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 4))
    wire4 = model.get_wire(vertices)
    face4 = model.get_face(wire4, [])

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(0)

    shared_edges = face1.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(3)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length).to eq(5)

    shared_edges = face1.shared_outer_edges(face4)
    expect(shared_edges.size).to eq(3)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length).to eq(5)

    shared_edges = face2.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(3)

    shared_edges = face2.shared_outer_edges(face4)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(3)

    shared_edges = face3.shared_outer_edges(face4)
    expect(shared_edges.size).to eq(0)
  end

  it "can build model for faces case 5 - reverse" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 4))
    wire4 = model.get_wire(vertices)
    face4 = model.get_face(wire4, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 0))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 4))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 5, 1))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 1))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 5))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 1, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 4, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])

    shared_edges = face1.shared_outer_edges(face2)
    expect(shared_edges.size).to eq(0)

    shared_edges = face1.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(3)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length).to eq(5)

    shared_edges = face1.shared_outer_edges(face4)
    expect(shared_edges.size).to eq(3)
    expect(shared_edges[0].length + shared_edges[1].length + shared_edges[2].length).to eq(5)

    shared_edges = face2.shared_outer_edges(face3)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(3)

    shared_edges = face2.shared_outer_edges(face4)
    expect(shared_edges.size).to eq(1)
    expect(shared_edges[0].length).to eq(3)

    shared_edges = face3.shared_outer_edges(face4)
    expect(shared_edges.size).to eq(0)
  end

end # Topolys
