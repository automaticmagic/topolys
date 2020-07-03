require 'topolys'

##
# Convert degrees to radians
#
# @param [Float] degrees
#
# @return [Float] radians
def degToRad(degrees)
  return degrees * Math::PI / 180 
end

##
# Make a rectangle with width and height, normal is down
#
# @param [Float] width
# @param [Float] height
#
# @return [Array] Returns an Array of Point3d
def make_rectangle(width, height)
  result = []
  result << Topolys::Point3D.new(0, height, 0)
  result << Topolys::Point3D.new(width, height, 0)
  result << Topolys::Point3D.new(width, 0, 0)
  result << Topolys::Point3D.new(0, 0, 0)
  return result
end

##
# Move all points in an array by a vector
#
# @param [Array] points Array of Point3d
# @param [Vector3d] vector Vector3d to move points by
#
# @return [Array] Returns a new Array of Point3d
def move_points(points, vector)
  points.map { |point| point + vector }
end