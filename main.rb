require "./character.rb"
require "./simulation.rb"
require "./utilities.rb"


rouge = Character.new("Rouge",11,7,0,6)
thief = Character.new("Thief",11,7,0,5)
militia = Character.new("Militia",12,13,0,7)
knight1 = Character.new("Knight",13,13,2,5)
knight2 = Character.new("Knight",13,13,3,5)
knight3 = Character.new("Knight",13,13,4,5)

team_1 = [rouge, thief, militia]
team_2 = [knight1]
team_3 = [knight2]
team_4 = [knight3]

sim = Simulation.new(team_1, team_2)
sim.validate_teams()

#puts "\nno armor"
#sim.run(Simulation::S_1ON1, Simulation::A_NONE, 100000)
#sim.run(Simulation::S_2ON1, Simulation::A_NONE, 100000)
#sim.run(Simulation::S_3ON1, Simulation::A_NONE, 100000)
#puts "\ndamage reduction"
#sim.run(Simulation::S_1ON1, Simulation::A_DMG, 100000)
#sim.run(Simulation::S_2ON1, Simulation::A_DMG, 100000)
#sim.run(Simulation::S_3ON1, Simulation::A_DMG, 100000)
puts "\nattack roll reduction, armor:2"
sim.run(Simulation::S_1ON1, Simulation::A_ATTCK_ROLL, 100000)
sim.run(Simulation::S_2ON1, Simulation::A_ATTCK_ROLL, 100000)
sim.run(Simulation::S_3ON1, Simulation::A_ATTCK_ROLL, 100000)

sim.team_2 = team_3
puts "\nattack roll reduction, armor:2"
sim.run(Simulation::S_1ON1, Simulation::A_ATTCK_ROLL, 100000)
sim.run(Simulation::S_2ON1, Simulation::A_ATTCK_ROLL, 100000)
sim.run(Simulation::S_3ON1, Simulation::A_ATTCK_ROLL, 100000)

sim.team_2 = team_4
puts "\nattack roll reduction, armor:2"
sim.run(Simulation::S_1ON1, Simulation::A_ATTCK_ROLL, 100000)
sim.run(Simulation::S_2ON1, Simulation::A_ATTCK_ROLL, 100000)
sim.run(Simulation::S_3ON1, Simulation::A_ATTCK_ROLL, 100000)

