require "topolys/version"
require 'json'
require 'securerandom'

# TODO : start integrating warning logs à la raise from the get-go
module Topolys
  ##
  # documentation TODO
  class D3
    attr_accessor :x, :y, :z

    def initialize(x:0, y:0, z:0)
      @x, @y, @z = x, y, z
    end

    def ==(other)
      other.id == id
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
    # Initialize a P3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x:0, y:0, z:0)
      super
      @edges = {}
    end

    ##
    # Link a E3D object
    #
    # @param [E3D] edge An edge to link
    def link(edge)
      if edge && edge.is_a?(Topolys::E3D)
        @edges[edge] = edge.object_id unless @edges.key?(edge)
      end
    end

    ##
    # Unlink a E3D object
    #
    # @param [E3D] edge An edge to unlink
    def unlink(edge)
      @edges.reject!{ |e, id| e == edge } # define
    end

    ##
    # Generates a V3D vector, by subtracting self from 'other'
    #
    # @param [P3D] other A P3D point
    #
    # @return [V3D] Returns a new V3D vector, 'nil' if 'other' not a P3D point
    def -(other)
      if other && other.is_a?(Topolys::P3D)
        return Topolys::V3D.new(x:(other.x - @x),
                                y:(other.y - @y),
                                z:(other.z - @z))
      end
      return nil
    end
  end # P3D

  class V3D < D3 # 3D vector
    ##
    # Initialize a V3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x:0, y:0, z:0)
      super
    end

    # Get vector magnitude (or length)
    #
    # @return [Float] Returns magnitude of the 3D vector
    def magnitude
      Math.sqrt(x**2 + y**2 + z**2)
    end

    # this is an example of vector operations in Ruby::Vector
    # def normalize
    #  n = magnitude
    #  raise ZeroVectorError, "Zero vectors can not be normalized" if n == 0
    #  self / n
    # end

    # or another useful one ...
    # File lib/matrix.rb, line 2085
    # def angle_with(v)
      # raise TypeError, "Expected a Vector, got a #{v.class}" unless v.is_a?(Vector)
      # Vector.Raise ErrDimensionMismatch if size != v.size
      # prod = magnitude * v.magnitude
      # raise ZeroVectorError, "Can't get angle of zero vector" if prod == 0
      # Math.acos( inner_product(v) / prod )
    # end

  end # V3D
end # TOPOLYS
