require "topolys/version"
require 'json'

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
    attr_accessor :vertices, :edges, :wires, :faces, :shells, :cells
    attr_accessor :tol, :tol2
    
    def initialize(tol:nil)
      
      # changing tolerance on a model after construction would be very complicated
      # you would have to go through and regroup points, etc
      if !tol.is_a?(Numeric)
        tol = 0.01
      end
      @tol = tol
      @tol2 = @tol**2

      @vertices = []
      @edges = []
      @wires = []
      @faces = []
      @shells = []
      @cells = []
    end

    # @param [Numeric] x
    # @param [Numeric] y
    # @param [Numeric] z
    # @return [Vertex] Vertex
    def get_vertex(x, y, z)
      # search for vertex and return if exists
      # otherwise create new vertex
    end
    
    # @param [Vertex] v0
    # @param [Vertex] v1
    # @return [EdgeView] EdgeView
    def get_edge_view(v0, v1)
      # search for edge and return a view (includes direction) if it exists
      # otherwise create new edge and return a view
    end
    
    # @param [Array] vertices Array of Vertex
    # @return [WireView] WireView
    def get_wire_view(edges)
      # search for wire and return a view (includes starting point) if exists 
      # otherwise create new wire
    end
    
  end # Model
  
  class Object
    
    # @return [-] attribute linked to a pre-speficied key (e.g. keyword)
    attr_accessor :attribute  # a [k,v] hash of properties required by a parent
                              # app, but of no intrinsic utility to Topolys.
                              # e.g. a thermal bridge PSI type
                              #      "attribute[:bridge] = :balcony
                              # e.g. air leakage crack type (ASHRAE Fund's)
                              #      "attribute[:crack] = :sliding
                              # e.g. LCA $ element type
                              #      "attribute[$lca] = :parapet"

    def initialize
      @attribute = {}
    end
    
  end # Object

  class Vertex < Object
    # @return [Point3D] Point3D geometry
    attr_reader :point
    
    # @return [Hash] linked Edge objects
    attr_reader :edges

    ##
    # Initializes a Vertex object, use Model.get_point instead
    #
    # @param [Point3D] point
    def initialize(point)
      @point = point
      @edges = {}
      super
    end

    ##
    # Links a E3D object
    #
    # @param [E3D] edge An edge to link
    def link(edge)
      if edge && edge.is_a?(Topolys::E3D)
        @edges[edge] = edge.object_id unless @edges.key?(edge)
      end
    end

    ##
    # Unlinks a E3D object
    #
    # @param [E3D] edge An edge to unlink
    def unlink(edge)
      @edges.reject!{ |e, id| e == edge }
    end

  end # Vertex

  class Edge < Object
    # @return [Vertex] the initial vertex, the edge origin
    attr_reader :v0

    # @return [Vertex] the second vertex, the edge terminal point
    attr_reader :v1
    
    # @return [Vector3D] a vector from v0 to v1
    attr_reader :vector

    # @return [Hash] collection of linked W3D
    attr_reader :wires # << or rather ... ":faces" ?

    ##
    # Initializes an Edge object, use Model.get_edge instead
    #
    # @param [Vertex] v0 The origin Vertex
    # @param [Vertex] v1 The terminal Vertex
    def initialize(v0, v1)
      # should catch if 'origin' or 'terminal' not P3D objects ...
      # should also catch if 'origin' or 'terminal' refer to same object
      # ... or are within tol of each other
      @v0 = v0
      @v1 = v1
      @vector = @v1.point - @v0.point

      @v0.link(self)
      @v1.link(self)
    end

    ##
    # Links a Wire object
    #
    # @param [Wire] wire A wire to link
    def link(wire)
      if wire && wire.is_a?(Topolys::Wire)
        @wires[wire] = wire.object_id unless @wires.key?(wire)
      end
    end

    ##
    # Unlinks a Wire object
    #
    # @param [Wire] wire A wire to unlink
    def unlink(wire)
      @wires.reject!{ |w, id| w == wire }
    end

    protected

    def id
      [@v0, @v]
    end

    def hash
      id.hash
    end

  end # Edge
  
  class EdgeView
    
    # @return [Vertex] the initial vertex of this view, the edge origin
    attr_reader :v0

    # @return [Vertex] the second vertex of this view, the edge terminal point
    attr_reader :v1
    
    # @return [Vector3D] a vector from v0 to v1 in this view
    attr_reader :vector

    # @return [Edge] the underlying edge
    attr_reader :edge 
    
    # @return [Boolean] true if savethe underlying edge
    attr_reader :edge 
    
    def initialize(edge, inverted)
      @edge = edge
      @inverted = inverted
      
      if inverted
        @v0 = edge.v1
        @v1 = edge.v0
      else
        @v0 = edge.v0
        @v1 = edge.v1
      end
      
      @vector = @v1.point - @v0.point
    end
  
  end # EdgeView

  class Wire < Object
    # @return [Array] array of linked edge/direction pairs, or 'directed edges'
    #                 or 'dedges' (shorthand) ... see 'initialize'
    attr_reader :dedges

    # @return [Hash] collection of 1x or 2x linked faces ?
    attr_reader :faces # << or would faces simply extend the W3D class ?

    ##
    # Initializes a W3D object
    #
    def initialize(edges, edge_directions) # or 'initialize(dir_edges)'?
      # instead of a separate array of edge 'directions' (1 or -1)
      # ... would it be preferable to have 'edges' as a sequential array of
      # hash k/v pairs describing each edge? e.g.
      #
      # k = (edge object itself) & v = (its direction: 1 or -1) ?, e.g.
      # dedges.each do |edge, direction|
      #  (check something, like validating vertex sequence )
      # end

      @dedges = []
      edges.each_index do |i|
        e = edges[i]
        d = edge_directions[i] # invalid if edges 'i' != edges_directions 'i'
        dedge[e] = d
        @dedges << dedge
      end

      @dedges.each do |e, direction|
        e.link(self)
      end
    end

    # TODO ... check if useful to override '==' operator based on value
    # e.g. hash of sequential dedges

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
  end #W3D

  class F3D # Face - a collection of W3D objects

    # @return [-] attribute linked to key (e.g. keyword, string)
    attr_accessor :attribute  # a [k,v] hash of properties required by a parent
                              # app, but of no intrinsic utility to Topolys.
                              # e.g. OS surface type
                              #      attribute[:type] = :shading
                              # e.g. environmental conditions
                              #      attribute[:facing] = :ground (or :air)

    ##
    # Initializes a F3D object
    #
    def initialize
      # TODO
    end

    # TODO ... check if useful to override '==' operator based on value
    # e.g. hash of wires ?

    def parent
      # TODO : better to have an algorithm dynamically test and ID a parent?
    end
  end
end # TOPOLYS
