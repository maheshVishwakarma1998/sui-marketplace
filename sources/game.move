module shoe_store::store {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer_policy::{Self as tp};
    use sui::package::{Self, Publisher};
    use sui::transfer;

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
    /// Publisher capability object
    struct ShoePublisher has key { id: UID, publisher: Publisher }

     // one time witness 
    struct STORE has drop {}

    // Only owner of this module can access it.
    struct AdminCap has key {
        id: UID,
    }

    // =================== Initializer ===================
    fun init(otw:STORE, ctx: &mut TxContext) {
        // define the publisher
        let publisher_ = package::claim<STORE>(otw, ctx);
        // wrap the publisher and share.
        transfer::share_object(ShoePublisher {
            id: object::new(ctx),
            publisher: publisher_
        });
        // transfer the admincap
        transfer::transfer(AdminCap{id: object::new(ctx)}, tx_context::sender(ctx));
    }

    /// Users can create new kiosk for marketplace 
    public fun new(ctx: &mut TxContext) : KioskOwnerCap {
        let(kiosk, kiosk_cap) = kiosk::new(ctx);
        // share the kiosk
        transfer::public_share_object(kiosk);
        kiosk_cap
    }
    // create any transferpolicy for rules 
    public fun new_policy(publish: &ShoePublisher, ctx: &mut TxContext ) {
        // set the publisher
        let publisher = get_publisher(publish);
        // create an transfer_policy and tp_cap
        let (transfer_policy, tp_cap) = tp::new<Shoe>(publisher, ctx);
        // transfer the objects 
        transfer::public_transfer(tp_cap, tx_context::sender(ctx));
        transfer::public_share_object(transfer_policy);
    }
    // Function to add a new shoe to the store
    public fun new_shoe(name: String, description: String, price: u64, stock: u64, color: String, size: u64, ctx: &mut TxContext): Shoe {
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

    // =================== Helper Functions ===================

    // return the publisher
    fun get_publisher(shared: &ShoePublisher) : &Publisher {
        &shared.publisher
     }

    #[test_only]
    // call the init function
    public fun test_init(ctx: &mut TxContext) {
        init(STORE {}, ctx);
    }
}
