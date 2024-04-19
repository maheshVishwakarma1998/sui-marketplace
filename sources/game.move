module shoe_store::store {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use std::string::{String};

    const EInsufficientStock: u64 = 0;

    struct Shoe has key, store {
        id: UID,
        name: String,
        description: String,
        price: u64,
        stock: u64,
        color: String,
        size: u64,
    }

    struct ShoeOrder has key, store {
        id: UID,
        shoeId: ID,
        buyer: address,
        quantity: u64,
        totalCost: u64,
    }

    // Function to add a new shoe to the store
    public fun add_shoe(name: String, description: String, price: u64, stock: u64, color: String, size: u64, ctx: &mut TxContext): Shoe {
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

    // Function to purchase a shoe and update stock
    public fun purchase_shoe(shoe: &mut Shoe, quantity: u64, ctx: &mut TxContext): ShoeOrder {
        assert!(shoe.stock >= quantity, EInsufficientStock);
        shoe.stock = shoe.stock - quantity;
        let total_cost = shoe.price * (quantity as u64);
        let order = ShoeOrder {
            id: object::new(ctx),
            shoeId: object::id(shoe),
            buyer: tx_context::sender(ctx),
            quantity,
            totalCost: total_cost,
        };
        order
    }
}
