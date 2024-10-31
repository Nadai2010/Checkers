use dojo_starter::models::Direction;
use dojo_starter::models::Position;
use dojo_starter::models::Vec2;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn move(ref self: T, coordinates_vec2: Vec2);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, next_position};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Position, Vec2, Moves, Direction, DirectionsAvailable};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;


    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            // Get the default world.
            let mut world = self.world(@"dojo_starter");

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();
            // Retrieve the player's current position from the world.
            //let mut position: Position = world.read_model(player);

            // Update the world state with the new data.

            // 1. Move the player's position 10 units in both the x and y direction.
            let new_position = Position { player, vec: Vec2 { x: 0, y: 0 } };

            // Write the new position to the world.
            world.write_model(@new_position);
            // 2. Set the player's remaining moves to 100.
        //let moves = Moves { player, last_direction: Direction::None(()), can_move: true };

            // Write the new moves to the world.
        //world.write_model(@moves);

            //         fn choose_piece(ref self: ContractState, piece_position: Position) {
        //             // Get the default world.
        //             let mut world = self.world(@"dojo_starter");

            //             // Get the address of the current caller, possibly the player's address.
        //             let player = get_caller_address();

            //             // Get the player's current position from the world.
        //             let mut position: Position = world.read_model(player);

            //             // Check if the piece is in the player's position.
        //             if position.vec.x == piece_position.vec.x
        //                 && position.vec.y == piece_position.vec.y { // TODO: Choose the
        //                 piece.
        //             }
        }
        // Implementation of the move function for the ContractState struct.
        fn move(ref self: ContractState, coordinates_vec2: Vec2) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world(@"dojo_starter");

            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let mut position: Position = world.read_model(player);

            // Calculate the player's next position based on the provided direction.
            let next = next_position(position, coordinates_vec2);

            // Write the new position to the world.
            world.write_model(@next);
            // Write the new moves to the world.
        // Emit an event to the world to notify about the player's move.
        //world.emit_event(@Moved { player });
        }
    }
}
// Define function like this:
fn next_position(mut position: Position, coordinates_vec2: Vec2) -> Position {
    position.vec.x = coordinates_vec2.x;
    position.vec.y = coordinates_vec2.y;
    return position;
}

