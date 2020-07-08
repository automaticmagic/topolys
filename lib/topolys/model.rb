require "topolys/version"
require 'json'
require 'securerandom'

# Topology represents connections between geometry in a model.
#
# Class structure inspired from Topologic's RCH (Rigorous Class Hierarchy)
#               (excerpts from https://topologic.app/Software/)
# Topology:     Abstract superclass holding constructors, properties and
#               methods used by other subclasses that extend it.
# Vertex:       1D entity equivalent to a geometry point.
# Edge:         1D entity defined by two vertices.
# Wire:         Contiguous collection of Edges where adjacent Edges are
#               connected by shared Vertices.
# Face:         2D region defined by a collection of closed Wires.
# Shell:        Contiguous collection of Faces, where adjacent Faces are
#               connected by shared Edges.
# Cell:         3D region defined by a collection of closed Shells.
# CellComplex:  Contiguous collection of Cells where adjacent Cells are
#               connected by shared Faces.
# Cluster:      Collection of any topologic entities.

# TODO : start integrating warning logs à la raise ...
module Topolys

  ##
  # Checks if one array of objects is the same as another array of objects.
  # The order of objects must be the same but the two arrays may start at different indices.
  #
  # @param [Array] objects1 Array
  # @param [Array] objects2 Array
  #
  # @return [Integer] Returns offset between objects2 and objects1 or nil
  def Topolys.find_offset(objects1, objects2)

    n = objects1.size
    return nil if objects2.size != n
    
    offset = objects2.index{|obj| objects1[0].id == obj.id}
    return nil if !offset
    
    objects1.each_index do |i|
      return nil if objects1[i].id != objects2[(offset+i)%n].id
    end
    
    return offset
  end

  # The Topolys Model contains many Topolys Objects, a Topolys Object can only be
  # connected to other Topolys Objects in the same Topolys Model.  To enforce this
  # Topolys Objects should not be constructed directly, they should be retrieved using
  # the Topolys Model get_* object methods.
  class Model
    attr_reader :vertices, :edges, :directed_edges, :wires, :faces, :shells, :cells
    attr_reader :tol, :tol2
    
    def initialize(tol=nil)
      
      # changing tolerance on a model after construction would be very complicated
      # you would have to go through and regroup points, etc
      if !tol.is_a?(Numeric)
        tol = 0.01
      end
      @tol = tol
      @tol2 = @tol**2

      @vertices = []
      @edges = []
      @directed_edges = []
      @wires = []
      @faces = []
      @shells = []
      @cells = []
    end
    
    # @param [Vertex] vertex
    # @param [Edge] edge
    # @return [Bool] Returns true if vertex lies on edge but is not already a member of the edge
    def vertex_intersect_edge?(vertex, edge)
      return false if vertex.id == edge.v0.id || vertex.id == edge.v1.id
      
      a = (vertex.point-edge.v0.point).magnitude
      b = (vertex.point-edge.v1.point).magnitude
      c = edge.magnitude
      
      if (a + b - c).abs < @tol
        #puts "#{a}, #{b}, #{c}, #{@tol}"
        return true
      end
      
      return false
    end

    # @param [Point3D] point
    # @return [Vertex] Vertex
    def get_vertex(point)
      # search for point and return corresponding vertex if it exists
      # otherwise create new vertex
      @vertices.each do |v|
        p = v.point
        
        ## L1 norm
        #if ((p.x-point.x).abs < @tol) && 
        #    (p.y-point.y).abs < @tol) &&
        #    (p.z-point.z).abs < @tol))
        #  return v
        #end
        
        # L2 norm
        if ((p.x-point.x)**2 + (p.y-point.y)**2 + (p.z-point.z)**2) < @tol2
          return v
        end
      end
      
      v = Vertex.new(point)
      @vertices << v
      
      # check if this vertex needs to be inserted on any edge
      @edges.each do |edge|
        if vertex_intersect_edge?(v, edge)
          insert_vertex_on_edge(v, edge)
        end
      end
      
      return v
    end
    
    # @param [Array] points Array of Point3D
    # @return [Array] Array of Vertex
    def get_vertices(points)
      points.map {|p| get_vertex(p)}
    end
    
    # @param [Vertex] v0
    # @param [Vertex] v1
    # @return [Edge] Edge
    def get_edge(v0, v1)
      # search for edge and return if it exists
      # otherwise create new edge
      
      @edges.each do |e|
        if (e.v0.id == v0.id) && (e.v1.id == v1.id)
          return e
        elsif (e.v0.id == v1.id) && (e.v1.id == v0.id)
          return e
        end
      end
      
      @vertices << v0 if !@vertices.find {|v| v.id == v0.id}
      @vertices << v1 if !@vertices.find {|v| v.id == v1.id}
      edge = Edge.new(v0, v1)
      @edges << edge
      return edge
    end
    
    # @param [Vertex] v0
    # @param [Vertex] v1
    # @return [DirectedEdge] DirectedEdge
    def get_directed_edge(v0, v1)
      # search for directed edge and return if it exists
      # otherwise create new directed edge
      
      @directed_edges.each do |de|
        if (de.v0.id == v0.id) && (de.v1.id == v1.id)
          return de
        end
      end
      
      edge = get_edge(v0, v1)
      
      inverted = false
      if (edge.v0.id != v0.id)
        inverted = true
      end
      
      directed_edge = DirectedEdge.new(edge, inverted)
      @directed_edges << directed_edge
      return directed_edge
    end
    
    # @param [Array] vertices Array of Vertex, assumes closed wire (e.g. first vertex is also last vertex)
    # @return [Wire] Wire
    def get_wire(vertices)
      # search for wire and return if exists 
      # otherwise create new wire
      
      n = vertices.size
      directed_edges = []
      vertices.each_index do |i|
        directed_edges << get_directed_edge(vertices[i], vertices[(i+1)%n])
      end
      
      # see if we already have this wire
      @wires.each do |wire|
        if wire.circular_equal?(directed_edges)
          return wire
        end
      end
      
      wire = Wire.new(directed_edges)
      @wires << wire
      return wire
    end
    
    # @param [Wire] outer Outer wire  
    # @param [Array] holes Array of Wire
    # @return [Face] Face Returns Face or nil if wires are not in model
    def get_face(outer, holes)
      # search for face and return if exists 
      # otherwise create new face
      
      hole_ids = holes.map{|h| h.id}.sort 
      @faces.each do |face|
        if face.outer.id == outer.id
          if face.holes.map{|h| h.id}.sort == hole_ids
            return face
          end
        end
      end

      return nil if @wires.index{|w| w.id == outer.id}.nil?
      holes.each do |hole|
        return nil if @wires.index{|w| w.id == outer.id}.nil?
      end
      
      face = Face.new(outer, holes)
      @faces << face
      return face
    end
    
    # @param [Object] object Object
    # @return [Object] Returns reversed object
    def get_reverse(object)
      if object.is_a?(Vertex)
        return object
      elsif object.is_a?(Edge)
        return object    
      elsif object.is_a?(DirectedEdge)
        return get_directed_edge(object.v1, object.v0)
      elsif object.is_a?(Wire)
        return get_wire(object.vertices.reverse)
      elsif object.is_a?(Face)
        reverse_outer = get_wire(object.outer.vertices.reverse)
        reverse_holes = []
        object.holes.each do |hole|
          reverse_holes << get_wire(hole.vertices.reverse)
        end
        return get_face(reverse_outer, reverse_holes)
      end
      
      return nil
    end
    
    private
    
    ##
    # Projects a vertex to be on an edge
    #
    # @param [Vertex] vertex Vertex to modify
    # @param [Edge] edge Edge to project the vertex to
    def insert_vertex_on_edge(vertex, edge)
      
      vector1 = (edge.v1.point - edge.v0.point)
      vector1.normalize!
      
      vector2 = (vertex.point - edge.v0.point)
      
      length = vector1.dot(vector2)
      new_point = edge.v0.point + (vector1*length)
      
      distance = (vertex.point - new_point).magnitude
      raise "distance = #{distance}" if distance > @tol

      # simulate friend access to set point on vertex
      vertex.instance_variable_set(:@point, new_point) 
      vertex.recalculate
      
      # now split the edge with this vertex
      split_edge(edge, vertex)
    end
    
    ##
    # Adds new vertex between edges's v0 and v1, edge now goes from 
    # v0 to new vertex and a new_edge goes from new vertex to v1. 
    # Updates directed edges which reference edge.
    #
    # @param [Edge] edge Edge to modify
    # @param [Vertex] new_vertex Vertex to add
    def split_edge(edge, new_vertex)
      v1 = edge.v1
      
      # simulate friend access to set v1 on edge
      edge.instance_variable_set(:@v1, new_vertex) 
      edge.recalculate
    
      # make a new edge
      new_edge = get_edge(new_vertex, v1)
      
      # update the directed edges referencing this edge
      edge.parents.each do |directed_edge|
        split_directed_edge(directed_edge, new_edge)
      end
    end
    
    ##
    # Creates a new directed edge in same direction for the new edge.
    # Updates wires which reference directed edge.
    #
    # @param [DirectedEdge] directed_edge Existing directed edge
    # @param [Edge] new_edge New edge
    def split_directed_edge(directed_edge, new_edge)
    
      # directed edge is pointing to the new updated edge but need to recalculate
      # its cached parameters
      directed_edge.recalculate
      
      # make a new directed edge for the new edge
      new_directed_edge = nil
      if directed_edge.inverted
        new_directed_edge = get_directed_edge(new_edge.v1, new_edge.v0)
      else
        new_directed_edge = get_directed_edge(new_edge.v0, new_edge.v1)
      end

      # update the wires referencing this directed edge
      directed_edge.parents.each do |wire|
        split_wire(wire, directed_edge, new_directed_edge)
      end
    end

    ##
    # Inserts new directed edge after directed edge in wire
    #
    # @param [Wire] wire Existing wire
    # @param [DirectedEdge] directed_edge Existing directed edge
    # @param [DirectedEdge] directed_edge New directed edge to insert
    def split_wire(wire, directed_edge, new_directed_edge)
      
      directed_edges = wire.directed_edges
      
      index = directed_edges.index{|de| de.id == directed_edge.id}
      return nil if !index
    
      directed_edges.insert(index + 1, new_directed_edge)
      
      new_directed_edge.link(wire)
      
      # simulate friend access to set directed_edges on wire
      wire.instance_variable_set(:@directed_edges, directed_edges) 
      wire.recalculate
      
      # no need to update faces referencing this wire
    end
    
  end # Model
  
  class Object
    
    # @return [-] attribute linked to a pre-speficied key (e.g. keyword)
    attr_accessor :attributes  # a [k,v] hash of properties required by a parent
                               # app, but of no intrinsic utility to Topolys.
                               # e.g. a thermal bridge PSI type
                               #      "attribute[:bridge] = :balcony
                               # e.g. air leakage crack type (ASHRAE Fund's)
                               #      "attribute[:crack] = :sliding
                               # e.g. LCA $ element type
                               #      "attribute[$lca] = :parapet"
                              
    attr_reader :id
    
    attr_reader :parents

    def initialize
      @attributes = {}
      @id = SecureRandom.uuid
      @parents = []
    end
    
    def hash
      @id
    end
    
    def parent_class
      NilClass
    end
    
    ##
    # Links a parent object
    #
    # @param [Object] object An object to link
    def link(object)
      if object && object.is_a?(parent_class)
        @parents << object if !@parents.find {|obj| obj.id == object.id }
      end
    end

    ##
    # Unlinks a object object
    #
    # @param [Object] object An object to unlink
    def unlink(object)
      @parents.reject!{ |obj| obj.id == object.id }
    end
    
  end # Object

  class Vertex < Object
  
    # @return [Point3D] Point3D geometry
    attr_reader :point

    ##
    # Initializes a Vertex object, use Model.get_point instead
    #
    # Throws if point is incorrect type
    #
    # @param [Point3D] point
    def initialize(point)
      super()
      @point = point
    end
    
    def recalculate
    end
    
    def parent_class
      Edge
    end
    
    def edges
      @parents
    end

  end # Vertex

  class Edge < Object
    # @return [Vertex] the initial vertex, the edge origin
    attr_reader :v0

    # @return [Vertex] the second vertex, the edge terminal point
    attr_reader :v1
    
    # @return [Numeric] the length of this edge
    attr_reader :length
    alias magnitude length
    
    ##
    # Initializes an Edge object, use Model.get_edge instead
    #
    # Throws if v0 or v1 are incorrect type or refer to same vertex
    #
    # @param [Vertex] v0 The origin Vertex
    # @param [Vertex] v1 The terminal Vertex
    def initialize(v0, v1)
      super()
      
      # should catch if 'origin' or 'terminal' not P3D objects ...
      # should also catch if 'origin' or 'terminal' refer to same object
      # ... or are within tol of each other
      @v0 = v0
      @v1 = v1

      @v0.link(self)
      @v1.link(self)
      
      recalculate
    end
    
    def recalculate
      vector = @v1.point - @v0.point
      @length = vector.magnitude
    end
    
    def parent_class
      DirectedEdge
    end
    
    def forward_edge
      @parents.first{|de| !de.inverted}
    end
    
    def reverse_edge
      @parents.first{|de| de.inverted}
    end

  end # Edge
  
  class DirectedEdge < Object
  
    # @return [Vertex] the initial vertex, the directed edge origin
    attr_reader :v0

    # @return [Vertex] the second vertex, the directed edge terminal point
    attr_reader :v1
    
    # @return [Edge] the edge this directed edge points to
    attr_reader :edge

    # @return [Boolean] true if this is a forward directed edge, false otherwise
    attr_reader :inverted
    
    # @return [Numeric] the length of this edge
    attr_reader :length
    
    # @return [Vector3D] the vector of this directed edge
    attr_reader :vector
    
    ##
    # Initializes a DirectedEdge object, use Model.get_directed_edge instead
    #
    # Throws if edge or inverted are incorrect type
    #
    # @param [Edge] edge The underlying edge
    # @param [Boolean] inverted True if this is a forward DirectedEdge, false otherwise
    def initialize(edge, inverted)
      super()
      @edge = edge
      @inverted = inverted
      @edge.link(self)
      
      recalculate
    end
    
    def recalculate
      if inverted
        @v0 = edge.v1
        @v1 = edge.v0
      else
        @v0 = edge.v0
        @v1 = edge.v1
      end
      
      @vector = @v1.point - @v0.point
      @length = @vector.magnitude
    end
    
    def parent_class
      Wire
    end
    
  end # DirectedEdge

  class Wire < Object
  
    # @return [Array] array of directed edges
    attr_reader :directed_edges
    
    # @return [Plane3D] plane of this wire
    attr_reader :plane
    
    # @return [Vector3D] outward normal of this wire's plane
    attr_reader :outward_normal
    
    ##
    # Initializes a Wire object
    #
    # Throws if directed_edges is incorrect type or if not sequential, not planar, or not closed
    #
    # @param [Edge] edge The underlying edge
    # @param [Boolean] inverted True if this is a forward DirectedEdge, false otherwise    
    def initialize(directed_edges) 
      super()
      @directed_edges = directed_edges
      
      raise "Empty edges" if @directed_edges.empty?
      raise "Not sequential" if !sequential?
      raise "Not closed" if !closed?

      @directed_edges.each do |de|
        de.link(self)
      end
      
      recalculate
    end
    
    def recalculate
      @normal = nil
      largest = 0
      @directed_edges.each_index do |i|
        temp = @directed_edges[0].vector.cross(@directed_edges[i].vector)
        if temp.magnitude > largest
          largest = temp.magnitude
          @normal = temp
        end
      end
      
      raise "Cannot compute normal" if @normal.nil?
      raise "Normal has 0 length" if largest == 0
      
      @normal.normalize!
      
      @plane = Topolys::Plane3D.new(@directed_edges[0].v0.point, @normal)
    
      @directed_edges.each do |de|
        raise "Point not on plane" if (de.v0.point - @plane.project(de.v0.point)).magnitude > Float::EPSILON
        raise "Point not on plane" if (de.v1.point - @plane.project(de.v1.point)).magnitude > Float::EPSILON
      end
    end
    
    def parent_class
      Face
    end
    
    ##
    # @return [Array] Array of Vertex
    def vertices
      @directed_edges.map {|de| de.v0}
    end
    
    ##
    # @return [Array] Array of Point3D
    def points
      vertices.map {|v| v.point}
    end
    
    ##
    # Validates if directed edges are sequential
    #
    # @return [Bool] Returns true if sequential
    def sequential?
      n = @directed_edges.size
      @directed_edges.each_index do |i|
        break if i == n-1
        
        # e.g. check if first edge v0 == last edge v
        #      check if each intermediate, nieghbouring v0 & v are equal
        #      e.g. by relying on 'inverted?'
        #      'answer = true' if all checks out
        return false if @directed_edges[i].v1.id != @directed_edges[i+1].v0.id
      end
      return true
    end
    
    ##
    # Validates if directed edges are closed
    #
    # @return [Bool] Returns true if closed
    def closed?
      n = @directed_edges.size
      return false if n < 3
      return @directed_edges[n-1].v1.id == @directed_edges[0].v0.id
    end
    
    ##
    # Checks if this Wire's directed edges are the same as another array of directed edges.
    # The order of directed edges must be the same but the two arrays may start at different indices.
    #
    # @param [Array] directed_edges Array of DirectedEdge
    #
    # @return [Bool] Returns true if the wires are circular_equal, false otherwise
    def circular_equal?(directed_edges)
      
      if !Topolys::find_offset(@directed_edges, directed_edges).nil?
        return true
      end
      
      return false
    end
    
    ##
    # Checks if this Wire is reverse equal to another Wire.
    # The order of directed edges must be the same but the two arrays may start at different indices.
    #
    # @param [Wire] other Other Wire
    #
    # @return [Bool] Returns true if the wires are reverse_equal, false otherwise
    def reverse_equal?(other)
      # TODO: implement
      return false
    end
    
    # TODO : deleting an edge, inserting a sequential edge, etc.

    ##
    # Gets 3D wire perimeter length
    #
    # @return [Float] Returns perimeter of 3D wire
    def perimeter
      @directed_edges.inject(0){|sum, de| sum + de.length }
    end

    ##
    # Gets 3D normal (unit) vector
    #
    # @return [V3D] Returns normal (unit) vector
    def normal
      @plane.normal
    end
    
  end # Wire 

  class Face < Object
  
    # @return [Wire] outer polygon
    attr_reader :outer
    
    # @return [Array] Array of Wire
    attr_reader :holes
    
    ##
    # Initializes a Face object
    #
    # Throws if outer or holes are incorrect type or if holes have incorrect winding
    #
    # @param [Wire] outer The outer boundary
    # @param [Array] holes Array of inner wires 
    def initialize(outer, holes)
      super()
      @outer = outer
      @holes = holes

      recalculate
    end
    
    def recalculate
    
      # check that holes have opposite normal from outer
      normal = @outer.normal
      @holes.each do |hole|
        raise "Hole does not have correct winding" if hole.normal.dot(normal) > -1 + Float::EPSILON
      end
      
      # check that holes are on same plane as outer
      plane = @outer.plane
      @holes.each do |hole|
        hold.points.each do |point|
          raise "Point not on plane" if (point - plane.project(point)).magnitude > Float::EPSILON
        end
      end
      
      # TODO: check that holes are contained within outer
      
    end
    
    def parent_class
      NilClass
    end
    
  end # Face
  
end # TOPOLYS
