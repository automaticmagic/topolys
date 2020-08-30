require 'topolys'
require 'geometry_helpers'
require "json-schema"

RSpec.describe Topolys do

  it "can connect g_floor, p_top, g_S_wall, e_W_wall" do

    model = Topolys::Model.new

    # make the floor
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,40.2,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(47.4,40.2,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,44.0))
    g_floor_wire = model.get_wire(vertices)
    g_floor_face = model.get_face(g_floor_wire, [])

    expect(g_floor_wire.vertices.size).to eq 4

    v1 = model.find_existing_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    v2 = model.find_existing_vertex(Topolys::Point3D.new(24,29.8,44.0))
    v3 = model.find_existing_vertex(Topolys::Point3D.new(28,29.8,44.0))

    expect(v1).to be_truthy
    expect(v2).to be_falsey
    expect(v3).to be_falsey

    # make the ceiling
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,40.2,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(47.4,40.2,44.0))
    p_top_wire = model.get_wire(vertices)
    p_top_face = model.get_face(p_top_wire, [])

    expect(g_floor_wire.vertices.size).to eq 4
    expect(p_top_wire.vertices.size).to eq 4

    v1 = model.find_existing_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    v2 = model.find_existing_vertex(Topolys::Point3D.new(24,29.8,44.0))
    v3 = model.find_existing_vertex(Topolys::Point3D.new(28,29.8,44.0))

    expect(v1).to be_truthy
    expect(v2).to be_falsey
    expect(v3).to be_falsey

    # insert v3 point, breaks the ceiling and floor wires
    model.get_vertex(Topolys::Point3D.new(28,29.8,44.0))

    v1 = model.find_existing_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    v2 = model.find_existing_vertex(Topolys::Point3D.new(24,29.8,44.0))
    v3 = model.find_existing_vertex(Topolys::Point3D.new(28,29.8,44.0))

    expect(v1).to be_truthy
    expect(v2).to be_falsey
    expect(v3).to be_truthy

    expect(g_floor_wire.vertices.size).to eq 5
    expect(p_top_wire.vertices.size).to eq 5
    expect(model.find_existing_edge(v1,v3)).to be_truthy

    # make the wall
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,49.5))
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,46.7))
    vertices << model.get_vertex(Topolys::Point3D.new(28.0,29.8,46.7))
    vertices << model.get_vertex(Topolys::Point3D.new(28.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(28.1,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(46.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(47.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,49.5))
    g_S_wall_wire = model.get_wire(vertices)
    g_S_wall_face = model.get_face(g_S_wall_wire, [])

    expect(g_floor_wire.vertices.size).to eq 9
    expect(p_top_wire.vertices.size).to eq 9
    expect(g_S_wall_wire.vertices.size).to eq 11

    v1 = model.find_existing_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    v2 = model.find_existing_vertex(Topolys::Point3D.new(24,29.8,44.0))
    v3 = model.find_existing_vertex(Topolys::Point3D.new(28,29.8,44.0))

    expect(v1).to be_truthy
    expect(v2).to be_truthy
    expect(v3).to be_truthy

    # there should be existing edges between v1<->v2 (e1) and v2<->v3 (e2), should not be one v1<->v3 (e3)
    expect(model.find_existing_edge(v1,v2)).to be_truthy
    expect(model.find_existing_edge(v2,v3)).to be_truthy
    expect(model.find_existing_edge(v1,v3)).to be_falsey

    # make the other wall
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,46.7))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,43.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,40.8))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,28.3,40.8))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,28.3,46.7))
    e_W_wall_wire = model.get_wire(vertices)
    e_W_wall_face = model.get_face(e_W_wall_wire, [])

    expect(model.find_existing_edge(v1,v2)).to be_truthy
    expect(model.find_existing_edge(v2,v3)).to be_truthy
    expect(model.find_existing_edge(v1,v3)).to be_falsey

    # create sets for easy intersections
    g_floor_edge_ids = Set.new(g_floor_face.outer.edges.map{|oe| oe.id})
    p_top_edge_ids = Set.new(p_top_face.outer.edges.map{|oe| oe.id})
    g_S_wall_edges_ids = Set.new(g_S_wall_face.outer.edges.map{|oe| oe.id})
    e_W_wall_edges_ids = Set.new(e_W_wall_face.outer.edges.map{|oe| oe.id})

    # g_S_wall and e_W_wall
    intersection = g_S_wall_edges_ids & e_W_wall_edges_ids
    expect(intersection.size).to eq 1

    shared_edges = g_S_wall_face.shared_outer_edges(e_W_wall_face)
    expect(shared_edges.size).to eq 1
    expect(shared_edges[0].length).to be_within(0.01).of(2.7)

    # g_floor and g_S_wall
    intersection = g_floor_edge_ids & g_S_wall_edges_ids
    expect(intersection.size).to eq 5

    shared_edges = g_floor_face.shared_outer_edges(g_S_wall_face)
    expect(shared_edges.size).to eq 5
    length = 0
    shared_edges.each { |e| length+=e.length }
    expect(length).to be_within(0.01).of(32.6)

    # p_top and g_S_wall
    intersection = p_top_edge_ids & g_S_wall_edges_ids
    expect(intersection.size).to eq 5

    shared_edges = p_top_face.shared_outer_edges(g_S_wall_face)
    expect(shared_edges.size).to eq 5
    length = 0
    shared_edges.each { |e| length+=e.length }
    expect(length).to be_within(0.01).of(32.6)

    # p_top and g_floor and g_S_wall
    intersection = p_top_edge_ids & g_floor_edge_ids & g_S_wall_edges_ids
    expect(intersection.size).to eq 5

  end

  it "can connect g_floor, p_top, g_S_wall, e_W_wall - reverse" do

    model = Topolys::Model.new

    # make the wall
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,49.5))
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,46.7))
    vertices << model.get_vertex(Topolys::Point3D.new(28.0,29.8,46.7))
    vertices << model.get_vertex(Topolys::Point3D.new(28.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(28.1,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(46.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(47.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,49.5))
    g_S_wall_wire = model.get_wire(vertices)
    g_S_wall_face = model.get_face(g_S_wall_wire, [])

    expect(g_S_wall_wire.vertices.size).to eq 11

    v1 = model.find_existing_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    v2 = model.find_existing_vertex(Topolys::Point3D.new(24,29.8,44.0))
    v3 = model.find_existing_vertex(Topolys::Point3D.new(28,29.8,44.0))

    expect(v1).to be_truthy
    expect(v2).to be_truthy
    expect(v3).to be_truthy

    # there should be existing edges between v1<->v2 (e1), should not be one v2<->v3 (e2) or v1<->v3 (e3)
    expect(model.find_existing_edge(v1,v2)).to be_truthy
    expect(model.find_existing_edge(v2,v3)).to be_falsey
    expect(model.find_existing_edge(v1,v3)).to be_falsey

    # make the other wall
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,46.7))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,43.0))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,29.8,40.8))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,28.3,40.8))
    vertices << model.get_vertex(Topolys::Point3D.new(24.0,28.3,46.7))
    e_W_wall_wire = model.get_wire(vertices)
    e_W_wall_face = model.get_face(e_W_wall_wire, [])

    expect(model.find_existing_edge(v1,v2)).to be_truthy
    expect(model.find_existing_edge(v2,v3)).to be_falsey
    expect(model.find_existing_edge(v1,v3)).to be_falsey

    # make the floor
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,40.2,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(47.4,40.2,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,44.0))
    g_floor_wire = model.get_wire(vertices)
    g_floor_face = model.get_face(g_floor_wire, [])

    expect(g_S_wall_wire.vertices.size).to eq 11
    expect(g_floor_wire.vertices.size).to eq 9

    # now v2<->v3 (e2) exists
    expect(model.find_existing_edge(v1,v2)).to be_truthy
    expect(model.find_existing_edge(v2,v3)).to be_truthy
    expect(model.find_existing_edge(v1,v3)).to be_falsey

    # make the ceiling
    vertices = []
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,40.2,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(54.0,29.8,44.0))
    vertices << model.get_vertex(Topolys::Point3D.new(47.4,40.2,44.0))
    p_top_wire = model.get_wire(vertices)
    p_top_face = model.get_face(p_top_wire, [])

    expect(g_S_wall_wire.vertices.size).to eq 11
    expect(g_floor_wire.vertices.size).to eq 9
    expect(p_top_wire.vertices.size).to eq 9

    expect(model.find_existing_edge(v1,v2)).to be_truthy
    expect(model.find_existing_edge(v2,v3)).to be_truthy
    expect(model.find_existing_edge(v1,v3)).to be_falsey

    # create sets for easy intersections
    g_floor_edge_ids = Set.new(g_floor_face.outer.edges.map{|oe| oe.id})
    p_top_edge_ids = Set.new(p_top_face.outer.edges.map{|oe| oe.id})
    g_S_wall_edges_ids = Set.new(g_S_wall_face.outer.edges.map{|oe| oe.id})
    e_W_wall_edges_ids = Set.new(e_W_wall_face.outer.edges.map{|oe| oe.id})

    # g_S_wall and e_W_wall
    intersection = g_S_wall_edges_ids & e_W_wall_edges_ids
    expect(intersection.size).to eq 1

    shared_edges = g_S_wall_face.shared_outer_edges(e_W_wall_face)
    expect(shared_edges.size).to eq 1
    expect(shared_edges[0].length).to be_within(0.01).of(2.7)

    # g_floor and g_S_wall
    intersection = g_floor_edge_ids & g_S_wall_edges_ids
    expect(intersection.size).to eq 5

    shared_edges = g_floor_face.shared_outer_edges(g_S_wall_face)
    expect(shared_edges.size).to eq 5
    length = 0
    shared_edges.each { |e| length+=e.length }
    expect(length).to be_within(0.01).of(32.6)

    # p_top and g_S_wall
    intersection = p_top_edge_ids & g_S_wall_edges_ids
    expect(intersection.size).to eq 5

    shared_edges = p_top_face.shared_outer_edges(g_S_wall_face)
    expect(shared_edges.size).to eq 5
    length = 0
    shared_edges.each { |e| length+=e.length }
    expect(length).to be_within(0.01).of(32.6)

    # p_top and g_floor and g_S_wall
    intersection = p_top_edge_ids & g_floor_edge_ids & g_S_wall_edges_ids
    expect(intersection.size).to eq 5

  end

end # Topolys
