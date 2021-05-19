(* This module represents the data stored in stock_and_users files *)
(*The type of record stockHistory*)
(* type sh *)

(*The type of record user*)
type t

(* [create_user c sh_lst] is the type of user.t . It has the starting
   amount of [c] and the user net worth for the game. User starts with
   stock history of [sh_lst]. *)
val create_user :
  float ->
  Stock_history.t list ->
  Index_history.i list ->
  Cd_history.t ->
  Real_estate_history.r list ->
  t

(** [add_income_cash u amt] adds income of [amt] to user [u]'s cash. *)
val add_income_cash : t -> float -> unit

(*[get_net_worth u stocks_lst] return the net worth of the user. *)
val get_net_worth :
  t -> Stock.t list -> Stock.t list -> Stock.t list -> float

(*[get_cash u] return the cash of the user*)
val get_cash : t -> float

val get_length_stock_history : Stock_history.t list -> int -> int

val get_length_index_history : Index_history.i list -> int -> int

val get_length_re_history : Real_estate_history.r list -> int -> int

val getportfolio : t -> Portfolio.t

val checkstock : Stock.t -> Stock_history.t -> float

val find : 'a -> 'a list -> int

val change_cash_buy : t -> int -> Stock.t -> unit

val buy : string -> int -> t -> Stock.t -> unit

val sell : string -> int -> t -> Stock.t -> unit

val getportfolio : t -> Portfolio.t

val legal_stock_history :
  Stock_history.t list -> string -> Stock_history.t

val legal_index_history :
  Index_history.i list -> string -> Index_history.i

val legal_re_history :
  Real_estate_history.r list -> string -> Real_estate_history.r

val buy_index : string -> int -> t -> Stock.t -> unit

val sell_index : string -> int -> t -> Stock.t -> unit

val checkindex : Stock.t -> Index_history.i -> float

val buy_re : string -> int -> t -> Stock.t -> unit

val sell_re : string -> int -> t -> Stock.t -> unit

val checkre : Stock.t -> Real_estate_history.r -> float

val changecash_buycd : t -> float -> unit

val changecash_sellcd : t -> float -> unit

(** [buy_cd u amt t] buys a cd for user [u] for an amount [amt] and for
    a maturity length of [t]. Updates the user's cash. *)
val buy_cd : t -> float -> Cd.term -> unit

(** [sell_cd u i] sells the cd for user [u] at index [i]. Requires: [i]
    is a valid index in the list of currently owned cds. *)
val sell_cd : t -> int -> unit
