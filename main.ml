open Game
open Stock
open Interaction
open Init
open Stock_history
open User

let prompt_str = "> "

let print_cd apy =
  let six_month_apy = Cd.match_new_rate Cd.SixMonths apy in
  let three_yr_apy = Cd.match_new_rate Cd.ThreeYears apy in
  let apy_str_6mnth = string_of_float (100. *. six_month_apy) in
  let apy_str_1yr = string_of_float (100. *. apy) in
  let apy_str_3yrs = string_of_float (100. *. three_yr_apy) in
  let apy_str =
    apy_str_6mnth ^ "%\t\t" ^ apy_str_1yr ^ "%\t\t" ^ apy_str_3yrs ^ "%"
  in
  let terms = "CD Term: 6 months(1)\t1 year(2)\t3 years(3)" in
  print_endline Init.bar;
  print_endline terms;
  print_endline ("APY:     " ^ apy_str);
  print_endline Init.bar

let print_index (s_lst : Stock.t list) (history : Index_history.i list)
    =
  let shares = "Shares: " in
  let ticker = "Ticker: " in
  let prices = "Price:  " in
  let user_stock_performance = "P/L:    " in
  let rec print_stocks_helper (his_lst : Index_history.i list)
      (lst : Stock.t list) n p g z =
    match lst with
    | [] ->
        print_endline Init.bar;
        print_endline n;
        print_endline p;
        print_endline g;
        print_endline z;
        print_endline Init.bar
    | h :: t ->
        print_stocks_helper his_lst t
          (n ^ Stock.get_ticker h ^ "\t")
          (p ^ string_of_float (get_current_price h) ^ "\t")
          ( g
          ^ string_of_int
              (Index_history.get_shares
                 (legal_index_history his_lst (Stock.get_ticker h)))
          ^ "\t" )
          ( z
          ^ string_of_float
              (checkindex h
                 (legal_index_history his_lst (Stock.get_ticker h)))
          ^ "\t" )
  in
  print_stocks_helper history s_lst ticker prices shares
    user_stock_performance

(* [print_stocks s_lst] prints the stocks in [s_lst]. *)
let print_stocks (s_lst : Stock.t list) (history : Stock_history.t list)
    =
  let shares = "Shares: " in
  let ticker = "Ticker: " in
  let prices = "Price:  " in
  let user_stock_performance = "P/L:    " in
  let rec print_stocks_helper (his_lst : Stock_history.t list)
      (lst : Stock.t list) n p g z =
    match lst with
    | [] ->
        print_endline Init.bar;
        print_endline n;
        print_endline p;
        print_endline g;
        print_endline z;
        print_endline Init.bar
    | h :: t ->
        print_stocks_helper his_lst t
          (n ^ Stock.get_ticker h ^ "\t")
          (p ^ string_of_float (get_current_price h) ^ "\t")
          ( g
          ^ string_of_int
              (get_shares
                 (legal_stock_history his_lst (Stock.get_ticker h)))
          ^ "\t" )
          ( z
          ^ string_of_float
              (checkstock h
                 (legal_stock_history his_lst (Stock.get_ticker h)))
          ^ "\t" )
  in
  print_stocks_helper history s_lst ticker prices shares
    user_stock_performance

let print_re (s_lst : Stock.t list)
    (history : Real_estate_history.r list) =
  let shares = "Shares: " in
  let ticker = "Ticker: " in
  let prices = "Price:  " in
  let user_stock_performance = "P/L:    " in
  let rec print_stocks_helper (his_lst : Real_estate_history.r list)
      (lst : Stock.t list) n p g z =
    match lst with
    | [] ->
        print_endline Init.bar;
        print_endline n;
        print_endline p;
        print_endline g;
        print_endline z;
        print_endline Init.bar
    | h :: t ->
        print_stocks_helper his_lst t
          (n ^ Stock.get_ticker h ^ "\t")
          (p ^ string_of_float (get_current_price h) ^ "\t")
          ( g
          ^ string_of_int
              (Real_estate_history.get_shares
                 (legal_re_history his_lst (Stock.get_ticker h)))
          ^ "\t" )
          ( z
          ^ string_of_float
              (checkre h
                 (legal_re_history his_lst (Stock.get_ticker h)))
          ^ "\t" )
  in
  print_stocks_helper history s_lst ticker prices shares
    user_stock_performance

(** [has_game_ended s] returns true when in-game time has reached or
    passed year 20 (nmonth 240). *)
let has_game_ended s =
  let current_time = int_of_float (Unix.time () -. !start_time) in
  let month = current_time / s in
  month >= 240

let end_game_function () =
  print_endline "TODO: End of game functionality"

(** [parse_input_helper] reads the user input and calls corresponding
    commands. *)
let parse_input_helper () =
  match read_line () with
  | exception End_of_file -> ()
  | line when line = "quit" -> exit 0
  | line when line = "cd" ->
      let p = getportfolio user in
      let cd_h = Portfolio.get_cd_history p in
      print_cd (Cd_history.get_current_apy cd_h)
  | line when line = "s" ->
      Stock.update_current_prices stocks !start_time;
      print_stocks stocks stock_history_lst
  | line when line = "i" ->
      Stock.update_current_prices index !start_time;
      print_index index index_history_lst
  | line when line = "re" ->
      Stock.update_current_prices re !start_time;
      print_re re re_history_lst
  | line -> (
      try Interaction.parse line user
      with _ -> print_endline "Invalid Command" )

(** [prompt_input] prompts user for input during the simulation. *)
let rec prompt_input () =
  if has_game_ended Game.s_per_month then end_game_function ()
  else (
    print_string prompt_str;
    parse_input_helper ();
    let time_elapsed =
      int_of_float (Unix.time () -. Game.get_start_time ())
    in
    print_endline (Game.str_of_year_month time_elapsed);
    print_endline Init.bar;
    prompt_input () )

(** [prompt_for_start] trims the user input and starts the game if the
    user types "start", quits the game if user types "quit". If neither,
    the user is prompted to again to choose. *)
let rec prompt_for_start () =
  print_string
    ("Type [start] to begin, or [quit] to exit game.\n" ^ prompt_str);
  match read_line () with
  | exception End_of_file -> ()
  | line ->
      let trimmed = String.trim line in
      if trimmed = "start" then (
        Game.update_start_time (Unix.time ());
        prompt_input () )
      else if trimmed = "quit" then exit 0
      else prompt_for_start ()

let main () =
  print_endline Init.intro_string;
  print_endline Init.instructions;
  prompt_for_start ()

let () = main ()
