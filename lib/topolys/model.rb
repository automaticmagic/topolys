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
      return v
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
    
    # @param [Array] vertices Array of Vertex, assumes closed wire
    # @return [Wire] Wire
    def get_wire(vertices)
      # search for wire and return a view (includes starting point) if exists 
      # otherwise create new wire
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
      
      raise "Not sequential" if !sequential?
      raise "Not closed" if !closed
      
      # compute plane from points
      

      @directed_edges.each do |de|
        de.link(self)
      end
    end
    
    def parent_class
      Face
    end
    
    ##
    # @param [Boolean] include_last If true, return repeated last point for closed loops
    # @return [Array] Array of Vertex
    def vertices(include_last:false)
 
    end
    
    ##
    # @param [Boolean] include_last If true, return repeated last point for closed loops
    # @return [Array] Arracy of Point3D
    def points(include_last:false)
 
    end
    
    ##
    # Validates if directed edges are sequential
    #
    # @return [Bool] Returns true if sequential
    def sequential?
      answer = false
      @dedges.each do |edge, direction|
        # e.g. check if first edge v0 == last edge v
        #      check if each intermediate, nieghbouring v0 & v are equal
        #      e.g. by relying on 'inverted?'
        #      'answer = true' if all checks out
      end
      return answer
    end
    
    ##
    # Validates if directed edges are closed
    #
    # @return [Bool] Returns true if closed
    def closed?
      answer = false
      @dedges.each do |edge, direction|
        # e.g. check if first edge v0 == last edge v
        #      check if each intermediate, nieghbouring v0 & v are equal
        #      e.g. by relying on 'inverted?'
        #      'answer = true' if all checks out
      end
      return answer
    end
    
    # TODO : deleting an edge, inserting a sequential edge, etc.

    ##
    # Gets 3D wire perimeter length
    #
    # @return [Float] Returns perimeter of 3D wire
    def perimeter
      # returns perimeter, i.e. sum of edge lengths
    end

    ##
    # Gets 3D normal (unit) vector
    #
    # @return [V3D] Returns normal (unit) vector
    def normal # TODO
      # from 2x edges (i.e. 3x vertices), generate a surface V3D normal ...
    end
  end # Wire 

  class Face < Object

    ##
    # Initializes a Wire object
    #
    # Throws if outer or holes are incorrect type or if holes have incorrect winding
    #
    # @param [Wire] outer The outer boundary
    # @param [Array] holes Array of inner wires 
    def initialize(outer, holes)
      # TODO
      super()
    end

    def parent_class
      NilClass
    end
    
  end # Face
  
end # TOPOLYS
