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

  #p D3.new(1, 2, 3) == D3.new(1, 2, 3)    # => true
  #p D3.new(1, 2, 3) == D3.new(1, 2, 4)    # => false

  class P3D < D3 # 3D point

    # @return [Hash] linked E3D objects
    attr_reader :edges

    ##
    # Initialize a V3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x, y, z)
      #@id = SecureRandom.uuid
      #@x = x
      #@y = y
      #@z = z
      @edges = {} # @edges[id:] = < E3D object >
    end

    ##
    # Link a E3D object
    #
    # @param [E3D] edge An edge to link
    def link(edge)
      @edges[edge.id] = edge if edge && edge.is_a?(TOPOLYS::E3D)
      #@edges.uniq! { |id, e| e[:id] } # TODO ... shouldn't be necessary with unique hash keys
    end

    ##
    # Unlink a E3D object
    #
    # @param [E3D] edge An edge to unlink
    def unlink(edge)
      @edges.reject!{ |id,e| e[id] == edge.id } # check for has_key? instead
    end

    ##
    # Generates a 3D vector, from self to input vertex
    #
    # @param [V3D] vertex A 3D vertex
    #
          # @return [Hash] Returns 3D hash of floats for vector x, y, z dimensions
        #  def vector(vertex1, vertex2)
        #    return [vertex2.x-vertex1.x, vertex2.y-vertex1.y, vertex2.z-vertex1.z]
        #  end

  end # P3D
end # TOPOLYS
