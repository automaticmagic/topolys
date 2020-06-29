module Topolys

  # Point3D, Vector3D, and Plane3D represents the 3D position and orientation
  # of geometry in Topolys.  Geometry is separate from topology (connections).

  class Point3D 
  
    # @return [Float] X, Y, or Z coordinate
    attr_reader :x, :y, :z
    
    ##
    # Initializes a Point3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x, y, z)
      @x = x
      @y = y
      @z = z
    end

    ##
    # Generates a 3D vector, by subtracting self from other
    #
    # @param [Point3D] other Another 3D point
    #
    # @return [Vector3D] Returns a new Vector3D - nil if other not a Point3D
    def -(other)
      return nil unless other && other.is_a?(Topolys::Point3D)
      x = @x - other.x
      y = @y - other.y
      z = @z - other.z
      return Topolys::Vector3D.new(x, y, z)
    end
    
  end # Point3D

  class Vector3D
      
    # @return [Float] X, Y, or Z component
    attr_reader :x, :y, :z
    
    ##
    # Initializes a Vector3D object
    #
    # @param [Float] X-coordinate
    # @param [Float] Y-coordinate
    # @param [Float] Z-coordinate
    def initialize(x, y, z)
      @x = x
      @y = y
      @z = z
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
      return Topolys::Vector3D.new(x, y, z)
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
      return Topolys::Vector3D.new(x, y, z)
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
      Topolys::Vector3D.new(x, y, z)
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
      return Topolys::Vector3D.new(x, y, z)
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

  class Plane3D

    ##
    # Initializes a Plane3D object from three non-colinear points
    #
    # @param [Point3d] point1
    # @param [Point3d] point2
    # @param [Point3d] point3
    def initialize(point1, point2, point3)
      super(point1.x, point1.y, point1.z)
    end

    ##
    # Initializes a Plane3D object from a point and two vectors
    #
    # @param [Point3d] point1
    # @param [Vector3D] xaxis
    # @param [Vector3D] yaxis
    def initialize(point1, xaxis, yaxis)
      super(point1.x, point1.y, point1.z)
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
    def point_on_plane(point, tol)
      point == project(point)
    end

  end # Plane3D

end # TOPOLYS
