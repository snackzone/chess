class MoveError < StandardError
  def message
    "you can't move there!"
  end
end

class CheckError < MoveError
  def message
    "CheckError. you must move out of check."
  end
end

class IntoCheckError < MoveError
  def message
    "IntoCheck Error. you cannot move into check."
  end
end
