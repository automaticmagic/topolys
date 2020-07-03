require 'topolys'
require 'geometry_helpers'

RSpec.describe Topolys do

  it "has Vertex class" do
  
    p0 = Topolys::Point3D.new(0, 0, 0)
    p1 = Topolys::Point3D.new(1, 1, 1)
    
    model = Topolys::Model.new
    expect(model.vertices.size).to eq(0)
    
    v0 = model.get_vertex(p0)
    expect(v0.is_a?(Topolys::Vertex)).to eq(true)
    expect(model.vertices.size).to eq(1)
    
    v1 = model.get_vertex(p0)
    expect(v1.is_a?(Topolys::Vertex)).to eq(true)
    expect(model.vertices.size).to eq(1)
    expect(v0.id == v1.id)
    
    v2 = model.get_vertex(p1)
    expect(v2.is_a?(Topolys::Vertex)).to eq(true)
    expect(model.vertices.size).to eq(2)
    expect(v2.id != v1.id)
    
  end
  
  it "has DirectedEdge class" do
  
    p0 = Topolys::Point3D.new(0, 0, 0)
    p1 = Topolys::Point3D.new(1, 1, 1)
    
    model = Topolys::Model.new
    expect(model.edges.size).to eq(0)
    expect(model.directed_edges.size).to eq(0)
    
    v0 = model.get_vertex(p0)
    expect(v0.parents.size).to eq(0)
    
    v1 = model.get_vertex(p1)
    expect(v1.parents.size).to eq(0)
    
    de0 = model.get_directed_edge(v0, v1)
    expect(de0.is_a?(Topolys::DirectedEdge)).to eq(true)
    expect(model.edges.size).to eq(1)
    expect(model.directed_edges.size).to eq(1)
    expect(de0.v0.id).to eq(v0.id)
    expect(de0.v0.id).to_not eq(v1.id)
    expect(de0.v1.id).to_not eq(v0.id)
    expect(de0.v1.id).to eq(v1.id)
    
    de1 = model.get_directed_edge(v1, v0)
    expect(de1.is_a?(Topolys::DirectedEdge)).to eq(true)
    expect(model.edges.size).to eq(1)
    expect(model.directed_edges.size).to eq(2)
    expect(de1.v0.id).to eq(v1.id)
    expect(de1.v0.id).to_not eq(v0.id)
    expect(de1.v1.id).to_not eq(v1.id)
    expect(de1.v1.id).to eq(v0.id)
    
    de2 = model.get_directed_edge(v1, v0)
    expect(de2.is_a?(Topolys::DirectedEdge)).to eq(true)
    expect(model.edges.size).to eq(1)
    expect(model.directed_edges.size).to eq(2)
    expect(de1.v0.id).to eq(v1.id)
    expect(de1.v0.id).to_not eq(v0.id)
    expect(de1.v1.id).to_not eq(v1.id)
    expect(de1.v1.id).to eq(v0.id)
    
    expect(v0.parents.size).to eq(1)
    expect(v1.parents.size).to eq(1)
    
    e0 = v0.parents.first
    expect(e0.is_a?(Topolys::Edge)).to eq(true)
    
    e1 = v1.parents.first
    expect(e1.is_a?(Topolys::Edge)).to eq(true)
    
    expect(e0.id).to eq(e1.id)
    expect(e0.parents.size).to eq(2)
    expect(e0.parents[0].id).to eq(de0.id)
    expect(e0.parents[1].id).to eq(de1.id)
  end
  
  it "has Wire class" do
    
    model = Topolys::Model.new
    expect(model.vertices.size).to eq(0)
    expect(model.edges.size).to eq(0)
    expect(model.directed_edges.size).to eq(0)
    expect(model.wires.size).to eq(0)
    
    width = 5
    height = 3
    points = make_rectangle(width, height)
    vertices = model.get_vertices(points)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(0)
    expect(model.directed_edges.size).to eq(0)
    expect(model.wires.size).to eq(0)
    expect(vertices.count(nil)).to eq(0)
    
    wire1 = model.get_wire(vertices)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(4)
    expect(model.wires.size).to eq(1)
    expect(wire1.perimeter).to eq(16)
    
    wire2 = model.get_wire(vertices)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(4)
    expect(model.wires.size).to eq(1)
    expect(wire2.id).to eq(wire1.id)
    expect(wire2.perimeter).to eq(16)
    
    wire3 = model.get_wire(vertices.reverse)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(8)
    expect(model.wires.size).to eq(2)
    expect(wire3.id).not_to eq(wire1.id)
    expect(wire3.perimeter).to eq(16)
    
    wire4 = model.get_wire(vertices.reverse)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(8)
    expect(model.wires.size).to eq(2)
    expect(wire4.id).to eq(wire3.id)
    expect(wire4.perimeter).to eq(16)
  end
  
  it "has Face class" do
  
  end
  
  
end # Topolys
