require "topolys/version"
require 'json'

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
  class D3 # superclass to other Topolys objects having XYZ coordinates
    # @return [Float] XY or Z coordinate
    attr_accessor :x, :y, :z

    @@tol = 0.01
    @@tol2 = @@tol**2

    ##
    # Initializes a D3 object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x:0, y:0, z:0)
      @x, @y, @z = x, y, z
    end

    ##
    # Returns D3 tolerance when comparing points
    #
    # @param [Float] D3 tolerance
    def tol
      @@tol
    end

    ##
    # Returns D3 tolerance (squared) when comparing points
    #
    # @param [Float] D3 tolerance (squared)
    def tol2
      @@tol2 = @@tol**2
    end

    ##
    # Sets D3 tolerance when comparing points, if delta is Numeric
    #
    # @param [Float] delta New D3 tolerance
    def setTolerance(delta)
      if delta.is_a?(Numeric)
        @@tol = delta
        @@tol2 = @@tol**2
      end
    end

    ##
    # Resets D3 tolerance to Topolys default
    def resetTolerance
      @@tol = 0.01
      @@tol2 = @@tol**2
    end

    ##
    # Overrides equality operator, based on value
    #
    # @param [D3] other Another D3 object (or derivative)
    def ==(other)
      return false unless other && other.is_a?(Topolys::D3)
      return false unless self.class == other.class
      return false if (@x - other.x).abs > @@tol
      return false if (@y - other.y).abs > @@tol
      return false if (@z - other.z).abs > @@tol
      return true
    end

    alias_method :eql?, :==

    protected

    def id
      [@x, @y, @z, self.class]
    end

    def hash
      id.hash
    end
  end

  class P3D < D3 # 3D point
    # @return [Hash] linked E3D objects
    attr_reader :edges

    ##
    # Initializes a P3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x:0, y:0, z:0)
      super
      @edges = {}
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

    ##
    # Generates a 3D vector, by subtracting self from other
    #
    # @param [P3D] other Another 3D point
    #
    # @return [V3D] Returns a new 3D vector - nil if other not a P3D point
    def -(other)
      return nil unless other && other.is_a?(Topolys::P3D)
      ex = other.x - @x
      wy = other.y - @y
      ze = other.z - @z
      return Topolys::V3D.new(x: ex, y: wy, z: ze)
    end
  end # P3D

  class V3D < D3 # 3D vector
    ##
    # Initializes a V3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x:0, y:0, z:0)
      super
    end

    ##
    # Adds 2x 3D vectors - overrides '+' operator
    #
    # @param [V3D] other Another 3D vector
    #
    # @return [V3D] Returns a new 3D resultant vector - nil if not V3D objects
    def +(other)
      return nil unless other && other.is_a?(Topolys::V3D)
      ex = @x + other.x
      wy = @y + other.y
      ze = @z + other.z
      return Topolys::V3D.new(x: ex, y: wy, z: ze)
    end

    ##
    # Subtracts a 3D vector from another 3D vector - overrides '-' operator.
    # Leaves original 3D vector intact if other is not a V3D object
    #
    # @param [V3D] other Another 3D vector
    #
    # @return [V3D] Returns a new 3D resultant vector - nil if not V3D objects
    def -(other)
      return nil unless other && other.is_a?(Topolys::V3D)
      ex = @x - other.x
      wy = @y - other.y
      ze = @z - other.z
      return Topolys::V3D.new(x: ex, y: wy, z: ze)
    end

    ##
    # Multiplies a 3D vector by a scalar
    #
    # @param [Float] scalar A scalar
    #
    # @return [V3D] Returns a new, scaled 3D vector - nil if not numeric
    def *(scalar)
      return nil unless scalar && scalar.is_a?(Numeric)
      ex = @x * scalar
      wy = @y * scalar
      ze = @z * scalar
      return Topolys::V3D.new(x: ex, y: wy, z: ze)
    end

    ##
    # Divides a 3D vector by a non-zero scalar
    #
    # @param [Float] scalar A non-zero scalar
    #
    # @return [V3D] Returns a new, scaled 3D vector - nil if 0 or not numeric
    def /(scalar)
      return nil unless scalar && scalar.is_a?(Numeric)
      return nil if scalar.zero?
      ex = @x / scalar
      wy = @y / scalar
      ze = @z / scalar
      Topolys::V3D.new(x: ex, y: wy, z: ze)
    end

    ##
    # Gets 3D vector magnitude (or length)
    #
    # @return [Float] Returns magnitude of the 3D vector
    def magnitude
      Math.sqrt(@x**2 + @y**2 + @z**2)
    end

    ##
    # Normalizes a 3D vector
    def normalize
      n = magnitude
      unless n.zero?
        @x /= n
        @y /= n
        @z /= n
      end
    end

    ##
    # Gets the dot (or inner) product of self & another 3D vector
    #
    # @param [V3D] other Another 3D vector
    #
    # @return [Float] Returns dot product - nil if not V3D objects
    def dot(other)
      return nil unless other && other.is_a?(Topolys::V3D)
      return @x * other.x + @y * other.y + @z * other.z
    end

    ##
    # Gets the cross product between self & another 3D vector
    #
    # @param [V3D] other Another 3D vector
    #
    # @return [V3D] Returns cross product - nil if not V3D objects
    def cross(other)
      return nil unless other && other.is_a?(Topolys::V3D)
      return Topolys::V3D.new( x:( y * other.z - z * other.y ),
                               y:( z * other.x - x * other.z ),
                               z:( y * other.y - y * other.x ) )
    end

    ##
    # Gets angle [0,PI) between self & another 3D vector
    #
    # @param [V3D] other Another 3D vector
    #
    # @return [Float] Returns angle - nil if not V3D objects
    def angle(other)
      return nil unless other && other.is_a?(Topolys::V3D)
      prod = magnitude * other.magnitude
      return nil if prod.zero?
      Math.acos(dot(other) / prod)
    end

  end # V3D

  class E3D # 3D edge
    # @return [P3D] an initial vertex, the edge origin
    attr_reader :v0

    # @return [P3D] a second vertex, the edge terminal point
    attr_reader :v

    # @return [-] attribute linked to a pre-speficied key (e.g. keyword)
    attr_accessor :attribute  # a [k,v] hash of properties required by a parent
                              # app, but of no intrinsic utility to Topolys.
                              # e.g. a thermal bridge PSI type
                              #      "attribute[:bridge] = :balcony
                              # e.g. air leakage crack type (ASHRAE Fund's)
                              #      "attribute[:crack] = :sliding
                              # e.g. LCA $ element type
                              #      "attribute[$lca] = :parapet"

    # @return [Hash] collection of linked W3D
    attr_reader :wires # << or rather ... ":faces" ?

    ##
    # Initializes a E3D object
    #
    # @param [P3D] origin A 3D vertex
    # @param [P3D] terminal A 3D vertex
    def initialize(origin, terminal)
      # should catch if 'origin' or 'terminal' not P3D objects ...
      # should also catch if 'origin' or 'terminal' refer to same object
      # ... or are within tol of each other
      @v0 = origin
      @v  = terminal

      @v0.link(self)
      @v.link(self)
    end

    ## Overrides equality operator, based on value
    #
    # @param [E3D] other Another E3D object
    def ==(other)
      return false unless other && other.is_a?(Topolys::E3D)
      return false if other.v0 == other.v
      return false unless other.v0 == @v0 || other.v == @v
      return false unless other.v  == @v0 || other.v == @v
      return true
    end

    alias_method :eql?, :==

    ## Checks if inverted clone of the other
    #
    # @param [E3D] other Another 3D edge
    #
    # @return [Bool] true if inverted clone
    def inverted?(other)
      return false unless other && other.is_a?(Topolys::E3D)
      return false if other.v0 == other.v
      return false unless other.v0 == @v
      return false unless other.v  == @v0
      return true
    end

    ## Inverts origin & terminal vertices with one another
    #
    # @return [E3D] an inverted 3D edge
    def invert
      temp = @v0
      @v0 = @v
      @v = temp
    end

    ##
    # Gets edge length
    #
    # @return [Float] Returns length of 3D edge
    def length
      vec = v - v0
      vec.magnitude
    end

    ##
    # Links a W3D object
    #
    # @param [W3D] wire A wire to link
    def link(wire)
      if wire && wire.is_a?(Topolys::W3D)
        @wires[wire] = wire.object_id unless @wires.key?(wire)
      end
    end

    ##
    # Unlinks a W3D object
    #
    # @param [W3D] wire A wire to unlink
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

  end # E3D

  class W3D # 3D Wire - a collection of E3D objects << superclass of faces?
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
