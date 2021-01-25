% Authors: 
% Brandon Starcheus
% Tim Neale
% Alex Shiveley
% Daniel Hackney

% Input a CSV with a susceptibility score for each student.
% Output a CSV with a housing category for each student.

% Usage: > swipl 
%        ?- [living_assignment].


:- initialization living_assignment, halt.

living_assignment :- 
    use_module(library(csv)),
    csv_read_file('2-Haskell-Output.csv', Data),
    maplist(row_to_list, Data, Lists),
    processData(Lists, OutData),
    maplist(list_to_row, OutData, OutRows),
    csv_write_file('3-Prolog-Output.csv', OutRows).

% Translate a Row to a List
row_to_list(Row, List) :- Row =.. [row | List].
% Translate a List to a Row
list_to_row(List, Row) :- Row =.. [row | List].

% For each student, process the data and return a list of new data
processData([], []).
processData([H|T], [H2|T2]) :- category(H, H2), processData(T, T2).

% Assign a student to their Housing Category of best fit
category([A, B, _, D, E, _], [A, B, 'OffCampus']) :- E = 'Yes'; D = '< 5 mi'; D = '< 25 mi'.
category([A, B, C, D, E, F], [A, B, 'Single']) :- D = '>= 25 mi', E = 'No', (F = 'No'; C > 8).
category([A, B, C, D, E, F], [A, B, 'Double']) :- D = '>= 25 mi', E = 'No', F = 'Yes', C >= 4, C =< 8.
category([A, B, C, D, E, F], [A, B, 'Quad']) :- D = '>= 25 mi', E = 'No', F = 'Yes', C < 4.