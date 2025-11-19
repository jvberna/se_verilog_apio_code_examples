module binary_led_counter (
    input wire CLK,        // Reloj de la FPGA (12 MHz)
    input wire BTN,        // Botón de Reinicio, Activo en Bajo (0 = Presionado)
    output reg [7:0] LED_OUT // 8 LEDs (LED_OUT[7] es el bit más significativo)
);

    // --- 1. Parámetros de Temporización (1 Segundo) ---
    
    // Frecuencia del reloj para la Alhambra II
    parameter CLK_FREQ = 12_000_000;
    
    // El contador debe llegar a 11,999,999 (0 a 11,999,999 son 12M ciclos)
    parameter ONE_SEC_LIMIT = CLK_FREQ - 1; 
    
    // 24 bits para el contador de segundos (log2(12M) = 24 bits)
    parameter SEC_COUNT_BITS = 24; 

    // --- 2. Registros Internos ---
    
    // Contador principal para medir los segundos
    reg [SEC_COUNT_BITS-1:0] sec_counter = 0; 
    
    // Contador de 8 bits (el valor que se muestra en los LEDs)
    reg [7:0] binary_count = 0; 
    
    // Inicializa el estado
    initial begin
        LED_OUT = 8'b00000000;
        sec_counter = 0;
        binary_count = 0;
    end

    // --- 3. Lógica Síncrona (Control de Tiempo y Reinicio) ---
    always @(posedge CLK) begin
        
        // --- A. Lógica de Reinicio (BTN) ---
        // El botón en la Alhambra es Activo en Alto.
        if (BTN == 1'b1) begin
            // Reinicia ambos contadores a cero
            sec_counter <= 0;
            binary_count <= 0;
            LED_OUT <= 8'b00000000;
        
        // --- B. Lógica de Temporización y Conteo Normal ---
        end else begin
            
            // Si el contador de segundos ha alcanzado el límite (1 segundo)
            if (sec_counter == ONE_SEC_LIMIT) begin
                
                // 1. Resetear el contador de segundos (preparar para el próximo segundo)
                sec_counter <= 0;
                
                // 2. Incrementar el contador binario de 8 bits
                // Usa un incremento con desbordamiento (overflow) natural.
                // Después de 255 (8'b11111111), el contador volverá a 0.
                binary_count <= binary_count + 1;
                
                // 3. Actualizar los LEDs con el nuevo valor binario
                //LED_OUT <= binary_count + 1; 
                
                
            end else begin
                
                // Si aún no ha pasado 1 segundo, sigue contando
                sec_counter <= sec_counter + 1;
                
            end
        end
    end

endmodule