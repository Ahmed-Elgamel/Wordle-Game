main:-
  write("Welcome to Pro-Wordle!"),nl,write(----------------------),nl,
  build_kb,
  nl,
  write("Done building the words database..."),nl,
  write("The available categories are: "),
  categories(L),
  write(L),nl,
  choose_category,
  choose_length,
  
   guesses(X),          % this is a predicate that is added to the KB when the choose_length is executed
  
  
  write("Game started. You have "), write(X) ,write(" guesses."),nl,nl,
  play.
  
  
  
  
 

build_kb:-
  write("Please enter a word and its category on separate lines:"),nl,
  read(Input_1),
  ( 
    Input_1=done;
	
	read(Input_2),
	assert(word(Input_1,Input_2)),
	build_kb
	
  ).
  
  
  
  
play:-
 
 word_length(CHOSEN_LENGTH),
 guesses(Num_of_guesses),
 choosen_category(CATEGORY),
 pick_word(PICKED_WORD,CHOSEN_LENGTH,CATEGORY),
 % write(PICKED_WORD),nl,
 get_guess(Num_of_guesses,CHOSEN_LENGTH,Acceptable_guess),
 play(Num_of_guesses,PICKED_WORD,Acceptable_guess).
 
 
play(Num_of_guesses,PICKED_WORD,Acceptable_guess):-
 
  check_win(Acceptable_guess,PICKED_WORD);
  check_lost(Acceptable_guess,PICKED_WORD,Num_of_guesses);
  word_length(CHOSEN_LENGTH),
  atom_chars(Acceptable_guess,Acceptable_Guess_List),
  atom_chars(PICKED_WORD,PICKED_WORD_LIST),
  correct_letters(PICKED_WORD_LIST,Acceptable_Guess_List,CL),
  correct_positions(Acceptable_Guess_List,PICKED_WORD_LIST,CP),
  write("Correct letters are: "),write(CL),nl,
  write("Correct letters in correct positions are: "),write(CP),nl,
  Num_of_guesses1 is Num_of_guesses-1,
  write("Remaining Guesses are "),write(Num_of_guesses1),nl,nl,
  get_guess(Num_of_guesses1,CHOSEN_LENGTH,Acceptable_guess1),
  play(Num_of_guesses1,PICKED_WORD,Acceptable_guess1).
   
   
   
get_guess(Num_of_guesses,CHOSEN_LENGTH,Acceptable_guess):-
  write("Enter a word composed of "),write(CHOSEN_LENGTH),write(" letters:"),nl,
  read(INPUT_GUESS),
  (
  (atom_length(INPUT_GUESS,CHOSEN_LENGTH),Acceptable_guess=INPUT_GUESS);
  
  atom_length(INPUT_GUESS,INPUT_LENGTH),
  INPUT_LENGTH\=CHOSEN_LENGTH,
  write("Word is not composed of "),write(CHOSEN_LENGTH),write(" letters. Try again."),nl,
  write("Remaining Guesses are "),write(Num_of_guesses),nl,nl,
  get_guess(Num_of_guesses,CHOSEN_LENGTH,Acceptable_guess)
  
  ).
  

  
  

   
   

	
	
	
	
	
	

 

 
  
  
check_lost(INPUT_GUESS,Picked_word,Num_of_guesses):-

 Num_of_guesses=1,
 INPUT_GUESS\=Picked_word,
 write("You lost!"), !.
  
  
  
  
check_win(INPUT_GUESS,Picked_word):-
 INPUT_GUESS=Picked_word,
 write("You Won!") ,!.

  
  
  


  
  
  
  
  
choose_category:-
  write("Choose a category:"),nl,
  read(CATEGORY),
  (
     (is_category(CATEGORY),assert(choosen_category(CATEGORY)));
	 write("This category does not exist."),nl,
	 choose_category
	 
  
  ).
  
  
  
  
  
  
choose_length:-
  write("Choose a length:"),nl,
  read(LENGTH),
  (
    (
     choosen_category(C),
     pick_word(_,LENGTH,C),
     LENGTH1 is LENGTH+1, 
	 assert(word_length(LENGTH)),
     assert(guesses(LENGTH1))
    );
	write("There are no words of this length."),nl,
	choose_length
  
  ).
  
  
  
  
  
  
  
  
  
  
  
is_category(C):-
  word(_,C).
  
  

categories(L):-
  setof(X,Y^word(Y,X),L).

/*

categories(L):-
 categories([],L).

categories(ACC,L):-
 word(_,C),
 \+member(C,ACC),
 append(ACC,[C],NewAcc),
 categories(NewAcc,L),!.
  
categories(ACC,ACC).
  
*/ 







available_length(L):-
  word(W,_),
  atom_length(W,LENGTH),
  LENGTH=L.
  
  
pick_word(W,L,C):-
  word(W,C),
  atom_length(W,LENGTH),
  LENGTH=L.
  


  


correct_letters(L1,L2,CL):-
  correct_letters(L1,L2,[],CL1),
  reverse(CL1,CL).


correct_letters(_,[],ACC,ACC).

correct_letters(L1,[H2|T2],ACC,CL):-
  member(H2,L1),
  \+member(H2,ACC),
  NEWACC=[H2|ACC],
  correct_letters(L1,T2,NEWACC,CL).
  
correct_letters(L1,[H2|T2],ACC,CL):-
  ( \+member(H2,L1) ; member(H2,ACC) ),
  correct_letters(L1,T2,ACC,CL).

  
  
  
  
  
correct_positions([],[],[]).

correct_positions(L1,L2,CP):-
  L1=[H1|T1],
  L2=[H2|T2],
  H1=H2,
  correct_positions(T1,T2,T3),
  CP=[H1|T3].
  
correct_positions(L1,L2,CP):-
  L1=[H1|T1],
  L2=[H2|T2],
  H1\==H2,
  correct_positions(T1,T2,CP).  
  