require 'topolys'
require 'geometry_helpers'
require "json-schema"

# test geometry for this model taken from https://github.com/rd2/tbd under MIT license
def scrigno_surfaces
  surfaces = []

  # building shading surfaces
  # (4x above gallery roof + 2x North/South balconies)
  points = []
  points << Topolys::Point3D.new(12.4, 45.0, 50.0)
  points << Topolys::Point3D.new(12.4, 25.0, 50.0)
  points << Topolys::Point3D.new(22.7, 25.0, 50.0)
  points << Topolys::Point3D.new(22.7, 45.0, 50.0)
  surfaces << {name: 'r1_shade', type: 'shade', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(22.7, 45.0, 50.0)
  points << Topolys::Point3D.new(22.7, 37.5, 50.0)
  points << Topolys::Point3D.new(48.7, 37.5, 50.0)
  points << Topolys::Point3D.new(48.7, 45.0, 50.0)
  surfaces << {name: 'r2_shade', type: 'shade', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(22.7, 32.5, 50.0)
  points << Topolys::Point3D.new(22.7, 25.0, 50.0)
  points << Topolys::Point3D.new(48.7, 25.0, 50.0)
  points << Topolys::Point3D.new(48.7, 32.5, 50.0)
  surfaces << {name: 'r3_shade', type: 'shade', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(48.7, 45.0, 50.0)
  points << Topolys::Point3D.new(48.7, 25.0, 50.0)
  points << Topolys::Point3D.new(59.0, 25.0, 50.0)
  points << Topolys::Point3D.new(59.0, 45.0, 50.0)
  surfaces << {name: 'r4_shade', type: 'shade', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(47.4, 40.2, 44.0)
  points << Topolys::Point3D.new(47.4, 41.7, 44.0)
  points << Topolys::Point3D.new(45.7, 41.7, 44.0)
  points << Topolys::Point3D.new(45.7, 40.2, 44.0)
  surfaces << {name: 'N_balcony', type: 'shade', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(28.1, 29.8, 44.0)
  points << Topolys::Point3D.new(28.1, 28.3, 44.0)
  points << Topolys::Point3D.new(47.4, 28.3, 44.0)
  points << Topolys::Point3D.new(47.4, 29.8, 44.0)
  surfaces << {name: 'S_balcony', type: 'shade', points: points, holes: []}

  # 1st space: gallery (g) with elevator (e) surfaces

  points = []
  points << Topolys::Point3D.new(17.4, 40.2, 49.5)
  points << Topolys::Point3D.new(17.4, 40.2, 44.0)
  points << Topolys::Point3D.new(17.4, 29.8, 44.0)
  points << Topolys::Point3D.new(17.4, 29.8, 49.5)
  surfaces << {name: 'g_W_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(54.0, 40.2, 49.5)
  points << Topolys::Point3D.new(54.0, 40.2, 44.0)
  points << Topolys::Point3D.new(17.4, 40.2, 44.0)
  points << Topolys::Point3D.new(17.4, 40.2, 49.5)
  door = {points: []}
  door[:points] << Topolys::Point3D.new(47.4, 40.2, 46.0)
  door[:points] << Topolys::Point3D.new(47.4, 40.2, 44.0)
  door[:points] << Topolys::Point3D.new(46.4, 40.2, 44.0)
  door[:points] << Topolys::Point3D.new(46.4, 40.2, 46.0)
  surfaces << {name: 'g_N_wall', type: 'wall', points: points, holes: [door]}

  points = []
  points << Topolys::Point3D.new(54.0, 29.8, 49.5)
  points << Topolys::Point3D.new(54.0, 29.8, 44.0)
  points << Topolys::Point3D.new(54.0, 40.2, 44.0)
  points << Topolys::Point3D.new(54.0, 40.2, 49.5)
  surfaces << {name: 'g_E_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(17.4, 29.8, 49.5)
  points << Topolys::Point3D.new(17.4, 29.8, 44.0)
  points << Topolys::Point3D.new(24.0, 29.8, 44.0)
  points << Topolys::Point3D.new(24.0, 29.8, 46.7)
  points << Topolys::Point3D.new(24.0, 29.8, 46.7)
  points << Topolys::Point3D.new(28.0, 29.8, 46.7)
  points << Topolys::Point3D.new(28.0, 29.8, 44.0)
  points << Topolys::Point3D.new(54.0, 29.8, 44.0)
  points << Topolys::Point3D.new(54.0, 29.8, 49.5)
  door = {points: []}
  door[:points] << Topolys::Point3D.new(46.4, 29.8, 46.0)
  door[:points] << Topolys::Point3D.new(46.4, 29.8, 44.0)
  door[:points] << Topolys::Point3D.new(47.4, 29.8, 44.0)
  door[:points] << Topolys::Point3D.new(47.4, 29.8, 46.0)
  surfaces << {name: 'g_S_wall', type: 'wall', points: points, holes: [door]}

  points = []
  points << Topolys::Point3D.new(17.4, 40.2, 49.5)
  points << Topolys::Point3D.new(17.4, 29.8, 49.5)
  points << Topolys::Point3D.new(54.0, 29.8, 49.5)
  points << Topolys::Point3D.new(54.0, 40.2, 49.5)
  skylight = {points: []}
  skylight[:points] << Topolys::Point3D.new(17.4, 40.2, 49.5)
  skylight[:points] << Topolys::Point3D.new(17.4, 29.8, 49.5)
  skylight[:points] << Topolys::Point3D.new(54.0, 29.8, 49.5)
  skylight[:points] << Topolys::Point3D.new(54.0, 40.2, 49.5)
  surfaces << {name: 'g_top', type: 'ceiling', points: points, holes: [skylight]}

  points = []
  points << Topolys::Point3D.new(24.0, 29.8, 46.7)
  points << Topolys::Point3D.new(24.0, 28.3, 46.7)
  points << Topolys::Point3D.new(28.0, 28.3, 46.7)
  points << Topolys::Point3D.new(28.0, 29.8, 46.7)
  surfaces << {name: 'e_top', type: 'ceiling', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 28.3, 40.8)
  points << Topolys::Point3D.new(24.0, 29.8, 40.8)
  points << Topolys::Point3D.new(28.0, 29.8, 40.8)
  points << Topolys::Point3D.new(28.0, 28.3, 40.8)
  surfaces << {name: 'e_floor', type: 'floor', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 29.8, 46.7)
  points << Topolys::Point3D.new(24.0, 29.8, 40.8)
  points << Topolys::Point3D.new(24.0, 28.3, 40.8)
  points << Topolys::Point3D.new(24.0, 28.3, 46.7)
  surfaces << {name: 'e_W_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 28.3, 46.7)
  points << Topolys::Point3D.new(24.0, 28.3, 40.8)
  points << Topolys::Point3D.new(28.0, 28.3, 40.8)
  points << Topolys::Point3D.new(28.0, 28.3, 46.7)
  surfaces << {name: 'e_S_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(28.0, 28.3, 46.7)
  points << Topolys::Point3D.new(28.0, 28.3, 40.8)
  points << Topolys::Point3D.new(28.0, 29.8, 40.8)
  points << Topolys::Point3D.new(28.0, 29.8, 46.7)
  surfaces << {name: 'e_E_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(28.0, 29.8, 42.4)
  points << Topolys::Point3D.new(28.0, 29.8, 40.8)
  points << Topolys::Point3D.new(24.0, 29.8, 40.8)
  points << Topolys::Point3D.new(24.0, 29.8, 43.0)
  surfaces << {name: 'e_N_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(28.0, 29.8, 44.0)
  points << Topolys::Point3D.new(28.0, 29.8, 42.4)
  points << Topolys::Point3D.new(24.0, 29.8, 43.0)
  points << Topolys::Point3D.new(24.0, 29.8, 44.0)
  surfaces << {name: 'e_p_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(17.4, 29.8, 44.0)
  points << Topolys::Point3D.new(17.4, 40.2, 44.0)
  points << Topolys::Point3D.new(54.0, 40.2, 44.0)
  points << Topolys::Point3D.new(54.0, 29.8, 44.0)
  surfaces << {name: 'g_floor', type: 'floor', points: points, holes: []}

  # 2nd space: plenum (p) with stairwell (s) surfaces

  points = []
  points << Topolys::Point3D.new(17.4, 40.2, 44.0)
  points << Topolys::Point3D.new(17.4, 29.8, 44.0)
  points << Topolys::Point3D.new(54.0, 29.8, 44.0)
  points << Topolys::Point3D.new(54.0, 40.2, 44.0)
  surfaces << {name: 'p_top', type: 'ceiling', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 29.8, 44.0)
  points << Topolys::Point3D.new(24.0, 29.8, 43.0)
  points << Topolys::Point3D.new(28.0, 29.8, 42.4)
  points << Topolys::Point3D.new(28.0, 29.8, 44.0)
  surfaces << {name: 'p_e_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(17.4, 29.8, 44.0)
  points << Topolys::Point3D.new(24.0, 29.8, 43.0)
  points << Topolys::Point3D.new(24.0, 29.8, 44.0)
  surfaces << {name: 'p_S1_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(28.0, 29.8, 44.0)
  points << Topolys::Point3D.new(28.0, 29.8, 42.4)
  points << Topolys::Point3D.new(30.7, 29.8, 42.0)
  points << Topolys::Point3D.new(40.7, 29.8, 42.0)
  points << Topolys::Point3D.new(54.0, 29.8, 44.0)
  surfaces << {name: 'p_S2_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(54.0, 40.2, 44.0)
  points << Topolys::Point3D.new(40.7, 40.2, 42.0)
  points << Topolys::Point3D.new(30.7, 40.2, 42.0)
  points << Topolys::Point3D.new(17.4, 40.2, 44.0)
  surfaces << {name: 'p_N_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(30.7, 29.8, 42.0)
  points << Topolys::Point3D.new(30.7, 40.2, 42.0)
  points << Topolys::Point3D.new(40.7, 40.2, 42.0)
  points << Topolys::Point3D.new(40.7, 29.8, 42.0)
  surfaces << {name: 'p_floor', type: 'floor', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(40.7, 29.8, 42.0)
  points << Topolys::Point3D.new(40.7, 40.2, 42.0)
  points << Topolys::Point3D.new(54.0, 40.2, 44.0)
  points << Topolys::Point3D.new(54.0, 29.8, 44.0)
  surfaces << {name: 'p_E_floor', type: 'floor', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(17.4, 29.8, 44.0)
  points << Topolys::Point3D.new(17.4, 40.2, 44.0)
  points << Topolys::Point3D.new(24.0, 40.2, 43.0)
  points << Topolys::Point3D.new(24.0, 29.8, 43.0)
  surfaces << {name: 'p_W1_floor', type: 'floor', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 29.8, 43.00)
  points << Topolys::Point3D.new(24.0, 33.1, 43.00)
  points << Topolys::Point3D.new(29.0, 33.1, 42.26)
  points << Topolys::Point3D.new(29.0, 36.9, 42.26)
  points << Topolys::Point3D.new(24.0, 36.9, 43.00)
  points << Topolys::Point3D.new(24.0, 40.2, 43.00)
  points << Topolys::Point3D.new(30.7, 40.2, 42.00)
  points << Topolys::Point3D.new(30.7, 29.8, 42.00)
  surfaces << {name: 'p_W2_floor', type: 'floor', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 36.9, 43.0)
  points << Topolys::Point3D.new(24.0, 36.9, 40.8)
  points << Topolys::Point3D.new(24.0, 33.1, 40.8)
  points << Topolys::Point3D.new(24.0, 33.1, 43.0)
  surfaces << {name: 's_W_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(29.0, 36.9, 42.26)
  points << Topolys::Point3D.new(29.0, 36.9, 40.80)
  points << Topolys::Point3D.new(24.0, 36.9, 40.80)
  points << Topolys::Point3D.new(24.0, 36.9, 43.00)
  surfaces << {name: 's_N_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(29.0, 33.1, 42.26)
  points << Topolys::Point3D.new(29.0, 33.1, 40.80)
  points << Topolys::Point3D.new(29.0, 36.9, 40.80)
  points << Topolys::Point3D.new(29.0, 36.9, 42.26)
  surfaces << {name: 's_E_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 33.1, 43.00)
  points << Topolys::Point3D.new(24.0, 33.1, 40.80)
  points << Topolys::Point3D.new(29.0, 33.1, 40.80)
  points << Topolys::Point3D.new(29.0, 33.1, 42.26)
  surfaces << {name: 's_S_wall', type: 'wall', points: points, holes: []}

  points = []
  points << Topolys::Point3D.new(24.0, 33.1, 40.8)
  points << Topolys::Point3D.new(24.0, 36.9, 40.8)
  points << Topolys::Point3D.new(29.0, 36.9, 40.8)
  points << Topolys::Point3D.new(29.0, 33.1, 40.8)
  surfaces << {name: 's_floor', type: 'floor', points: points, holes: []}

  # add bounding boxes
  surfaces.each do |surface|
    surface[:bb] = Topolys::BoundingBox.new
    surface[:points].each {|p| surface[:bb].add_point(p)}
  end

  return surfaces
end

def create_face(surface, model)

  vertices = []
  surface[:points].each do |point|
    vertices << model.get_vertex(point)
  end
  outer = model.get_wire(vertices)

  holes = []
  surface[:holes].each do |hole|
    vertices = []
    hole[:points].each do |point|
      vertices << model.get_vertex(point)
    end
    holes << model.get_wire(vertices)
  end

  face = model.get_face(outer, holes)
  face.attributes[:name] = surface[:name]
  face.attributes[:type] = surface[:type]

  return face
end

def default_sort(s1, s2)

  type_order = {floor: 1, ceiling: 2, wall: 3, shade: 4}

  if s1[:type] != s2[:type]
    return type_order[s1[:type].to_sym] <=> type_order[s2[:type].to_sym]
  end

  if s1[:bb].minz != s2[:bb].minz
    return s1[:bb].minz <=> s2[:bb].minz
  end

  if s1[:bb].miny != s2[:bb].miny
    return s1[:bb].miny <=> s2[:bb].miny
  end

  if s1[:bb].minx != s2[:bb].minx
    return s1[:bb].minx <=> s2[:bb].minx
  end

  return s1[:name] <=> s1[:name]
end

RSpec.describe Topolys do

  it "can create scrigno model" do

    model = Topolys::Model.new

    surfaces = scrigno_surfaces
    surfaces.sort! {|s1, s2| default_sort(s1, s2)}
    surfaces.each do |surface|
      create_face(surface, model)
    end

    # look for some problem vertices
    v1 = model.find_existing_vertex(Topolys::Point3D.new(17.4,29.8,44.0))
    v2 = model.find_existing_vertex(Topolys::Point3D.new(24,29.8,44.0))
    v3 = model.find_existing_vertex(Topolys::Point3D.new(28,29.8,44.0))
    v4 = model.find_existing_vertex(Topolys::Point3D.new(28.1,29.8,44.0))

    expect(v1).to be_truthy
    expect(v2).to be_truthy
    expect(v3).to be_truthy
    expect(v4).to be_truthy

    expect(v3.id).not_to eq(v4.id)

    # 1) there should be existing edges between v1<->v2 (e1) and v2<->v3 (e2), should not be one v1<->v3 (e3)
    expect(model.find_existing_edge(v1,v2)).to be_truthy
    expect(model.find_existing_edge(v2,v3)).to be_truthy
    expect(model.find_existing_edge(v3,v4)).to be_truthy
    expect(model.find_existing_edge(v1,v3).nil?).to be_truthy # DLM: this fails
    expect(model.find_existing_edge(v1,v4).nil?).to be_truthy # DLM: this fails

    # 2) the following surfaces should all share an edge
    p_S2_wall_face = model.faces.find{|face| face.attributes[:name] == 'p_S2_wall'}
    e_p_wall_face = model.faces.find{|face| face.attributes[:name] == 'e_p_wall'}
    p_e_wall_face = model.faces.find{|face| face.attributes[:name] == 'p_e_wall'}
    e_E_wall_face = model.faces.find{|face| face.attributes[:name] == 'e_E_wall'}

    expect(p_S2_wall_face).to be_truthy
    expect(e_p_wall_face).to be_truthy
    expect(p_e_wall_face).to be_truthy
    expect(e_E_wall_face).to be_truthy

    p_S2_wall_edge_ids = Set.new(p_S2_wall_face.outer.edges.map{|oe| oe.id})
    e_p_wall_edges_ids = Set.new(e_p_wall_face.outer.edges.map{|oe| oe.id})
    p_e_wall_edges_ids = Set.new(p_e_wall_face.outer.edges.map{|oe| oe.id})
    e_E_wall_edges_ids = Set.new(e_E_wall_face.outer.edges.map{|oe| oe.id})

    intersection = p_S2_wall_edge_ids & e_p_wall_edges_ids & p_e_wall_edges_ids & e_E_wall_edges_ids
    expect(intersection.size).to eq 1 # DLM: this fails

    intersection = p_S2_wall_edge_ids & e_p_wall_edges_ids & p_e_wall_edges_ids
    expect(intersection.size).to eq 1

    shared_edges = p_S2_wall_face.shared_outer_edges(e_p_wall_face)
    expect(shared_edges.size).to eq 1
    expect(shared_edges.first.id).to eq intersection.to_a.first

    shared_edges = p_S2_wall_face.shared_outer_edges(p_e_wall_face)
    expect(shared_edges.size).to eq 1
    expect(shared_edges.first.id).to eq intersection.to_a.first

    shared_edges = p_S2_wall_face.shared_outer_edges(e_E_wall_face)
    expect(shared_edges.size).to eq 1 # DLM: this fails
    expect(shared_edges.first.id).to eq intersection.to_a.first # DLM: this fails

    # 3) g_floor and p_top should be connected with all edges shared
    g_floor_face = model.faces.find {|face| face.attributes[:name] == 'g_floor'}
    expect(g_floor_face).to be_truthy
    g_floor_wire = g_floor_face.outer
    g_floor_edges = g_floor_wire.edges
    p_top_face = model.faces.find {|face| face.attributes[:name] == 'p_top'}
    p_top_wire = p_top_face.outer
    p_top_edges = p_top_wire.edges
    shared_edges = p_top_face.shared_outer_edges(g_floor_face)

    expect(g_floor_edges.size).to be > 4
    expect(g_floor_edges.size).to eq(p_top_edges.size)
    expect(shared_edges.size).to eq(p_top_edges.size)
    g_floor_edges.each do |g_floor_edge|
      p_top_edge = p_top_edges.find{|e| e.id == g_floor_edge.id}
      expect(p_top_edge).to be_truthy
    end

  end

end # Topolys
