class Character
  def initialize(name, attack_roll, defense_roll, armor, total_life)
    @name = name
    @attack_roll = attack_roll
    @defense_roll = defense_roll
    @armor = armor
    @total_life = total_life
    @health = total_life
  end

  attr_reader :name, :attack_roll, :defense_roll, :armor, :total_life
  attr_accessor :health

  def heal
    @health = @total_life
  end

end