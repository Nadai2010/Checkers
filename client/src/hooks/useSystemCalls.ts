import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useDojoStore } from "../App";
import { useDojo } from "./useDojo";
import { v4 as uuidv4 } from "uuid";

export const useSystemCalls = () => {
    const state = useDojoStore((state) => state);

    const {
        setup: { client },
        account: { account },
    } = useDojo();

    const generateEntityId = () => {
        if (!account) throw new Error("Account is not defined");
        return getEntityIdFromKeys([BigInt(account.address)]);
    };

    const spawn = async () => {
        const entityId = generateEntityId();
        const transactionId = uuidv4();
        const remainingMoves = 100;

        state.applyOptimisticUpdate(transactionId, (draft) => {
            // Check if the entity already exists in the draft
            if (!draft.entities[entityId]) {
                draft.entities[entityId] = {
                    entityId,
                    models: {
                        dojo_starter: {
                            Moves: {
                                remaining: remainingMoves,
                                can_move: true,
                                last_direction: undefined,
                            },
                            Position: {
                                vec: {
                                    x: 0,
                                    y: 0,
                                },
                                player: account.address,
                            },
                        },
                    },
                };
            } else {
                draft.entities[entityId].models.dojo_starter.Moves!.remaining = remainingMoves;
            }
        });

        try {
            await client.actions.spawn({ account });
            await state.waitForEntityChange(entityId, (entity) => {
                return (
                    entity?.models?.dojo_starter?.Moves?.remaining ===
                    remainingMoves
                );
            });
        } catch (error) {
            state.revertOptimisticUpdate(transactionId);
            console.error("Error executing spawn:", error);
            throw new Error(`Spawn failed: ${error}`);
        } finally {
            state.confirmTransaction(transactionId);
        }
    };

    return {
        spawn,
    };
};
