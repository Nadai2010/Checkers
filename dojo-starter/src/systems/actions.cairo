use dojo_starter::models::Direction;
use dojo_starter::models::Position;

// define the interface
#[dojo::interface]
trait IActions {
    fn spawn(ref world: IWorldDispatcher);
    fn move(ref world: IWorldDispatcher, direction: Direction);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use super::{IActions, next_position};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Position, Vec2, Moves, Direction, DirectionsAvailable};

    #[derive(Copy, Drop, Serde)]
    #[dojo::model]
    #[dojo::event]
    struct Moved {
        #[key]
        player: ContractAddress,
        direction: Direction,
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref world: IWorldDispatcher) {
            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();
            // Retrieve the player's current position from the world.
            let position = get!(world, player, (Position));
            // Update the world state with the new data.

            set!(
                world,
                (
                    Moves {
                        player, remaining: 100, last_direction: Direction::None(()), can_move: true
                    },
                    Position {
                        player, vec: Vec2 { x: position.vec.x + 0, y: position.vec.y + 0 }
                    },
                )
            );
        }

        // Implementation of the move function for the ContractState struct.
        fn move(ref world: IWorldDispatcher, direction: Direction) {
            // Get the address of the current caller, possibly the player's address.
            let player = get_caller_address();

            // Retrieve the player's current position and moves data from the world.
            let (mut position, mut moves) = get!(world, player, (Position, Moves));

            // Deduct one from the player's remaining moves.
            moves.remaining -= 1;

            // Update the last direction the player moved in.
            moves.last_direction = direction;

            // Calculate the player's next position based on the provided direction.
            let next = next_position(position, direction);

            // Update the world state with the new moves data and position.
            set!(world, (moves, next));
            // Emit an event to the world to notify about the player's move.
            emit!(world, (Moved { player, direction }));
        }
    }
}

// Define function like this:
fn next_position(mut position: Position, direction: Direction) -> Position {
    match direction {
        Direction::None => {}, // Sin movimiento
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

