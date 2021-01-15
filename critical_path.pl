% LATE START.
% Computes the critical path from the task to the end of the graph.
criticalPathLSTask(Task, GivenPath, Time, Check) :-	
	prerequisite(Prereq, Task),
	criticalPathLSTask(Prereq, Task, GivenPath, Time, Check),
	sum_listLS1(G, 0, Y, Time, Check).

criticalPathLSTask(Prereq, Task, GivenPath, Time, Check) :-
	prerequisite(X, Prereq),
	criticalPathLSTask(X, Task, GivenPath, Time, Check).
	
criticalPathLSTask(Prereq, Task, GivenPath, Time, Check):-
	prerequisite(X, Task),
	\+ dif(X, Prereq),
	findall(Path, pathAlternate(Task, Prereq, Path), PathList),
	\+ dif(Check, Time),
	extractForSumLS(PathList, PathList, 0, GivenPath, Time, Check).

criticalPathLSTask(Prereq, Task, GivenPath, Time, Check) :-
	\+ prerequisite(X, Prereq),
	findall(Path, pathLS(Prereq, Task, Path), PathList),
	\+ dif(Check, Time),
	extractForSumLS(PathList, PathList, 0, GivenPath, Time, Check).
	
% To evaluate late start.
lateStart(Task, Time) :-
	criticalPathLSTask(Task, CriticalPath, Time, Time),
	sum_listLS1(CriticalPath, MaxSum2, [], Time, Time).
	
% Determining the end node of the graph.
endNodeLS(Task, MaxSum, Time, Check):-
	prerequisite(X, Task),
	endNodeLS(X, MaxSum, Time, Check).
	
endNodeLS(Task, MaxSum, Time, Check):-
	\+ prerequisite(X, Task),
	criticalPathLSWhole(Task, [MaxSum], Time, Check).

% Reversing the input.
reverse([],Z,Z).
reverse([H|T],Z,Acc) :- 
	reverse(T,Z,[H|Acc]).

% Computes the sum of the list.
sum_listLS2([], 0, Time, Check).
sum_listLS2([H|T], Sum, Time, Check) :-
	sum_listLS2(T, Rest, Time, Check),
	duration(H, X),
	Sum is X + Rest.

% Exaluates the late start time.
checkcriticalPathLS(Sequence, [GivenPath], Time, Check):-
	reverse(Sequence, NewSequence),
	reverse(NewSequence,[Vall|Seqq]),
	\+prerequisite(Vall, Xxxx),
	sum_listLS2(Sequence, CriticalSum, Time, Check),
	Time is CriticalSum - GivenPath.

checkcriticalPathLS(Sequence, GivenPath, Time, Check):-
	\+ dif(Check, Time),
	sum_listLS2(Sequence, MaxSum, Time, 2),
	reverse(Sequence, [Vall|NewSequence]),
	endNodeLS(Vall, MaxSum, Time, 2).
	
% Checks if the path sent is the critical path.
checkifCriticalLS([Max|MaxList], MaxValue, GivenPath, Time, Check):-
	\+ dif(Max, MaxValue),
	checkcriticalPathLS(MaxList, GivenPath, Time, Check).

checkifCriticalLS([Max|MaxList], MaxValue, GivenPath, Time, Check):-
	dif(Max, MaxValue).

% Computes the total duration of the path.
pathDurationLS([], MaxValue, GivenPath, Time, Check):- !.
	
pathDurationLS([MaxList|PathList], MaxValue, GivenPath, Time, Check):-
	checkifCriticalLS(MaxList,MaxValue, GivenPath, Time, Check),
	pathDurationLS(PathList, MaxValue, GivenPath, Time, Check).

% Gets all paths and their durations.
getPathLS([],[], Sums, PathList, GivenPath, Time, Check):-
	max_list(Sums, MaxValue),
	pathDurationLS(PathList, MaxValue, GivenPath, Time, Check).

getPathLS([PathList|A], [Values|R],SumLists, Lis, GivenPath, Time, Check):-
	reverse(PathList, RevList),
	append([Values], RevList, NewRevList),
	append(Lis, [NewRevList], JList),	
	getPathLS(A,R,SumLists, JList, GivenPath, Time, Check).

% removing 0 from sum
removeheadLS([], R, PathList, GivenPath, Time, Check):-
	getPathLS(PathList, R,R, [], GivenPath, Time, Check).

removeheadLS([RR|R], Test, PathList, GivenPath, Time, Check):-
	removeheadLS([], R, PathList, GivenPath, Time, Check).

