// Board.tsx
import React from "react";

interface BoardProps {
    position: { vec: { x: number; y: number } } | null; 
    selectedDirection: string | null;
}

const Board: React.FC<BoardProps> = ({ position, selectedDirection }) => {
    
    const renderSquare = (i: number, j: number) => {
        const isBlackSquare = (i + j) % 2 === 1; 
        let piece = null;

        
        if (position && position.vec.x === j && position.vec.y === i) {
            piece = "🎃";
        }

        return (
            <div
                key={`${i}-${j}`}
                className={`w-22 h-20 ${isBlackSquare ? "bg-gray-800" : "bg-gray-200"} flex items-center justify-center relative`}
            >
              
                {piece && (
                    <span className="text-2xl">{piece}</span>
                )}

                {position &&
                    position.vec.x === j &&
                    position.vec.y === i && (
                        <div className="absolute inset-0 border-4 border-orange-500 bg-orange-200 bg-opacity-25 rounded animate-pulse" />
                    )}
            </div>
        );
    };

    return (
        <div className="border-2 border-gray-400 rounded-lg">

            <div className="grid grid-cols-8 grid-rows-8 gap-0"> 
                {Array.from({ length: 8 }, (_, i) => (
                    <React.Fragment key={i}>
                        {Array.from({ length: 8 }, (_, j) => renderSquare(i, j))}
                    </React.Fragment>
                ))}
            </div>
            <div className="text-white mt-4 text-center"> 
                <h2 className="text-lg font-semibold text-white mb-2">Checkers</h2>
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
