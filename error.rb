class MoveError < StandardError
  def message
    "you can't move there!"
  end
end

# class WrongPiece < MoveError
#   def message
#     "that's not your piece!"
#   end
# end

# class OccupiedSpaceError < MoveError
#   def message
#     "that space is taken!"
#   end
# end

class CheckError < MoveError
  def message
    #debugger
    "CheckError. you must move out of check."
  end
end

class IntoCheckError < MoveError
  def message
    "IntoCheck Error. you cannot move into check."
  end
end
