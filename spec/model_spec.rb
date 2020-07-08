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
    
    model.wires.each do |wire|
      expect(wire.parents.size).to eq(0)
      wire.directed_edges.each do |de|
        expect(de.parents.size).to eq(1)
        expect(de.parents.find{|p| p.id == wire.id}).not_to be_nil
      end
    end
    
    model.vertices.each do |vertex|
      expect(vertex.parents.size).to eq(2)
    end
    
    model.edges.each do |edge|
      expect(edge.parents.size).to eq(2)
    end
    
  end
  
  it "has Face class" do
  
    model = Topolys::Model.new
    expect(model.vertices.size).to eq(0)
    expect(model.edges.size).to eq(0)
    expect(model.directed_edges.size).to eq(0)
    expect(model.wires.size).to eq(0)
    expect(model.faces.size).to eq(0)
    
    width = 5
    height = 3
    points = make_rectangle(width, height)
    vertices = model.get_vertices(points)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(0)
    expect(model.directed_edges.size).to eq(0)
    expect(model.wires.size).to eq(0)
    expect(model.faces.size).to eq(0)
    expect(vertices.count(nil)).to eq(0)
    
    outer = model.get_wire(vertices)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(4)
    expect(model.wires.size).to eq(1)
    expect(model.faces.size).to eq(0)
    expect(outer.perimeter).to eq(16)
    
    holes = []
    face = model.get_face(outer, holes)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(4)
    expect(model.wires.size).to eq(1)
    expect(model.faces.size).to eq(1)
    
    reverse_face = model.get_reverse(face)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(8)
    expect(model.wires.size).to eq(2)
    expect(model.faces.size).to eq(2)
    
    reverse_reverse_face = model.get_reverse(reverse_face)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(8)
    expect(model.wires.size).to eq(2)
    expect(model.faces.size).to eq(2)
  end
  
  it "can test Vertex on Edge" do
  
    model = Topolys::Model.new
    expect(model.vertices.size).to eq(0)
    expect(model.edges.size).to eq(0)
    
    v0 = model.get_vertex(Topolys::Point3D.new(0,0,0))
    v1 = model.get_vertex(Topolys::Point3D.new(1,0,0))
    v2 = model.get_vertex(Topolys::Point3D.new(2,0,0))
    v3 = model.get_vertex(Topolys::Point3D.new(3,0,0))
    v4 = model.get_vertex(Topolys::Point3D.new(4,0,0))
    
    edge = model.get_edge(v1,v3)
    expect(model.vertex_intersect_edge?(v0, edge)).to eq(false)
    expect(model.vertex_intersect_edge?(v1, edge)).to eq(false)
    expect(model.vertex_intersect_edge?(v2, edge)).to eq(true)
    expect(model.vertex_intersect_edge?(v3, edge)).to eq(false)
    expect(model.vertex_intersect_edge?(v4, edge)).to eq(false)
    
  end
  
  it "can add Vertex to Edge" do
  
    model = Topolys::Model.new
    expect(model.vertices.size).to eq(0)
    expect(model.edges.size).to eq(0)
    
    v1 = model.get_vertex(Topolys::Point3D.new(1,0,0))
    v2 = model.get_vertex(Topolys::Point3D.new(3,0,0))
    edge1 = model.get_edge(v1,v2)
    expect(edge1.v0.id).to eq(v1.id)
    expect(edge1.v1.id).to eq(v2.id)
    expect(model.edges.size).to eq(1)
    expect(model.edges.size).to eq(1)
    
    v3 = model.get_vertex(Topolys::Point3D.new(0,0,0))
    expect(model.vertices.size).to eq(3)
    expect(model.edges.size).to eq(1)
    
    v4 = model.get_vertex(Topolys::Point3D.new(4,0,0))
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(1)
    
    v5 = model.get_vertex(Topolys::Point3D.new(2,0,0))
    expect(model.vertices.size).to eq(5)
    expect(model.edges.size).to eq(2) 
    expect(edge1.v0.id).to eq(v1.id)
    expect(edge1.v1.id).to eq(v5.id)
    expect(model.edges[0].v0.id).to eq(v1.id)
    expect(model.edges[0].v1.id).to eq(v5.id)
    expect(model.edges[1].v0.id).to eq(v5.id)
    expect(model.edges[1].v1.id).to eq(v2.id)
  end
  
  it "can add Vertex to a Face" do
  
    model = Topolys::Model.new
    expect(model.vertices.size).to eq(0)
    expect(model.edges.size).to eq(0)
    expect(model.directed_edges.size).to eq(0)
    expect(model.wires.size).to eq(0)
    expect(model.faces.size).to eq(0)
    
    width = 5
    height = 3
    points = make_rectangle(width, height)
    vertices = model.get_vertices(points)
    outer = model.get_wire(vertices)
    holes = []
    face = model.get_face(outer, holes)
    reverse_face = model.get_reverse(face)
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(8)
    expect(model.wires.size).to eq(2)
    expect(model.faces.size).to eq(2)
    
    v0 = model.get_vertex(Topolys::Point3D.new(0,0,0))
    v1 = model.get_vertex(Topolys::Point3D.new(5,0,0))
    
    de1 = model.get_directed_edge(v1, v0)
    expect(de1.v0.point.x).to eq(5)
    expect(de1.v0.point.y).to eq(0)
    expect(de1.v0.point.z).to eq(0)
    expect(de1.v1.point.x).to eq(0)
    expect(de1.v1.point.y).to eq(0)
    expect(de1.v1.point.z).to eq(0)    
    
    reverse_de1 = model.get_directed_edge(v0, v1)
    expect(reverse_de1.v1.point.x).to eq(5)
    expect(reverse_de1.v1.point.y).to eq(0)
    expect(reverse_de1.v1.point.z).to eq(0)
    expect(reverse_de1.v0.point.x).to eq(0)
    expect(reverse_de1.v0.point.y).to eq(0)
    expect(reverse_de1.v0.point.z).to eq(0) 
    
    expect(model.vertices.size).to eq(4)
    expect(model.edges.size).to eq(4)
    expect(model.directed_edges.size).to eq(8)
    expect(model.wires.size).to eq(2)
    expect(model.faces.size).to eq(2)
    
    expect(face.outer.directed_edges.size).to eq(4)
    expect(face.outer.perimeter).to eq(16)
    expect(face.outer.directed_edges.find{|x| x.id == de1.id}).not_to be_nil
    
    expect(reverse_face.outer.directed_edges.size).to eq(4)
    expect(reverse_face.outer.perimeter).to eq(16)
    expect(reverse_face.outer.directed_edges.find{|x| x.id == reverse_de1.id}).not_to be_nil
    
    new_vertex = model.get_vertex(Topolys::Point3D.new(2.5,0,0))
    
    expect(face.outer.directed_edges.size).to eq(5)
    expect(face.outer.perimeter).to eq(16)
    expect(face.outer.directed_edges.find{|x| x.id == de1.id}).not_to be_nil
    expect(de1.v0.point.x).to eq(5)
    expect(de1.v0.point.y).to eq(0)
    expect(de1.v0.point.z).to eq(0)
    expect(de1.v1.point.x).to eq(2.5)
    expect(de1.v1.point.y).to eq(0)
    expect(de1.v1.point.z).to eq(0)   
    
    expect(reverse_face.outer.directed_edges.size).to eq(5)
    expect(reverse_face.outer.perimeter).to eq(16)
    expect(reverse_face.outer.directed_edges.find{|x| x.id == reverse_de1.id}).not_to be_nil
    expect(reverse_de1.v1.point.x).to eq(5)
    expect(reverse_de1.v1.point.y).to eq(0)
    expect(reverse_de1.v1.point.z).to eq(0)
    expect(reverse_de1.v0.point.x).to eq(2.5)
    expect(reverse_de1.v0.point.y).to eq(0)
    expect(reverse_de1.v0.point.z).to eq(0) 
    
    new_vertex = model.get_vertex(Topolys::Point3D.new(0,0,0))
    
    expect(face.outer.directed_edges.size).to eq(5)
    expect(face.outer.perimeter).to eq(16)
    expect(face.outer.directed_edges.find{|x| x.id == de1.id}).not_to be_nil
    expect(de1.v0.point.x).to eq(5)
    expect(de1.v0.point.y).to eq(0)
    expect(de1.v0.point.z).to eq(0)
    expect(de1.v1.point.x).to eq(2.5)
    expect(de1.v1.point.y).to eq(0)
    expect(de1.v1.point.z).to eq(0)   
    
    expect(reverse_face.outer.directed_edges.size).to eq(5)
    expect(reverse_face.outer.perimeter).to eq(16)
    expect(reverse_face.outer.directed_edges.find{|x| x.id == reverse_de1.id}).not_to be_nil
    expect(reverse_de1.v1.point.x).to eq(5)
    expect(reverse_de1.v1.point.y).to eq(0)
    expect(reverse_de1.v1.point.z).to eq(0)
    expect(reverse_de1.v0.point.x).to eq(2.5)
    expect(reverse_de1.v0.point.y).to eq(0)
    expect(reverse_de1.v0.point.z).to eq(0) 
    
    new_vertex = model.get_vertex(Topolys::Point3D.new(2.5,2.5,0))
    
    expect(face.outer.directed_edges.size).to eq(5)
    expect(face.outer.perimeter).to eq(16)
    expect(face.outer.directed_edges.find{|x| x.id == de1.id}).not_to be_nil
    expect(de1.v0.point.x).to eq(5)
    expect(de1.v0.point.y).to eq(0)
    expect(de1.v0.point.z).to eq(0)
    expect(de1.v1.point.x).to eq(2.5)
    expect(de1.v1.point.y).to eq(0)
    expect(de1.v1.point.z).to eq(0)   
    
    expect(reverse_face.outer.directed_edges.size).to eq(5)
    expect(reverse_face.outer.perimeter).to eq(16)
    expect(reverse_face.outer.directed_edges.find{|x| x.id == reverse_de1.id}).not_to be_nil
    expect(reverse_de1.v1.point.x).to eq(5)
    expect(reverse_de1.v1.point.y).to eq(0)
    expect(reverse_de1.v1.point.z).to eq(0)
    expect(reverse_de1.v0.point.x).to eq(2.5)
    expect(reverse_de1.v0.point.y).to eq(0)
    expect(reverse_de1.v0.point.z).to eq(0) 
    
  end

  it "has a Shell class" do
  
    model = Topolys::Model.new
    
    width = 1
    height = 3
    points1 = make_rectangle(width, height)
    points2 = move_points(points1, Topolys::Vector3D.new(1,0,0))
    points3 = move_points(points1, Topolys::Vector3D.new(2,0,0))
    
    vertices1 = model.get_vertices(points1)
    vertices2 = model.get_vertices(points2)
    vertices3 = model.get_vertices(points3)
    
    wire1 = model.get_wire(vertices1)
    wire2 = model.get_wire(vertices2)
    wire3 = model.get_wire(vertices3)
    
    face1 = model.get_face(wire1, [])
    face2 = model.get_face(wire2, [])
    face3 = model.get_face(wire3, [])
    
    # TODO: implement
    
    #shell = model.get_shell([face1])
    #expect(shell).not_to be_nil

    #shell = model.get_shell([face1, face2])
    #expect(shell).not_to be_nil
  
    #shell = model.get_shell([face1, face3])
    #expect(shell).to be_nil  
    
    #shell = model.get_shell([face1, face3, face2])
    #expect(shell).not_to be_nil  
  end
  
end # Topolys
