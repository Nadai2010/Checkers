use dojo_starter::models::Piece;
use dojo_starter::models::Position;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn can_choose_piece(ref self: T, coordinates_position: Position) -> bool;
    fn move_piece(ref self: T, coordinates_position: Position);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, update_piece_position};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Piece, Position};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub player: ContractAddress,
        pub position: Position,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world(@"dojo_starter");

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Update the world state with the new data.

            // Create the pieces for the player. Upper side of the board.
            let piece01 = Piece {
                player, position: Position { x: 0, y: 1 }, is_king: false, is_alive: true
            };
            let piece03 = Piece {
                player, position: Position { x: 0, y: 3 }, is_king: false, is_alive: true
            };
            let piece05 = Piece {
                player, position: Position { x: 0, y: 5 }, is_king: false, is_alive: true
            };
            let piece07 = Piece {
                player, position: Position { x: 0, y: 7 }, is_king: false, is_alive: true
            };
            let piece10 = Piece {
                player, position: Position { x: 1, y: 0 }, is_king: false, is_alive: true
            };
            let piece12 = Piece {
                player, position: Position { x: 1, y: 2 }, is_king: false, is_alive: true
            };
            let piece14 = Piece {
                player, position: Position { x: 1, y: 4 }, is_king: false, is_alive: true
            };
            let piece16 = Piece {
                player, position: Position { x: 1, y: 6 }, is_king: false, is_alive: true
            };
            let piece21 = Piece {
                player, position: Position { x: 2, y: 1 }, is_king: false, is_alive: true
            };
            let piece23 = Piece {
                player, position: Position { x: 2, y: 3 }, is_king: false, is_alive: true
            };
            let piece25 = Piece {
                player, position: Position { x: 2, y: 5 }, is_king: false, is_alive: true
            };
            let piece27 = Piece {
                player, position: Position { x: 2, y: 7 }, is_king: false, is_alive: true
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

        fn can_choose_piece(ref self: ContractState, coordinates_position: Position) -> bool {
            let mut world = self.world(@"dojo_starter");

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Get the player's piece from the world by its coordinates.
            let piece: Piece = world.read_model((player, coordinates_position));

            // Check if the piece belongs to the player and is alive.
            piece.position.x == coordinates_position.x
                && piece.position.y == coordinates_position.y
                && piece.is_alive == true
                && piece.is_king == false
        }

        // Implementation of the move function for the ContractState struct.
        fn move_piece(ref self: ContractState, coordinates_position: Position) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world(@"dojo_starter");

            let player = get_caller_address();

            // Retrieve the player's piece from the world by its coordinates.
            let mut piece: Piece = world.read_model((player, coordinates_position));

            // Update the piece's position based on the new coordinates.
            let updated_piece = update_piece_position(piece, coordinates_position);

            // Write the new position to the world.
            world.write_model(@updated_piece);
            // Emit an event to the world to notify about the player's move.
            world.emit_event(@Moved { player, position: coordinates_position });
        }
    }
}
// Todo: Improve this function to check if the new position is valid.
fn update_piece_position(mut piece: Piece, coordinates_position: Position) -> Piece {
    piece.position.x = coordinates_position.x;
    piece.position.y = coordinates_position.y;
    piece.is_alive = true;
    return piece;
}
