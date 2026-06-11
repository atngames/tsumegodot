extends Node


#var cards :Array[Card] = []
var first_card : Card
var last_card : Card
var card_nb := 0
var packs := []
var bookmarks

class Card :
	var pack
	var recto
	var verso
	var prev
	var next

	func _init(new_pack, new_recto, new_verso, new_prev, new_next):
		pack = new_pack
		recto = new_recto
		verso = new_verso
		prev = new_prev
		next = new_next

	func _to_string():

		return "[%s, %s, %s]" % [pack, recto, verso]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#for i in 9:
		#add_card("pack","p000%s.svg" % (i+1),"verso")

	#add_card("pack","p0009.svg","verso", 3)
	#add_card("pack","p0010.svg","verso", 3)
	#add_card("pack","p0011.svg","verso", 6)
	#add_card("pack","p0012.svg","verso", 3)

	#var current_card = first_card
	#for i in card_nb:
		#print(current_card)
		#current_card = current_card.next
#
	#print()
	#move_first_card_to(4)
	#current_card = first_card
	#for i in card_nb:
		#print(current_card)
		#current_card = current_card.next

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func get_prev_next_from_pos(position):
	#if cards.is_empty():
		#return [-1, -1]
	#if position == cards.size():
		#return[last_card, -1]
	#if position == 0:
		#return[-1, first_card]
	#var card_in_position := first_card
	#for i in position-1:
		#card_in_position = cards[card_in_position].next
	#return [card_in_position, cards[card_in_position].next]
	#

func add_card(pack, recto, verso, position = -1):
	#if position < 0:
		#position = cards.size()
	if card_nb == 0:
		first_card = Card.new(pack, recto, verso, null, null)
		last_card = first_card
		card_nb = 1
	elif position == 0:
		var new_card = Card.new(pack, recto, verso, null, first_card)
		first_card.prev = new_card
		first_card = new_card
		card_nb += 1
	elif position == -1 or position == card_nb:
		var new_card = Card.new(pack, recto, verso, last_card, null)
		last_card.next = new_card
		last_card = new_card
		card_nb += 1
	else :
		var current_card_at_pos = get_card_at(position)
		var new_card = Card.new(pack, recto, verso, current_card_at_pos.prev, current_card_at_pos)
		current_card_at_pos.prev.next = new_card
		current_card_at_pos.prev = new_card
		card_nb += 1


func get_card_at(position):
	var current_card_at_pos = first_card
	for i in position-1:
		current_card_at_pos = current_card_at_pos.next
	return current_card_at_pos


func move_first_card_to(new_position):
	if card_nb <=1 or new_position == 0: return
	#var new_pos = new_position
	#if new_position >= card_nb : new_pos = card_nb-1
	var next_first_card = first_card.next
	if new_position == -1 or new_position == card_nb:
		last_card.next = first_card
		first_card.prev = last_card
		last_card = first_card
		first_card.next = null
	else:
		var current_card_at_pos = get_card_at(new_position+1)
		current_card_at_pos.prev.next = first_card
		first_card.prev = current_card_at_pos.prev
		current_card_at_pos.prev = first_card
		first_card.next = current_card_at_pos
	first_card = next_first_card
	first_card.prev = null


func remove_pack(pack):
	var current_card_at_pos = first_card
	while current_card_at_pos:
		var next_card = current_card_at_pos.next
		if current_card_at_pos.pack == pack:
			remove_card(current_card_at_pos)
		current_card_at_pos = next_card
	packs.erase(pack)
	return current_card_at_pos


func remove_card(card_to_remove: Card):
	if card_to_remove.next and card_to_remove.prev :
		card_to_remove.prev.next = card_to_remove.next
		card_to_remove.next.prev = card_to_remove.prev
	elif card_to_remove.next :
		card_to_remove.next.prev = null
	elif card_to_remove.prev :
		card_to_remove.prev.next = null
	else :
		first_card = null
		last_card = null
	card_nb -= 1
