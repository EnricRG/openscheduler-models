%%%% Description
%  Version 2 of the first ScaDULER MiniZinc model that aims to represent a general model for a sheduling problem.
%
%  Model traits:
%  - Time is not explicit. Days are divided in time slots, and event duration is measured also in slots.

%%%% Imported predicates
include "globals.mzn";

%%%% Predicates

predicate within(var int: v, var int: min, var int: max) =
  min <= v /\ v <= max;

% Source: MiniZinc Cheat Sheet
predicate no_overlap(var int: start0, var int: duration0,
                     var int: start1, var int: duration1) =
  start0 + duration0 <= start1 \/ start1 + duration1 <= start0;

predicate overlap(var int: e1_start, var int: e1_dur, var int: e2_start, var int: e2_dur) =
  not no_overlap(e1_start, e1_dur, e2_start, e2_dur);
  
%%%% Model parameters and derived sets

%%% Days
int: nDays; %Number of days for the schedule
set of int: Days = 1..nDays; % Set derived from nDays
array[Days] of int: daySlots; % Number of time slots per day
constraint forall(day in Days) (daySlots[day]>=0);

%%% Events 
int: nEvents; % Number of events
set of int: Events = 1..nEvents; % Set derived from nEvents

% For each Event we know in advance its duration in time slots.
array[Events] of int: eventDuration;
constraint forall(e in Events) (eventDuration[e] > 0); % Event duration must be positive

%%% Resources
int: nResources; % Number of resources
set of int: Resources = 1..nResources; % Set derived from nResources

%%% Parametric constraints

%%% TODO types of constraints, constraint identified by an ID, 
%% constraint forall constraints (no ocurrences)

output ["\(daySlots)"];
