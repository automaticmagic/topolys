module Topolys

  # Point3D, Vector3D, and Plane3D represents the 3D position and orientation
  # of geometry in Topolys.  Geometry is separate from topology (connections).

  class D3 # superclass to other 3D geometry Topolys objects having XYZ coordinates
    # @return [Float] XY or Z coordinate
    attr_accessor :x, :y, :z

    ##
    # Initializes a D3 object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x, y, z, tol:nil)
      @x, @y, @z = x, y, z
      
      if !tol.is_a?(Numeric)
        tol = 0.01
      end
      @tol = tol
      @tol2 = @tol**2
    end

    ##
    # Returns D3 tolerance when comparing points
    #
    # @param [Float] D3 tolerance
    def tol
      @tol
    end

    ##
    # Returns D3 tolerance (squared) when comparing points
    #
    # @param [Float] D3 tolerance (squared)
    def tol2
      @tol2
    end

    ##
    # Overrides equality operator, based on value
    #
    # @param [D3] other Another D3 object (or derivative)
    def ==(other)
      return false unless other && other.is_a?(Topolys::D3)
      return false unless self.class == other.class
      tol = [@tol, other.tol].min
      
      # DLM: note this is a L1 norm test, e.g. a cube
      # I had been using L2 norm test, e.g. a sphere
      return false if (@x - other.x).abs > tol
      return false if (@y - other.y).abs > tol
      return false if (@z - other.z).abs > tol
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

  class Point3D < D3 # 3D point

    ##
    # Initializes a Point3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x, y, z, tol:nil)
      super
    end

    ##
    # Generates a 3D vector, by subtracting self from other
    #
    # @param [Point3D] other Another 3D point
    #
    # @return [Vector3D] Returns a new 3D vector - nil if other not a P3D point
    def -(other)
      return nil unless other && other.is_a?(Topolys::Point3D)
      x = other.x - @x
      y = other.y - @y
      z = other.z - @z
      tol = [@tol, other.tol].min
      return Topolys::V3D.new(x, y, z, tol)
    end
  end # P3D

  class Vector3D < D3 # 3D vector
    ##
    # Initializes a Vector3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x, y, z, tol:nil)
      super
    end

    ##
    # Adds 2x 3D vectors - overrides '+' operator
    #
    # @param [Vector3D] other Another 3D vector
    #
    # @return [Vector3D] Returns a new 3D resultant vector - nil if not Vector3D objects
    def +(other)
      return nil unless other && other.is_a?(Topolys::Vector3D)
      x = @x + other.x
      y = @y + other.y
      z = @z + other.z
      tol = [@tol, other.tol].min
      return Topolys::Vector3D.new(x, y, z, tol)
    end

    ##
    # Subtracts a 3D vector from another 3D vector - overrides '-' operator.
    # Leaves original 3D vector intact if other is not a Vector3D object
    #
    # @param [Vector3D] other Another 3D vector
    #
    # @return [Vector3D] Returns a new 3D resultant vector - nil if not Vector3D objects
    def -(other)
      return nil unless other && other.is_a?(Topolys::Vector3D)
      x = @x - other.x
      y = @y - other.y
      z = @z - other.z
      tol = [@tol, other.tol].min
      return Topolys::Vector3D.new(x, y, z)
    end

    ##
    # Multiplies a 3D vector by a scalar
    #
    # @param [Float] scalar A scalar
    #
    # @return [Vector3D] Returns a new, scaled 3D vector - nil if not numeric
    def *(scalar)
      return nil unless scalar && scalar.is_a?(Numeric)
      x = @x * scalar
      y = @y * scalar
      z = @z * scalar
      return Topolys::Vector3D.new(x, y, z, @tol)
    end

    ##
    # Divides a 3D vector by a non-zero scalar
    #
    # @param [Float] scalar A non-zero scalar
    #
    # @return [Vector3D] Returns a new, scaled 3D vector - nil if 0 or not numeric
    def /(scalar)
      return nil unless scalar && scalar.is_a?(Numeric)
      return nil if scalar.zero?
      x = @x / scalar
      y = @y / scalar
      z = @z / scalar
      Topolys::Vector3D.new(x, y, z, @tol)
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
    # @param [Vector3D] other Another 3D vector
    #
    # @return [Float] Returns dot product - nil if not Vector3D objects
    def dot(other)
      return nil unless other && other.is_a?(Topolys::Vector3D)
      return @x * other.x + @y * other.y + @z * other.z
    end

    ##
    # Gets the cross product between self & another 3D vector
    #
    # @param [Vector3D] other Another 3D vector
    #
    # @return [Vector3D] Returns cross product - nil if not Vector3D objects
    def cross(other)
      return nil unless other && other.is_a?(Topolys::Vector3D)
      x = @y * other.z - @z * other.y
      y = @z * other.x - @x * other.z
      z = @y * other.y - @y * other.x
      tol = [@tol, other.tol].min
      return Topolys::Vector3D.new(x, y, z, tol)
    end

    ##
    # Gets angle [0,PI) between self & another 3D vector
    #
    # @param [Vector3D] other Another 3D vector
    #
    # @return [Float] Returns angle - nil if not Vector3D objects
    def angle(other)
      return nil unless other && other.is_a?(Topolys::Vector3D)
      prod = magnitude * other.magnitude
      return nil if prod.zero?
      Math.acos(dot(other) / prod)
    end

  end # Vector3D

  class Plane3D < D3 # 3D plane

    ##
    # Initializes a Plane3D object from three non-colinear points
    #
    # @param [Point3d] point1
    # @param [Point3d] point2
    # @param [Point3d] point3
    def initialize(point1, point2, point3, tol:nil)
      super(point1.x, point1.y, point1.z, tol)
    end

    ##
    # Initializes a Plane3D object from a point and two vectors
    #
    # @param [Point3d] point1
    # @param [Vector3D] xaxis
    # @param [Vector3D] yaxis
    def initialize(point1, xaxis, yaxis, tol:nil)
      super(point1.x, point1.y, point1.z, tol)
    end
    
    # TODO: implement methods below
    
    ##
    # Project a Point3d to this plane
    #
    # @param [Point3d] point
    #
    # @return [Point3d] Returns point projected to this plane
    def project(point)
      point
    end
    
    ##
    # Check if a point is on this plane
    #
    # @param [Point3d] point
    #
    # @return [Boolean] Returns true if the point is on this plane, false otherwise
    def point_on_plane(point)
      point == project(point)
    end

  end # Plane3D

end # TOPOLYS