% Extracts each list from the list of lists.
extractForSumLS([],PathList, Sum, GivenPath, Time, Check):-
	flatten(Sum, R),
	removeheadLS(R, [], PathList, GivenPath, Time, Check).
	
extractForSumLS([H|T],Revs, Arr, GivenPath, Time, Check):-
	sum_listLS1(H, Sum, GivenPath, Time, Check),
	extractForSumLS(T,Revs,[Arr,Sum], GivenPath, Time, Check).

% Computes the sum of the list.
sum_listLS1([], 0, [], Time, Check):-
	!.
sum_listLS1([], 0, GivenPath, Time, Check).
sum_listLS1([H|T], Sum, GivenPath, Time, Check) :-
	sum_listLS1(T, Rest, GivenPath, Time, Check),
	duration(H, X),
	Sum is X + Rest.

% Computes the path when the task given is adjacent to the end node in the graph.
pathAlternate(Start, Destination, Path) :-
    pathAlternate(Start, Destination, [], Path).
	pathAlternate(Start, Start, _ , [Start]).
	pathAlternate(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Node, Start),
	    pathAlternate(Node, Destination, [Start|Visited], Nodes).

% Computes the path when the task given is at least 2 nodes away from the end node in the graph.
pathLS(Start, Destination, Path) :-
    pathLS(Start, Destination, [], Path).
	pathLS(Start, Start, _ , [Start]).
	pathLS(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Start, Node),
	    pathLS(Node, Destination, [Start|Visited], Nodes).

% Computes the critical path of the whole graph.
criticalPathLSWhole(Task, GivenPath, Time, Check) :-	
	prerequisite(Task, Prereq),
	criticalPathLSWhole(Prereq, Task, GivenPath, Time, Check),
	sum_listLS1(G,0, Y, Time, Check).

criticalPathLSWhole(Prereq, Task, GivenPath, Time, Check) :-
	prerequisite(Prereq, X),
	criticalPathLSWhole(X, Task, GivenPath, Time, Check).
	
criticalPathLSWhole(Prereq, Task, GivenPath, Time, Check) :-
	\+ prerequisite(Prereq, X),
	findall(Path, pathLS(Task, Prereq, Path), PathList),
	extractForSumLS(PathList, PathList, 0, GivenPath, Time, Check).
	

	
	
% EARLY FINISH.
% Chooses the maximum value of all of the sums.
chooseMaxValueEF([MaxTime|RemSumList], SumList, GivenTime, Offset):-
    max_list(SumList, X),
    \+ dif(MaxTime, X),
	GivenTime is MaxTime.

chooseMaxValueEF([MaxTime|RemSumList], SumList, GivenTime, Offset):-
    max_list(SumList, X),
    dif(MaxTime, X),
    chooseMaxValueEF(RemSumList, RemSumList, GivenTime, Offset).

chooseMaxValueEF([], [], GivenTime, Offset):-
    !.

% Extracts each list from the list of lists.
extractForSumEF([],PathList, Sum, GivenTime, Offset):-
	flatten(Sum, R),
    chooseMaxValueEF(R, R, GivenTime, Offset).
	
extractForSumEF([H|T],Revs, Arr, GivenTime, Offset):-
	sum_listEF(H, Sum, GivenTime, Offset),
	extractForSumEF(T,Revs,[Arr,Sum], GivenTime, Offset).

% Computes the sum of the list.
sum_listEF([], 0, GivenTime, Offset).
sum_listEF([H|T], Sum, GivenTime, Offset) :-
	sum_listEF(T, Rest, GivenTime, Offset),
	duration(H, X),
	Sum is X + Rest.

% Computes the path from the start of the graph till the task.
pathEF(Start, Destination, Path) :-
    pathEF(Start, Destination, [], Path).
	pathEF(Start, Start, _ , [Start]).
	pathEF(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Start, Node),
	    pathEF(Node, Destination, [Start|Visited], Nodes).

% Computes the critical path of the task given.
criticalPathEF(Task, GivenTime, Offset) :-	
	prerequisite(Task, Prereq),
	criticalPathEF(Prereq, Task, GivenTime, Offset).

criticalPathEF(Task, GivenTime, Offset) :-
    \+ prerequisite(Task, Prereq),
    duration(Task, TaskDuration),
    GivenTime is TaskDuration.

