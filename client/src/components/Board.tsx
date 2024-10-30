import React from "react";

interface BoardProps {
    position: { vec: { x: number; y: number } } | null; // Posición de la pieza seleccionada
    selectedDirection: string | null; // Dirección seleccionada
}

const Board: React.FC<BoardProps> = ({ position, selectedDirection }) => {
    // Crear un tablero de 8x8
    const renderSquare = (i: number, j: number) => {
        const isBlackSquare = (i + j) % 2 === 1; // Color de la casilla
        let piece = null;

        // Determinar si hay una pieza en la casilla
        if (i < 3 && isBlackSquare) {
            piece = "B"; // Piezas negras
        } else if (i > 4 && isBlackSquare) {
            piece = "R"; // Piezas rojas
        }

        return (
            <div
                key={`${i}-${j}`}
                className={`w-12 h-12 ${isBlackSquare ? "bg-gray-800" : "bg-gray-200"} flex items-center justify-center relative`}
            >
                {piece && (
                    <div className={`w-8 h-8 rounded-full ${piece === "B" ? "bg-black" : "bg-red-600"}`}></div>
                )}
                {/* Resaltar la posición de la pieza seleccionada */}
                {position &&
                    position.vec.x >= 0 &&
                    position.vec.x < 8 &&
                    position.vec.y >= 0 &&
                    position.vec.y < 8 &&
                    position.vec.x === j &&
                    position.vec.y === i && (
                        <div className="absolute inset-0 border-4 border-orange-500 bg-orange-200 bg-opacity-25 rounded animate-pulse" />

                    )}
            </div>
        );
    };

    return (
        <div className="border-2 border-gray-400 rounded-lg">
            <h2 className="text-lg font-semibold text-white mb-2">Game Board</h2>
            <div className="grid grid-cols-8 grid-rows-8 gap-0"> {/* Ajuste para que las casillas estén juntas */}
                {Array.from({ length: 8 }, (_, i) => (
                    <React.Fragment key={i}>
                        {Array.from({ length: 8 }, (_, j) => renderSquare(i, j))}
                    </React.Fragment>
                ))}
            </div>
            <div className="text-white mt-4">
                {position ? (
                    <>
                        <div>{`Position: (${position.vec.x}, ${position.vec.y})`}</div>
                        <div>{`Selected Direction: ${selectedDirection ?? "None"}`}</div>
                    </>
                ) : (
                    <div className="text-red-500">No Position Available</div>
                )}
            </div>
        </div>
    );
};

export default Board;
