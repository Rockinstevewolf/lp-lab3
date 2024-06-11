move(X, Y):- step(X, Y).
move(X, Y):- step(Y, X).

step([empty, X, A, B, C, D], [X, empty, A, B, C, D]).
step([A, empty, X, B, C, D], [A, X, empty, B, C, D]).
step([A, B, C, empty, X, D], [A, B, C, X, empty, D]).
step([A, B, C, D, empty, X], [A, B, C, D, X, empty]).

step([empty, A, B, X, C, D], [X, A, B, empty, C, D]).
step([A, empty, B, C, X, D], [A, X, B, C, empty, D]).
step([A, B, empty, C, D, X], [A, B, X, C, D, empty]).


prolong([X | T], [Y, X | T]):-
    move(X, Y),
    not(member(Y, [X | T])).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% В случае если X находится в начале очереди, получает состояние, где содержится X
path([[X | T] | _], X, [X | T]).

%Ищет все пути из текущего состояния и производит слияние этих путей с текущей очередью, после чего продолжает с новым состоянием в очереди
path([P | Q], B, R):-
    findall(X, prolong(P, X), L),
    append(Q, L, QL), !,
    path(QL, B, R).

% Перенаправляющее состояние, которое происходит, если не достигается конечное состояние B, то есть отправляет в хвост списка (очередь)
path([_ | Q], B, R):- path(Q, B, R).

% Поиск в ширину, где A - начальное условие, а B - конечное, R - реверсивный список состояний
bdth(A, B, R):- path([[A]], B, R).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Поиск в глубину
dpth([X|T], X, [X|T]).
dpth(P, F, L):- prolong(P, P1), dpth(P1, F, L).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Поиск в глубину с итеративным погружением
int(1).
int(X):-
    int(Y),
    X is Y + 1.

depth_id([Finish|T],Finish,[Finish|T],0).
depth_id(Path,Finish,R,N):-
    N > 0,
    prolong(Path,NewPath),
    N1 is N - 1,
    depth_id(NewPath,Finish,R,N1).

search_id(Start,Finish,Path):-
    int(Level),
    depth_id(Start,Finish,Path,Level).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Печать пути
print_ans([]).
print_ans([H|T]):- print_ans(T), print_one(H).

print_one([A,B,C,D,E,F]):-
    write('------------------------------------'), nl,
    write(A), write('   '),
    write(B), write('   '),
    write(C), write('   '), nl,
    write(D), write('   '),
    write(E), write('   '),
    write(F), write('   '), nl,
    write('------------------------------------'), nl.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


solve_bdth:-
    BEGIN = [table, chair, wardrobe, stool, empty, lounge],
    AIM = [_, _, lounge, _, _, wardrobe],
    write('Начало: '), nl,
    print_one(BEGIN),
    write('Цель:'), nl,
    print_one(AIM),

    write('     Поиск в ширину...'), nl,
    get_time(T1),
    bdth(BEGIN, AIM, R),
    get_time(T2),
    write('Ходы: '), nl,
    print_ans(R),
    length(R, Len),
    write('Длина пути: '), Length is Len-1, write(Length), nl,
    write('Время поиска в ширину: '),
    T is T2-T1,
    write(T), nl.

solve_dpth:-
    BEGIN = [table, chair, wardrobe, stool, empty, lounge],
    AIM = [_, _, lounge, _, _, wardrobe],
    write('Начало: '), nl,
    print_one(BEGIN),
    write('Цель:'), nl,
    print_one(AIM),

    write('     Поиск в глубину...'), nl,
    get_time(T1),
    dpth([BEGIN], AIM, L),
    get_time(T2),
    write('Ходы: '), nl,
    print_ans(L),
    T is T2 - T1,
    length(L, Len),
    write('Длина пути: '), Length is Len-1, write(Length), nl,
    write('Время работы поиска в глубину: '), write(T), nl.

solve_dpth_id:-
    BEGIN = [table, chair, wardrobe, stool, empty, lounge],
    AIM = [_, _, lounge, _, _, wardrobe],
    int(DepthLimit),
    get_time(T1),
    depth_id([BEGIN],AIM,Res,DepthLimit),
    get_time(T2),
    write('Ходы: '), nl,
    print_ans(Res),
    T is T2 - T1,
    length(Res, Len),
    write('Длина пути: '), Length is Len-1, write(Length), nl,
    write('Максимальный лимит глубины: '), write(DepthLimit), nl,
    write('Время работы поиска в глугину с итеративным погружением: '), write(T), nl.
