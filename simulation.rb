require "./character.rb"
require "./utilities.rb"

class Simulation
  S_1ON1 = 1
  S_2ON1 = 2
  S_3ON1 = 3

  A_NONE = 1
  A_DMG = 2
  A_ATTCK_ROLL = 3

  attr_accessor :team_1, :team_2, :skirmish_type, :armor_mechanic

  def initialize(team_1, team_2)
    @skirmish_type = S_2ON1
    @armor_mechanic = A_ATTCK_ROLL
    @team_1 = team_1
    @team_2 = team_2
  end

  def validate_teams
    case skirmish_type
    when S_1ON1
      unless team_1.is_a?(Array) and team_1[0].is_a?(Character)
        raise "Not enough characters in team 1"
      end
    when S_2ON1
      unless team_1.is_a?(Array) and team_1[0..1].all? do |ch|
          ch.is_a?(Character)
        end
        raise "Not enough characters in team 1"
      end
    when S_3ON1
      unless team_1.is_a?(Array) and team_1[0..2].all? do |ch|
          ch.is_a?(Character)
        end
        raise "Not enough characters in team 1"
      end  
    else
      raise "Illegal skirmish type. Valid types: 1on1, 2on1, 3on1"
    end
    unless team_2.is_a?(Array) and team_2[0].is_a?(Character)
      raise "Not enough characters in team 2"
    end
  end

  def run (type = skirmish_type, armor_behavior = armor_mechanic, runs = 10000)
    case type
    when S_1ON1 
      one_on_one_simulation(armor_behavior, runs)
    when S_2ON1 
      two_on_one_simulation(armor_behavior, runs)
    when S_3ON1
      three_on_one_simulation(armor_behavior, runs)
    else
      raise "Illegal skirmish type"  
    end
  end

  def one_on_one_simulation (armor_behavior, runs)
    i = 0
    t1_wins = 0
    t2_wins = 0
  
    while i < runs do
      
      one_on_one_skirmish(team_1[0], team_2[0], armor_behavior)
      if team_1[0].health <= 0 
        t2_wins += 1
      elsif team_2[0].health <= 0
        t1_wins += 1
      end

      team_1[0].heal
      team_2[0].heal
      i += 1
    end
    puts "1 on 1"
    puts "Team 1 won: " + t1_wins.to_s
    puts "Team 2 won: " + t2_wins.to_s
  end


  def two_on_one_simulation(armor_behavior, runs)
    i = 0
    t1_wins = 0
    t2_wins = 0
    r010 = 0
    r110 = 0
    r001 = 0

    while i < runs do
     two_on_one_skirmish(team_1[0],team_1[1],team_2[0], armor_behavior)
      if team_2[0].health <= 0 
        t1_wins += 1
        if team_1[0].health <= 0
          r010 += 1
        else
          r110 += 1
        end
      else
        t2_wins += 1
        r001 += 1
      end
      team_1[0].heal
      team_1[1].heal
      team_2[0].heal
      i += 1
    end
    
    puts "2 on 1"
    puts "Team 1 won: " + t1_wins.to_s + " (alive (-X) " + r010.to_s + " (XX) " + r110.to_s + ")"
    puts "Team 2 won: " + t2_wins.to_s     
  end

  def three_on_one_simulation(armor_behavior, runs)
    i = 0
    t1_wins = 0
    t2_wins = 0
    r0010 = 0
    r0110 = 0
    r1110 = 0
    r0001 = 0

    while i < runs do
      three_on_one_skirmish(team_1[0], team_1[1], team_1[2], team_2[0], armor_behavior)
      if team_2[0].health <= 0 
        t1_wins += 1
        if team_1[0].health <= 0 and team_1[1].health <= 0
          r0010 += 1
        elsif team_1[0].health <= 0 and team_1[1].health > 0
          r0110 += 1
        else
          r1110 += 1
        end
      else
        t2_wins += 1
        r0001 += 1
      end
      team_1[0].heal
      team_1[1].heal
      team_1[2].heal
      team_2[0].heal
      i += 1
    end
    
    puts "3 on 1"
    puts "Team 1 won: " + t1_wins.to_s + " (alive (--X) " + r0010.to_s + " (-XX) " + r0110.to_s + " (XXX) " + r1110.to_s + ")"
    puts "Team 2 won: " + t2_wins.to_s     
  end

  def one_on_one_skirmish (hero_1, hero_2, armor_behavior = armor_mechanic)
    while hero_1.health > 0 and hero_2.health > 0 do
      case armor_behavior
      when A_NONE
        aa_round(hero_1, hero_2)
      when A_DMG
        aa_round(hero_1, hero_2, 0, 0, hero_1.armor, hero_2.armor)
      when A_ATTCK_ROLL
        aa_round(hero_1, hero_2, -hero_2.armor, -hero_1.armor)
      end  
    end
  end

  def two_on_one_skirmish (hero_1, hero_2, hero_3, armor_behavior = armor_mechanic)
    while hero_1.health > 0 and hero_2.health > 0 and hero_3.health > 0 do
      case armor_behavior
      when A_NONE
        aa_round(hero_1, hero_3)
        ad_round(hero_2, hero_3)
      when A_DMG
        aa_round(hero_1, hero_3, 0, 0, hero_1.armor, hero_3.armor)
        ad_round(hero_2, hero_3, 0, 0, hero_3.armor)
      when A_ATTCK_ROLL
        aa_round(hero_1, hero_3, -hero_3.armor, -hero_1.armor)
        ad_round(hero_2, hero_3, -hero_3.armor)
      end                  
    end
    one_on_one_skirmish(hero_2, hero_3, armor_behavior)
  end

  def three_on_one_skirmish (hero_1, hero_2, hero_3, hero_4, armor_behavior = armor_mechanic)
    while hero_1.health > 0 and hero_2.health > 0 and hero_3.health > 0 and hero_4.health > 0 do
      case armor_behavior
      when A_NONE
        aa_round(hero_1, hero_4)
        ad_round(hero_2, hero_4)
        an_round(hero_3, hero_4)
      when A_DMG
        aa_round(hero_1, hero_4, 0, 0, hero_1.armor, hero_4.armor)
        ad_round(hero_2, hero_4, 0, 0, hero_4.armor)
        an_round(hero_3, hero_4, 0, hero_4.armor)
      when A_ATTCK_ROLL
        aa_round(hero_1, hero_4, -hero_4.armor, -hero_1.armor)
        ad_round(hero_2, hero_4, -hero_4.armor)
        an_round(hero_3, hero_4, -hero_4.armor)
      end                  
    end
    two_on_one_skirmish(hero_2, hero_3, hero_4, armor_behavior)
  end

  def aa_round (hero_1, hero_2, roll_mod_1 = 0, roll_mod_2 =0, dmg_red_1 = 0, dmg_red_2 = 0)
      r1 = roll_k6(hero_1.attack_roll + roll_mod_1)
      r2 = roll_k6(hero_2.attack_roll + roll_mod_2)
      if r1 > r2 + dmg_red_2  
        hero_2.health -= r1 - r2 - dmg_red_2
      elsif r2 > r1 + dmg_red_1
        hero_1.health -= r2 - r1 - dmg_red_1
      end
  end

  def ad_round (hero_1, hero_2, roll_mod_1 = 0, roll_mod_2 = 0, dmg_red_2 = 0)
      r1 = roll_k6(hero_1.attack_roll + roll_mod_1)
      r2 = roll_k6(hero_2.defense_roll + roll_mod_2)
      if r1 > r2 + dmg_red_2
        hero_2.health -= r1 - r2 - dmg_red_2
      end
  end

  def an_round (hero_1, hero_2, roll_mod_1 = 0, dmg_red_2 = 0)
    r1 = roll_k6(hero_1.attack_roll + roll_mod_1)
    if r1 > dmg_red_2
      hero_2.health -= r1 - dmg_red_2
    end
  end

end