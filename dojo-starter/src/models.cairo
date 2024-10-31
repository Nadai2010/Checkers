use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Moves {
    #[key]
    pub player: ContractAddress,
    pub last_direction: Direction,
    pub can_move: bool,
}

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct DirectionsAvailable {
    #[key]
    pub player: ContractAddress,
    pub directions: Array<Direction>,
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Piece {
    #[key]
    pub player: ContractAddress,
    pub vec: Vec2,
}


#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum Direction {
    None,
    UpLeft,
    UpRight,
    DownLeft,
    DownRight,
}


#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
pub struct Vec2 {
    pub x: u32,
    pub y: u32
}


impl DirectionIntoFelt252 of Into<Direction, felt252> {
    fn into(self: Direction) -> felt252 {
        match self {
            Direction::None => 0,
            Direction::UpLeft => 1,
            Direction::UpRight => 2,
            Direction::DownLeft => 3,
            Direction::DownRight => 4,
        }
    }
}

// #[derive(Drop, Serde)]
// #[dojo::model]
// struct Piece {
//     #[key]
//     pub owner: ContractAddress,
//     pub position: Vec2,
// }

#[generate_trait]
impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        if self.x - self.y == 0 {
            return true;
        }
        false
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
}

#[cfg(test)]
mod tests {
    use super::{Vec2, Vec2Trait};

    #[test]
    fn test_vec_is_zero() {
        assert(Vec2Trait::is_zero(Vec2 { x: 0, y: 0 }), 'not zero');
    }

    #[test]
    fn test_vec_is_equal() {
        let position = Vec2 { x: 420, y: 0 };
        assert(position.is_equal(Vec2 { x: 420, y: 0 }), 'not equal');
    }
}
