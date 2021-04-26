(** Parsing and Display of player commands. *)

(**********************************************************************
 
 **********************************************************************)

(** The type [invest] represents the purchase/sale of shares that can be
    part of a player command, where, no element of the list should
    contain any leading, internal, or trailing spaces. The list is in
    the same order as the words in the original player command. For
    example: - If the player command is ["buy TSLA 50"], then the invest
    is [\["TSLA"; "50"\]]. - The first element in the invest list
    represents the stock symbol and the second element is the #shares
    purchased/sold in the transaction The [invest] list is not permitted
    to be the empty list. *)
type invest = string list

(** The type [command] represents a player command that is decomposed
    into a verb and possibly an object phrase. *)
type command =
  | Buy of invest
  | Sell of invest
  | Cash
  | Networth
  | Checkstock of invest
  | Help

(** Raised when an empty command is parsed. *)
exception EmptyCommand

(** Raised when a bad command is encountered. *)
exception BadCommand

(** [parse str] parses a player's input into a [command], as follows.
    The first word (i.e., consecutive sequence of non-space characters)
    of [str] becomes the activity, so the player can buy/sell shares or
    choose to display cash/networth. Examples: - [parse "buy TSLA 50"]
    is [Buy \["TSLA"; "50"\]] - [parse "cash"] is [Cash].

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space
    characters (only ASCII character code 32; not tabs or newlines,
    etc.). Raises: [EmptyCommand] if [str] is the empty string or
    contains only spaces. Raises: [BadCommand] if the command is bad. A
    command is {i bad} if the verb is neither "buy" nor "sell", or if
    the verb is "cash" / "networth" and there is a non-empty invest
    list, or if the verb is "buy" / "sell" and there is an empty invest
    list.*)
val parse : string -> command

(** [view com u] executes the parsed command that was the player's input
    and displays on the command line. If the user tries to buy/sell a
    stock whose share doesn't exist in the market then Not_Found
    exception is raised. Examples: - [view Cash] : displays current cash
    of user - [view Networth] : displays current networth of user -
    [view Buy ["COKE" ; "50"]] : changes portfolio of user by purchasing
    50 stocks of "COKE" if exists in the market. - [view Sell ["COKE" ;
    "50"]] : changes portfolio of user by selling 50 stocks of "COKE" if
    exists in the market. Raises: [Not_Found] if the share being
    sold/bought does not exist i.e the company is not included in
    [stocks] Stock.t list in Init. *)
val view : command -> User.t -> unit
