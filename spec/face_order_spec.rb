require 'topolys'
require 'geometry_helpers'
require "json-schema"

RSpec.describe Topolys do

  it "can build model for face order case 1" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])
    expect(model.vertices.size).to eq(4)
    expect(wire1.vertices.size).to eq(4)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 0))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])
    expect(model.vertices.size).to eq(6)
    expect(wire1.vertices.size).to eq(4)
    expect(wire2.vertices.size).to eq(4)

    edges_1_2 = face1.shared_outer_edges(face2)
    edges_2_1 = face2.shared_outer_edges(face1)
    expect(edges_1_2.size).to eq(1)
    expect(edges_2_1.size).to eq(1)
    expect(edges_1_2[0].id).to eq(edges_2_1[0].id)
    expect(edges_1_2[0].length).to eq(10)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 10))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])
    expect(model.vertices.size).to eq(8)
    expect(wire1.vertices.size).to eq(4)
    expect(wire2.vertices.size).to eq(4)
    expect(wire3.vertices.size).to eq(5)

    edges_1_3 = face1.shared_outer_edges(face3)
    edges_3_1 = face3.shared_outer_edges(face1)
    expect(edges_1_3.size).to eq(1)
    expect(edges_3_1.size).to eq(1)
    expect(edges_1_3[0].id).to eq(edges_3_1[0].id)
    expect(edges_1_3[0].length).to eq(10)

    edges_2_3 = face2.shared_outer_edges(face3)
    edges_3_2 = face3.shared_outer_edges(face2)
    expect(edges_2_3.size).to eq(1)
    expect(edges_3_2.size).to eq(1)
    expect(edges_2_3[0].id).to eq(edges_3_2[0].id)
    expect(edges_2_3[0].length).to eq(10)
  end

  it "can build model for face order case 2" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 10))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])
    expect(model.vertices.size).to eq(4)
    expect(wire1.vertices.size).to eq(4)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])
    expect(model.vertices.size).to eq(7)
    expect(wire1.vertices.size).to eq(5)
    expect(wire2.vertices.size).to eq(4)

    edges_1_2 = face1.shared_outer_edges(face2)
    edges_2_1 = face2.shared_outer_edges(face1)
    expect(edges_1_2.size).to eq(1)
    expect(edges_2_1.size).to eq(1)
    expect(edges_1_2[0].id).to eq(edges_2_1[0].id)
    expect(edges_1_2[0].length).to eq(10)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 0, 0))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])
    expect(model.vertices.size).to eq(8)
    expect(wire1.vertices.size).to eq(5)
    expect(wire2.vertices.size).to eq(4)
    expect(wire3.vertices.size).to eq(4)

    edges_1_3 = face1.shared_outer_edges(face3)
    edges_3_1 = face3.shared_outer_edges(face1)
    expect(edges_1_3.size).to eq(1)
    expect(edges_3_1.size).to eq(1)
    expect(edges_1_3[0].id).to eq(edges_3_1[0].id)
    expect(edges_1_3[0].length).to eq(10)

    edges_2_3 = face2.shared_outer_edges(face3)
    edges_3_2 = face3.shared_outer_edges(face2)
    expect(edges_2_3.size).to eq(1)
    expect(edges_3_2.size).to eq(1)
    expect(edges_2_3[0].id).to eq(edges_3_2[0].id)
    expect(edges_2_3[0].length).to eq(10)
  end

  it "can build model for face order case 3" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])
    expect(model.vertices.size).to eq(4)
    expect(wire1.vertices.size).to eq(4)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])
    expect(model.vertices.size).to eq(7)
    expect(wire1.vertices.size).to eq(5)
    expect(wire2.vertices.size).to eq(4)

    edges_1_2 = face1.shared_outer_edges(face2)
    edges_2_1 = face2.shared_outer_edges(face1)
    expect(edges_1_2.size).to eq(1)
    expect(edges_2_1.size).to eq(1)
    expect(edges_1_2[0].id).to eq(edges_2_1[0].id)
    expect(edges_1_2[0].length).to eq(10)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])
    expect(model.vertices.size).to eq(8)
    expect(wire1.vertices.size).to eq(5)
    expect(wire2.vertices.size).to eq(4)
    expect(wire3.vertices.size).to eq(4)

    edges_1_3 = face1.shared_outer_edges(face3)
    edges_3_1 = face3.shared_outer_edges(face1)
    expect(edges_1_3.size).to eq(1)
    expect(edges_3_1.size).to eq(1)
    expect(edges_1_3[0].id).to eq(edges_3_1[0].id)
    expect(edges_1_3[0].length).to eq(10)

    edges_2_3 = face2.shared_outer_edges(face3)
    edges_3_2 = face3.shared_outer_edges(face2)
    expect(edges_2_3.size).to eq(1)
    expect(edges_3_2.size).to eq(1)
    expect(edges_2_3[0].id).to eq(edges_3_2[0].id)
    expect(edges_2_3[0].length).to eq(10)
  end

  it "can build model for face order case 4" do

    model = Topolys::Model.new

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 10))
    wire1 = model.get_wire(vertices)
    face1 = model.get_face(wire1, [])
    expect(model.vertices.size).to eq(4)
    expect(wire1.vertices.size).to eq(4)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 10))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(10, 10, 10))
    wire2 = model.get_wire(vertices)
    face2 = model.get_face(wire2, [])
    expect(model.vertices.size).to eq(6)
    expect(wire1.vertices.size).to eq(4)
    expect(wire2.vertices.size).to eq(4)

    edges_1_2 = face1.shared_outer_edges(face2)
    edges_2_1 = face2.shared_outer_edges(face1)
    expect(edges_1_2.size).to eq(1)
    expect(edges_2_1.size).to eq(1)
    expect(edges_1_2[0].id).to eq(edges_2_1[0].id)
    expect(edges_1_2[0].length).to eq(10)

    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(20, 10, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(20, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 0, 0))
    vertices << model.get_vertex(Topolys::Point3D.new(0, 10, 0))
    wire3 = model.get_wire(vertices)
    face3 = model.get_face(wire3, [])
    expect(model.vertices.size).to eq(8)
    expect(wire1.vertices.size).to eq(4)
    expect(wire2.vertices.size).to eq(4)
    expect(wire3.vertices.size).to eq(5)

    edges_1_3 = face1.shared_outer_edges(face3)
    edges_3_1 = face3.shared_outer_edges(face1)
    expect(edges_1_3.size).to eq(1)
    expect(edges_3_1.size).to eq(1)
    expect(edges_1_3[0].id).to eq(edges_3_1[0].id)
    expect(edges_1_3[0].length).to eq(10)

    edges_2_3 = face2.shared_outer_edges(face3)
    edges_3_2 = face3.shared_outer_edges(face2)
    expect(edges_2_3.size).to eq(1)
    expect(edges_3_2.size).to eq(1)
    expect(edges_2_3[0].id).to eq(edges_3_2[0].id)
    expect(edges_2_3[0].length).to eq(10)
  end

end # Topolys
