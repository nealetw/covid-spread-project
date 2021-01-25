// Authors: 
// Brandon Starcheus
// Tim Neale
// Alex Shiveley
// Daniel Hackney

// Input the number of students, percent initially infected with COVID19, and percent who wear masks.
// Output a simulation of a single day of campus activity in dining halls.

// Usage:   > swift main.swift <Number People> <Percent Infected> <Percent Masks>
// Example: > swift main.swift 6000 5 90


import Foundation

var centerCourt = DiningHall(name: "Center Court", sqFeet: 9000);
var marketPointe = DiningHall(name: "Market Pointe", sqFeet: 9000);
var otg = DiningHall(name: "On the Green", sqFeet: 4000);
var diningHallArray = [centerCourt, marketPointe, otg];

var UC = Campus(diningHalls: diningHallArray);
UC.runDay();


// A campus having students, dining halls, infection percent, and mask percent.
// Run a simulation of the infection spreading via dining halls in a single day.
class Campus {
    var diningHalls: [DiningHall]
    var people: [Person]
    var numPeople: Int { return people.count }
    var initInfectionPercent: Float
    var initMaskPercent: Float
    var totalInfected: Int
    var verbose: Bool

    init(diningHalls: [DiningHall]) {
        self.diningHalls = diningHalls
        
        let args = CommandLine.arguments;
        guard args.count > 3 else { print("Too few arguments"); exit(1) }
        guard let numP = Int(args[1]) else { print("Invalid Int argument"); exit(1) }
        guard let infectPercent = Float(args[2]) else { print("Invalid Float argument"); exit(1) }
        guard let maskPercent = Float(args[3]) else { print("Invalid Float argument"); exit(1) }
        guard args.count < 6 else { print("Too many arguments"); exit(1) }
        if args.count == 5 {
            if args[4] == "-v" {
                self.verbose = true
            } else {
                print("Invalid argument", args[4])
                exit(1)
            }
        } else { 
            self.verbose = false 
        }

        initInfectionPercent = infectPercent
        initMaskPercent = maskPercent
        people = generatePeople(numP, infectPercent, maskPercent)
        
        self.totalInfected = 0
        for p in people {
            if p.infected { self.totalInfected = self.totalInfected + 1 }
        }
    }

    func passTime(){
        // Increment by a single time unit, 1 minute

        movePeopleToDiningHalls()
        
        for d in diningHalls {
            d.passTime();
        }
        updateInfected();
    }

    func movePeopleToDiningHalls() {
        // Randomlly select people who are not in a dining hall to go to one.
        // Randomizer makes chance of selection so low, as to simulate real 
        // student eating habits throughout the day. 

        for person in people {
            if Float.random(in: 0 ... 1000) <= 1 && person.location == "Home" {
                let diningHall = diningHalls.randomElement()!;
                if diningHall.people.count < diningHall.maxCapacity {
                    diningHall.enter(person: person);
                }
            }
        }
    }

    func updateInfected() {
        // Update the number of infected people.
        // If a person randomly coughs and they do not have a mask, 
        // the person in front and behind the cougher gets infected.

        for diningHall in diningHalls{
            for i in 0..<diningHall.people.count{
                if(diningHall.people[i].contagious && !diningHall.people[i].hasMask && diningHall.people[i].cough()){
                    if i > 0 {
                        if !diningHall.people[i-1].infected {
                            diningHall.people[i-1].infected = true
                            self.totalInfected += 1
                        }
                    }
                    if i < diningHall.people.count - 1 {
                        if !diningHall.people[i+1].infected {
                            diningHall.people[i+1].infected = true
                            self.totalInfected += 1
                        }
                    }
                }
            }
        }
    }

    func runDay() {
        // Run a simulation for a full day with detailed output.

        // Each time iteration is 1 min
        let startNumInfected = totalInfected
        for i in 0..<(12*60) {
            passTime();

            if i % 60 == 0 {
                print("Hour: ", i / 60);
                print("Infected: ", totalInfected)

                if verbose {
                    for diningHall in diningHalls {
                        print(diningHall.name, ": ", diningHall.people.count)
                    }
                }
                print();
            }
        }
        print("Initial Infected: ", startNumInfected, "(", (startNumInfected * 100 / numPeople), "% )")
        print("Final infected: ", totalInfected, "(", (totalInfected * 100 / numPeople), "% )")
    }
}


// A dining hall contains a line of students waiting for food. 
// Based on the square footage it has a maximum capacity of students while maintaining 6 ft distance.
class DiningHall {
    var name: String
    var sqFootage: Int
    var isOpen: Bool
    var people: [Person]
    var maxCapacity: Int { return Int(floor(Double(sqFootage / 36))) } // Maintain 6ft distance between everyone

    init(name: String, sqFeet: Int, isOpen: Bool = true) {
        self.name = name
        self.sqFootage = sqFeet
        self.isOpen = isOpen
        self.people = []
    }
    func enter(person: Person) {
        // A person enters a dining hall

        if people.count < maxCapacity {
            people.append(person);
            person.location = name;
        }
    }
    func exit(person: Person) {
        // A person leaves a dining hall

        person.location = "Home";
    }

    func passTime() {
        // Increment by a single time unit, 1 minute

        if people.isEmpty { return }
        exit(person: people.removeFirst())
    }
}


// A person at a given location either has a mask or not.
// If they have the virus at the beginning of the simulation
// they are contagious and it can spread to other people.
// If they contract the virus during the simulation they 
// become infected, but are not contagious until after 
// the simulation (a single day).
class Person {
    var number: Int
    var location: String
    var hasMask: Bool
    var infected: Bool
    var contagious: Bool
    
    init(number: Int, location: String, hasMask: Bool, contagious: Bool) {
        self.number = number
        self.location = location
        self.hasMask = hasMask    
        self.contagious = contagious
        self.infected = contagious
    }

    func cough() -> Bool {
        // A person may randomly cough. 
        return Float.random(in: 0 ... 100) < 20
    }
}



func generatePeople(_ numPeople: Int, _ infected: Float, _ masks: Float, startID: Int = 1) -> [Person] {
    // Generate a campus of people with a given percent with the infection and masks.

    var newPeople: [Person] = []
    for i in 0 ..< numPeople {
        let newPerson = Person(number: startID + i, 
                            location: "Home",
                            hasMask: Float.random(in: 0...100) < masks,
                            contagious: Float.random(in: 0...100) < infected);
        newPeople.append(newPerson);
    }
    return newPeople;
}