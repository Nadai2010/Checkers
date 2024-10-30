"use client";

import React from "react";

const Checker: React.FC = () => {
  return (
    <div className="bg-gray-800 p-6 rounded-lg shadow-lg max-w-md mx-auto mt-8 text-center">
      <h2 className="text-2xl font-bold text-white mb-4">Checker Component</h2>
      <p className="text-gray-300">
        Bienvenido al componente Checker. Aquí puedes realizar las acciones correspondientes ahora que estás conectado.
      </p>
      <button
        className="mt-4 px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-300"
      >
        Acción de Checker
      </button>
    </div>
  );
};

export default Checker;