criticalPathEF(Prereq, Task, GivenTime, Offset) :-
	prerequisite(Prereq, X),
	criticalPathEF(X, Task, GivenTime, Offset).
	
criticalPathEF(Prereq, Task, GivenTime, Offset) :-
	\+ prerequisite(Prereq, X),
	findall(Path, pathEF(Task, Prereq, Path), PathList),
	extractForSumEF(PathList, PathList, 0, GivenTime, Offset).

% Evaluates the early finish time of the task given.
earlyFinish(Task, GivenTime):-
    criticalPathEF(Task, GivenTime, 0).	
	
earlyFinish(Task, GivenTime, Offset):-
    criticalPathEF(Task, GivenTime, Offset).	
	
	

% MAX SLACK.
% Computes the maximum slack of the task.
computeMaxSlack(Task, Partialsum, Summm, Time, Offset):-
	earlyFinish(Task, Ef, Offset),
	Time is Partialsum - Ef.

% Retrieves the values for late start, early finish and the duration of the task.
maxSlack(Task, Time):-
	lateStart(Task, Ls),
	duration(Task, Dur),
	Partialsum is Ls+Dur,
	computeMaxSlack(Task, Partialsum, Summm, Time, Time).
	

	
	
% CRITICAL PATH.
% Checks if the given path is the critical path is equal to the critical path.
checkcriticalPathCP(Sequence, GivenPath):-
	\+ dif(Sequence, GivenPath).

% Checks if the given path is the critical path from the task.
checkifCriticalCP([Max|MaxList], MaxValue, GivenPath):-
	\+ dif(Max, MaxValue),
	checkcriticalPathCP(MaxList, GivenPath).

checkifCriticalCP([Max|MaxList], MaxValue, GivenPath):-
	dif(Max, MaxValue).
	
% Computes the total duration of the given path.
pathDurationCP([], MaxValue, GivenPath):- !.

pathDurationCP([MaxList|PathList], MaxValue, GivenPath):-
	checkifCriticalCP(MaxList,MaxValue, GivenPath),
	pathDurationCP(PathList, MaxValue, GivenPath).

% Gets all paths and their durations.
getPathCP([],[], Sums, PathList, GivenPath):-
	max_list(Sums, MaxValue),
	pathDurationCP(PathList,MaxValue, GivenPath).

getPathCP([PathList|A], [Values|R],SumLists, Lis, GivenPath):-
	reverse(PathList, RevList),
	append([Values], RevList, NewRevList),
	append(Lis, [NewRevList], JList),	
	getPathCP(A,R,SumLists, JList, GivenPath).

% removing 0 from sum
removeheadCP([], R, PathList, GivenPath):-
	getPathCP(PathList, R,R, [], GivenPath).

removeheadCP([RR|R], Test, PathList, GivenPath):-
	removeheadCP([], R, PathList, GivenPath).

% Extracts each list from the list of lists.
extractForSumCP([],PathList, Sum, GivenPath):-
	flatten(Sum, R),
	removeheadCP(R, [], PathList, GivenPath).
	
extractForSumCP([H|T],Revs, Arr, GivenPath):-
	sum_listCP(H, Sum, GivenPath),
	extractForSumCP(T,Revs,[Arr,Sum], GivenPath).

% Computes the sum of the list.
sum_listCP([], 0, GivenPath).
sum_listCP([H|T], Sum, GivenPath) :-
	sum_listCP(T, Rest, GivenPath),
	duration(H, X),
	Sum is X + Rest.

% Computes the path from the start node to the task.
pathCP(Start, Destination, Path) :-
    pathCP(Start, Destination, [], Path).
	pathCP(Start, Start, _ , [Start]).
	pathCP(Start, Destination, Visited, [Start|Nodes]) :-
	    \+ member(Start, Visited),
	    dif(Start, Destination),
	    prerequisite(Start, Node),
	    pathCP(Node, Destination, [Start|Visited], Nodes).

% Evaluates the critical path that is computed with the given path.
criticalPath(Task, GivenPath) :-	
	prerequisite(Task, Prereq),
	criticalPath(Prereq, Task, GivenPath),
	sum_listCP(G, 0, Y).

criticalPath(Prereq, Task, GivenPath) :-
	prerequisite(Prereq, X),
	criticalPath(X, Task, GivenPath).
	
criticalPath(Prereq, Task, GivenPath) :-
	\+ prerequisite(Prereq, X),
	findall(Path, pathCP(Task, Prereq, Path), PathList),
	extractForSumCP(PathList, PathList, 0, GivenPath).