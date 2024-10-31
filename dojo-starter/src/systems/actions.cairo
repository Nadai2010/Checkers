use dojo_starter::models::Direction;
use dojo_starter::models::Position;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn move(ref self: T, direction: Direction);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions, next_position};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Position, Vec2, Moves, Direction, DirectionsAvailable};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Moved {
        #[key]
        pub player: ContractAddress,
        pub direction: Direction,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            // Get the default world. 
            let mut world = self.world(@"dojo_starter");

            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();
            // Retrieve the player's current position from the world.
            let mut position: Position = world.read_model(player);

            // Update the world state with the new data.

            // 1. Move the player's position 10 units in both the x and y direction.
            let new_position = Position {
                player, vec: Vec2 { x: position.vec.x + 0, y: position.vec.y + 0 }
            };

            // Write the new position to the world.
            world.write_model(@new_position);
            
            // 2. Set the player's remaining moves to 100.
            let moves = Moves { 
                player, remaining: 100, last_direction: Direction::None(()), can_move: true
            };

            // Write the new moves to the world.
            world.write_model(@moves);
        }

        // Implementation of the move function for the ContractState struct.
        fn move(ref self: ContractState, direction: Direction) {
            // Get the address of the current caller, possibly the player's address.

            let mut world = self.world(@"dojo_starter");

            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let mut position: Position = world.read_model(player);
            let mut moves: Moves = world.read_model(player);

            // Deduct one from the player's remaining moves.
            moves.remaining -= 1;

            // Update the last direction the player moved in.
            moves.last_direction = direction;

            // Calculate the player's next position based on the provided direction.
            let next = next_position(position, direction);

            // Write the new position to the world.
            world.write_model(@next);

            // Write the new moves to the world.
            world.write_model(@moves);
          
            // Emit an event to the world to notify about the player's move.
            world.emit_event(@Moved { player, direction });
        }
    }
}

// Define function like this:
fn next_position(mut position: Position, direction: Direction) -> Position {
    match direction {
        Direction::None => {}, 
        Direction::UpLeft => {
            if position.vec.x > 0 && position.vec.y > 0 {
                if (position.vec.x - 1 + position.vec.y - 1) % 2 == 0 {
                    position.vec.x -= 1;
                    position.vec.y -= 1;
                }
            }
        },
        Direction::UpRight => {
            if position.vec.x < 7 && position.vec.y > 0 {
                if (position.vec.x + 1 + position.vec.y - 1) % 2 == 0 {
                    position.vec.x += 1;
                    position.vec.y -= 1;
                }
            }
        },
        Direction::DownLeft => {
            if position.vec.x > 0 && position.vec.y < 7 {
                if (position.vec.x - 1 + position.vec.y + 1) % 2 == 0 {
                    position.vec.x -= 1;
                    position.vec.y += 1;
                }
            }
        },
        Direction::DownRight => {
            if position.vec.x < 7 && position.vec.y < 7 {
                if (position.vec.x + 1 + position.vec.y + 1) % 2 == 0 {
                    position.vec.x += 1;
                    position.vec.y += 1;
                }
            }
        },
    };
    position
}


