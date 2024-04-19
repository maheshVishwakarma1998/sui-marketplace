module shoe_store::store {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use std::string::{String};

    struct Shoe has key, store {
        id: UID,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        color: String,
        size: u64,
    }

    // Function to add a new shoe to the store
    public fun new(name: String, description: String, price: u64, stock: u64, color: String, size: u64, ctx: &mut TxContext): Shoe {
        Shoe {
            id: object::new(ctx),
            name,
            description,
            price,
            stock,
            color,
            size,
        }
    }

    // Function to get all shoes in the store
    public fun get_shoes(store: &Shoe): &Shoe {
        store
    }

    // Function to delete a shoe from the store
    public fun delete_shoe(shoe: Shoe) {
        let Shoe { id, name: _, description: _, price: _, stock: _, color: _, size: _ } = shoe;
        object::delete(id);
    }

    // Function to update the stock of a shoe
    public fun update_stock(shoe: &mut Shoe, new_stock: u64) {
        shoe.stock = new_stock;
    }
    public fun update_name(shoe: &mut Shoe, name_: String) {
        shoe.name = name_;
    }
     public fun update_description(shoe: &mut Shoe, description: String) {
        shoe.description = description;
    }
    public fun update_price(shoe: &mut Shoe, price: u64) {
        shoe.price = price;
    }
    public fun update_color(shoe: &mut Shoe, color: String) {
        shoe.color = color;
    }
}
