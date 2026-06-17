extends Node


signal cards_nb_changed
signal deck_changed


var first_card : Card
var last_card : Card
var cards_nb := 0
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
	load_deck()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_pack(pack):
	var all_files = DirAccess.get_files_at("user://packs/%s" % pack)
	var nb_problems = (all_files.size() - 1) / 4
	for i in nb_problems:
		Decks.add_card(pack,"p%04d" % (i+1), "s%04d" % (i+1))
	Decks.packs.append(pack)
	cards_nb_changed.emit()
	deck_changed.emit()


func add_card(pack, recto, verso, position = -1):
	if cards_nb == 0:
		first_card = Card.new(pack, recto, verso, null, null)
		last_card = first_card
		cards_nb = 1
	elif position == 0:
		var new_card = Card.new(pack, recto, verso, null, first_card)
		first_card.prev = new_card
		first_card = new_card
		cards_nb += 1
	elif position == -1 or position == cards_nb:
		var new_card = Card.new(pack, recto, verso, last_card, null)
		last_card.next = new_card
		last_card = new_card
		cards_nb += 1
	else :
		var current_card_at_pos = get_card_at(position)
		var new_card = Card.new(pack, recto, verso, current_card_at_pos.prev, current_card_at_pos)
		current_card_at_pos.prev.next = new_card
		current_card_at_pos.prev = new_card
		cards_nb += 1


func get_card_at(position):
	var current_card_at_pos = first_card
	for i in position-1:
		current_card_at_pos = current_card_at_pos.next
	return current_card_at_pos


func move_first_card_to(new_position):
	if cards_nb <=1 or new_position == 0: return
	#var new_pos = new_position
	#if new_position >= cards_nb : new_pos = cards_nb-1
	var next_first_card = first_card.next
	if new_position == -1 or new_position == cards_nb:
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
	deck_changed.emit()


func remove_pack(pack):
	var current_card_at_pos = first_card
	var removed_cards = []
	while current_card_at_pos:
		var next_card = current_card_at_pos.next
		if current_card_at_pos.pack == pack:
			removed_cards.append([current_card_at_pos.pack, current_card_at_pos.recto, current_card_at_pos.verso])
			remove_card(current_card_at_pos)
		current_card_at_pos = next_card
	packs.erase(pack)
	cards_nb_changed.emit()
	deck_changed.emit()
	## remember cards placement for next time
	#var json_string = JSON.stringify(removed_cards)
	#var save_file = FileAccess.open("user://pack_%s.save" % pack, FileAccess.WRITE)
	#save_file.store_line(json_string)
	#save_file.close()


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
	cards_nb -= 1


func save_deck():
	#save
	var current_deck = []
	var current_card = first_card
	while current_card:
		current_deck.append([current_card.pack, current_card.recto, current_card.verso])
		current_card = current_card.next
	var json_string = JSON.stringify(current_deck)
	var save_file = FileAccess.open("user://current_deck.save", FileAccess.WRITE)
	save_file.store_line(json_string)
	save_file.close()


func load_deck():
	var save_file = FileAccess.open("user://current_deck.save", FileAccess.READ)
	if not save_file : return

	var json = JSON.new()
	var json_string = save_file.get_line()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_ARRAY:
			for card in data_received:
				if not packs.has(card[0]) :
					packs.append(card[0])
				Decks.add_card(card[0], card[1], card[2])
			Decks.deck_changed.emit()
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		print(json_string)

	save_file.close()
