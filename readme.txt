This was a project for Programming Languages done with three other students.
The task was to use 4 different types of programming languages to do four different things to help with COVID:
one functional, one logic, one object-oriented, and one procedural.


Perl was used to take data from a google form as a csv and parsed it into a better formatted csv
file with more usable data points to move on to the next language.
The code below uses the csv from a google form, asking about a person’s health, age, and
housing preferences, and this data is outputted into a new csv file that more resembles numbers and a
name, so it can be easily manipulated to calculate a susceptibility score for the student.

Once a csv is produced by the Perl program, Haskell can take that file in and calculate a score of
just how badly COVID-19 will affect a student if they get it, based on the questions from the google form
of health conditions. This program will basically condense the csv to fewer columns, getting rid of all the
1’s and 0’s and replacing them with one column of a score between 0 and 10.

The other columns of the initial Perl output are used by the following program in Prolog, where
we take people’s susceptibility paired with their current housing and class situation, namely whether
their current housing is near campus and whether their classes are all online, and assign these students
to suitable types of housing.
This program takes those students that live less than 25 miles from campus, and assigns them to
live at home and commute rather than take up housing. Next we take into account a person’s
susceptibility and their housing preference (whether they said they mind living with other people) and
assign them to a single, double, or quad room. If your susceptibility score is high enough, you will
automatically get a single room, if you don’t mind people but slightly susceptible, you’ll get a double,
and if you don’t mind people and have a near zero susceptibility, you’ll get a quad room.

Our final language was more disconnected from our previous languages, having no connection
to any data from the other three languages. We decided to make a simulation of people going into
dining halls on campus, going through lines and taking food back to their homes, and see how the virus
will spread.
You input the total number of students, the percent initially infected, and a percent that wear
masks, and the simulation will start. The simulation starts with all students at home, the dining halls
open, and students have a chance every minute to decide to go to a dining hall. The halls have a
population limit, holding only so many people at once. The hall has a queue of students going through
and once a student is through the queue, they go home. In the line, infected students have a chance to
spread the infection to nearby students unless they are wearing a mask. This simulation runs for 12
hours, and will tell you how many students are infected at the end of the day.
