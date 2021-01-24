  def one_on_one(character_1, character_2, number, simulation_function)
    i = 0
    c1_wins = 0
    c2_wins = 0
    
    while i < number do
      method(simulation_function).call(character_1,character_2)
      if character_1.health <= 0 
        c2_wins += 1
      elsif character_2.health <= 0
        c1_wins += 1
      end
      character_1.heal
      character_2.heal
      i += 1
    end
    puts simulation_function
    puts character_1.name + " won: " + c1_wins.to_s
    puts character_2.name + " won: " + c2_wins.to_s
  end