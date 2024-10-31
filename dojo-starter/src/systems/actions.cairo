use dojo_starter::models::Piece;
use dojo_starter::models::Vec2;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn can_choose_piece(ref self: T, coordinates_vec2: Vec2) -> bool;
    fn move(ref self: T, coordinates_vec2: Vec2);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, next_position};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Piece, Vec2};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub player: ContractAddress,
        pub vec2: Vec2,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world(@"dojo_starter");

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Update the world state with the new data.

            // 1. Move the player's position 10 units in both the x and y direction.
            let piece01 = Piece {
                player, vec: Vec2 { x: 0, y: 1 }, is_king: false, is_alive: true
            };
            let piece03 = Piece {
                player, vec: Vec2 { x: 0, y: 3 }, is_king: false, is_alive: true
            };
            let piece05 = Piece {
                player, vec: Vec2 { x: 0, y: 5 }, is_king: false, is_alive: true
            };
            let piece07 = Piece {
                player, vec: Vec2 { x: 0, y: 7 }, is_king: false, is_alive: true
            };
            let piece10 = Piece {
                player, vec: Vec2 { x: 1, y: 0 }, is_king: false, is_alive: true
            };
            let piece12 = Piece {
                player, vec: Vec2 { x: 1, y: 2 }, is_king: false, is_alive: true
            };
            let piece14 = Piece {
                player, vec: Vec2 { x: 1, y: 4 }, is_king: false, is_alive: true
            };
            let piece16 = Piece {
                player, vec: Vec2 { x: 1, y: 6 }, is_king: false, is_alive: true
            };
            let piece21 = Piece {
                player, vec: Vec2 { x: 2, y: 1 }, is_king: false, is_alive: true
            };
            let piece23 = Piece {
                player, vec: Vec2 { x: 2, y: 3 }, is_king: false, is_alive: true
            };
            let piece25 = Piece {
                player, vec: Vec2 { x: 2, y: 5 }, is_king: false, is_alive: true
            };
            let piece27 = Piece {
                player, vec: Vec2 { x: 2, y: 7 }, is_king: false, is_alive: true
            };

            // Write the new position to the world.
            world.write_model(@piece01);
            world.write_model(@piece03);
            world.write_model(@piece05);
            world.write_model(@piece07);
            world.write_model(@piece10);
            world.write_model(@piece12);
            world.write_model(@piece14);
            world.write_model(@piece16);
            world.write_model(@piece21);
            world.write_model(@piece23);
            world.write_model(@piece25);
            world.write_model(@piece27);
        }
        //

        fn can_choose_piece(ref self: ContractState, coordinates_vec2: Vec2) -> bool {
            let mut world = self.world(@"dojo_starter");

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Get the player's current position from the world.
            let mut piece: Piece = world.read_model((player, coordinates_vec2));

            // Check if the piece is in the player's position.
            piece.vec.x == coordinates_vec2.x
                && piece.vec.y == coordinates_vec2.y
                && piece.is_alive == true
                && piece.is_king == false
        }

        // Implementation of the move function for the ContractState struct.
        fn move(ref self: ContractState, coordinates_vec2: Vec2) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world(@"dojo_starter");

            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let mut piece: Piece = world.read_model((player, coordinates_vec2));

            // Calculate the player's next position based on the provided direction.
            let next = next_position(piece, coordinates_vec2);

            // Write the new position to the world.
            world.write_model(@next);
            // Write the new moves to the world.
            // Emit an event to the world to notify about the player's move.
            world.emit_event(@Moved { player, vec2: coordinates_vec2 });
        }
    }
}
// Define function like this:
fn next_position(mut piece: Piece, coordinates_vec2: Vec2) -> Piece {
    piece.vec.x = coordinates_vec2.x;
    piece.vec.y = coordinates_vec2.y;
    piece.is_alive = true;
    return piece;
}

