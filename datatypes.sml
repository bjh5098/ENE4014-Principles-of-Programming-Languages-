(*
datatype card = Jack of suit |
                Queen of suit |
                King of suit |
                Ace of suit |
                Num of suit * int
*)


datatype suit = Club | Diamond | Heart | Spade
datatype card_value = Jack | Queen | King 
                    | Ace | Num of int
datatype card =  Card of suit * card_value


val hands = [Card(Club, Jack), Card(Club, Num(10)), Card(Club, Ace)]
val hands2 = [Card(Club, Jack), Card(Diamond, Num(10)), Card(Club, Ace)]
val hands3 = [Card(Diamond, Num(10)), Card(Club, Ace), Card(Club, Jack)]
val hands4 = [Card(Diamond, Num(10)), Card(Club, Ace), Card(Club, Jack), Card(Spade, Ace)]

(* assume hand is not empty *)
fun is_flush (hand: card list) =
   case hand of 
        Card(_, _)::[] => true
      | Card(shape1, _)::Card(shape2, _)::_ =>  shape1 = shape2 andalso 
                                                 is_flush(tl hand)
      | _ => false


fun simpleSum(hand: card list) =
    case hand of 
          Card (_, Ace)::rest => 11 + simpleSum(rest)
        | Card (_, Num(i))::rest => i + simpleSum(rest)
        | Card (_, _)::rest => 10 + simpleSum(rest)
        | _ => 0


fun hasAce (hand: card list) =
    case hand of
         Card(_, Ace)::rest => true
       | Card(_, _)::rest => hasAce(rest)
       | _ => false

(* card list -> card list *)
fun removeAce (hand: card list) = 
    case hand of
         Card(_, Ace)::rest => rest
       | Card(_, _)::rest => (hd hand)::removeAce(rest)
       | _ => hand


(* Big-O complexity of blackjack? *)
fun blackjack(hand: card list) =
let val sum = simpleSum(hand)
in
    if sum <= 21
    then sum
    else
        if hasAce(hand)
        then 1 + blackjack(removeAce hand)
        else sum
end

(* blackjack, more efficient version *)
fun blackjack (score: int, hand: card list) =
  case hand of
      Card (_, Ace)::rest => let val try1 = blackjack(score+11, rest)
                             in
                               if try1 <= 21 
                               then try1
                               else blackjack(score+1, rest)
                             end
      | Card (_, Num(i))::rest => blackjack(score+i, rest)
      | Card (_, _)::rest => blackjack(score+10, rest)
      | _ => score

datatype exp = Constant of int
             | Negate   of exp
             | Add      of exp * exp
             | Multiply of exp * exp
             | If       of bool * exp * exp


(* creating exp tree *)
val ifExpr = If(true, Add(Constant 10, Constant 11),
                      Multiply(Constant 1, Constant 42))

(* evaluation of the exp tree *)
fun eval(e) = 
   case e of 
        Constant i  => i
      | Negate(e2)   => ~ (eval (e2))
      | Add(e1, e2)  => eval(e1) + eval(e2)
      | Multiply(e1, e2)  => eval(e1) * eval(e2)
      | If(true, e1, e2)  => eval(e1)
      | If(false, e1, e2)  => eval(e2)


fun max_of_two (i1, i2) =
    if i1 > i2 
    then i1
    else i2

(* max_constant: exp -> int *)
fun max_constant (e: exp) =
   case e of 
        Constant i  => i
      | Negate(e2)   => max_constant(e2)
      | Add(e1, e2)  => max_of_two(max_constant(e1), max_constant(e2))
      | Multiply(e1, e2)  => max_of_two(max_constant(e1), max_constant(e2))
      | If(_, e1, e2)  => max_of_two(max_constant(e1), max_constant(e2))

