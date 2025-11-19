module long_press_toggle (
    input wire CLK, // Reloj de la FPGA (12 MHz)
    input wire BTN, // Botón, Activo en Bajo (0 = Presionado)
    output reg LED // Salida del LED (memoria del estado)
);

    // --- 1. Definición de Parámetros de Tiempo ---
    
    // Frecuencia del reloj: 12,000,000 Hz (12 MHz)
    //parameter CLK_FREQ = 12_000_000;
    parameter CLK_FREQ = 1_000;
    
    // Valor máximo del contador para 1 segundo: 1.0s * 12 MHz = 12,000,000 ciclos
    parameter ONE_SECOND = CLK_FREQ;
    
    // Tamaño del registro: ceil(log2(12,000,000)) = 24 bits
    parameter COUNT_BITS = 24; 
    
    // --- 2. Registros de Estado ---
    
    // Contador para medir la duración de la pulsación
    reg [COUNT_BITS-1:0] counter = 0; 
    
    // Estado del LED (Flip-Flop)
    // El 'initial' asegura que el LED empieza apagado (0)
    initial begin
        LED = 1'b0;
    end

    // --- 3. Lógica de Contador y Toggle Síncrono ---
    
    always @(posedge CLK) begin
        
        // Si el botón está presionado (BTN es 1 en la Alhambra)
        if (BTN == 1'b1) begin
            
            // Caso 1: Aún no llega a 1 segundo.
            if (counter < ONE_SECOND) begin
                counter <= counter + 1; // Sigue contando
            
            // Caso 2: Acaba de alcanzar 1 segundo. ¡Este es el momento de la acción!
            end else if (counter == ONE_SECOND) begin
                
                // 1. Invierte el estado del LED (TOGGLE)
                LED <= ~LED; 
                
                // 2. Incrementa el contador una vez más.
                // Esto es crucial para que el LED NO se siga invirtiendo en el siguiente
                // ciclo de reloj mientras el botón siga presionado (comportamiento "one-shot").
                counter <= counter + 1; 
            
            // Caso 3: Ya superó 1 segundo (Saturación). No hace nada más.
            end else begin
                counter <= counter; // Mantiene el contador saturado
            end
            
        end else begin
            
            // El botón está liberado (BTN es 1).
            // Resetear el contador a 0 para esperar la siguiente pulsación larga.
            counter <= 0;
            
        end
    end

endmodule