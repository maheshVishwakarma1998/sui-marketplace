module shoe_store::store {
    use sui::object::{Self, UID, ID};
    use sui::tx_context::TxContext;
    use sui::mutex::Mutex;

    const E_SHOE_NOT_FOUND: u64 = 0;
    const E_INSUFFICIENT_STOCK: u64 = 1;
    const E_INVALID_INPUT: u64 = 2;

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
        shoe_id: ID,
        buyer: address,
        quantity: u64,
        total_cost: u64,
    }

    // Mutex for concurrent access to shoe stock
    let stock_lock: Mutex<u8>;

    // Function to add a new shoe to the store
    public fun add_shoe(name: String, description: String, price: u64, stock: u64, color: String, size: u64, ctx: &mut TxContext) {
        assert(price > 0, E_INVALID_INPUT);
        assert(stock > 0, E_INVALID_INPUT);
        
        let new_shoe = Shoe {
            id: object::new(ctx),
            name,
            description,
            price,
            stock,
            color,
            size,
        };

        object::save(new_shoe);
    }

    // Function to get all shoes in the store
    public fun get_shoes(): Vec<Shoe> {
        object::all()
    }

    // Function to get a specific shoe by its ID
    public fun get_shoe(shoe_id: ID): Shoe? {
        object::get<Shoe>(shoe_id)
    }

    // Function to delete a shoe from the store
    public fun delete_shoe(shoe_id: ID, ctx: &mut TxContext) {
        object::delete<Shoe>(shoe_id);
    }

    // Function to update the stock of a shoe
    public fun update_stock(shoe_id: ID, new_stock: u64) {
        stock_lock.acquire();
        let mut shoe = object::get_mut<Shoe>(shoe_id)
            .unwrap_or_else(|| abort(E_SHOE_NOT_FOUND));
        
        shoe.stock = new_stock;
        stock_lock.release();
    }

    // Function to purchase a shoe and update stock
    public fun purchase_shoe(shoe_id: ID, quantity: u64, ctx: &mut TxContext) -> ShoeOrder? {
        stock_lock.acquire();
        let mut shoe = object::get_mut<Shoe>(shoe_id)
            .unwrap_or_else(|| abort(E_SHOE_NOT_FOUND));

        if shoe.stock < quantity {
            stock_lock.release();
            abort(E_INSUFFICIENT_STOCK);
        }
        
        shoe.stock -= quantity;
        let total_cost = shoe.price * quantity;

        let order = ShoeOrder {
            id: object::new(ctx),
            shoe_id,
            buyer: tx_context::sender(ctx),
            quantity,
            total_cost,
        };

        stock_lock.release();
        Some(order)
    }

    // Function to get a shoe order by its ID
    public fun get_shoe_order(order_id: ID): ShoeOrder? {
        object::get<ShoeOrder>(order_id)
    }
}
