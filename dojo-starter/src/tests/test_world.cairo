#[cfg(test)]
mod tests {
    use dojo::model::{ModelStorage, ModelValueStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{spawn_test_world, NamespaceDef, TestResource, ContractDefTrait};

    use dojo_starter::systems::actions::{actions, IActionsDispatcher, IActionsDispatcherTrait};
    use dojo_starter::models::{Piece, m_Piece, Moves, m_Moves, Direction, Vec2};

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "dojo_starter", resources: [
                TestResource::Model(m_Piece::TEST_CLASS_HASH.try_into().unwrap()),
                //TestResource::Model(m_Moves::TEST_CLASS_HASH.try_into().unwrap()),
                //TestResource::Event(actions::e_Moved::TEST_CLASS_HASH.try_into().unwrap()),
                TestResource::Contract(
                    ContractDefTrait::new(actions::TEST_CLASS_HASH, "actions")
                        .with_writer_of([dojo::utils::bytearray_hash(@"dojo_starter")].span())
                )
            ].span()
        };

        ndef
    }

    #[test]
    fn test_world_test_set() {
        // Initialize test environment
        let caller = starknet::contract_address_const::<0x0>();
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        // Test initial piece
        let mut piece: Piece = world.read_model(caller);
        assert(piece.vec.x == 0 && piece.vec.y == 0, 'initial piece wrong');

        // Test write_model_test
        piece.vec.x = 1;
        piece.vec.y = 1;

        world.write_model_test(@piece);

        let piece: Piece = world.read_model(caller);
        assert(piece.vec.y == 1, 'write_value_from_id failed');
        // Test model deletion
        world.erase_model(@piece);
        let piece: Piece = world.read_model(caller);
        assert(piece.vec.x == 0 && piece.vec.y == 0, 'erase_model failed');
    }
    #[test]
    #[available_gas(30000000)]
    fn test_move() {
        let caller = starknet::contract_address_const::<0x0>();

        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());

        let (contract_address, _) = world.dns(@"actions").unwrap();
        let actions_system = IActionsDispatcher { contract_address };

        actions_system.spawn();
        let initial_position: Piece = world.read_model(caller);

        assert(initial_position.vec.x == 1 && initial_position.vec.y == 3, 'wrong initial piece');

        let valid_piece_coordinates_vec2 = Vec2 { x: 1, y: 3 };
        let can_choose_piece = actions_system.can_choose_piece(valid_piece_coordinates_vec2);
        assert(can_choose_piece, 'can_choose_piece failed');

        let new_coordinates_vec2 = Vec2 { x: 2, y: 4 };
        actions_system.move(new_coordinates_vec2);

        let new_position: Piece = world.read_model(caller);

        assert!(new_position.vec.x == 2, "piece x is wrong");
        assert!(new_position.vec.y == 4, "piece y is wrong");
    }
}
