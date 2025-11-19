module kitt_lights (
    input wire CLK,        // Reloj de la FPGA (12 MHz)
    output reg [7:0] LED_OUT // Salida para los 8 LEDs
);

    // --- 1. Parámetros de Retardo (Velocidad del efecto) ---
    // El retardo para controla la velocidad sera de 200 ms.
    // Se calcula a partir de la frecuencia del reloj.
    
    parameter CLK_FREQ = 12_000_000;  // Frecuencia del reloj: 12 MHz
    parameter DELAY_MS = 200; // Retardo por cada movimiento del LED en milisegundos
    parameter DELAY_CYCLES = (CLK_FREQ / 1000) * DELAY_MS; // Ciclos de reloj para el retardo

    // --- 2. Contador para el Retardo ---
    // Necesitamos un contador para esperar el DELAY_CYCLES en cada paso
    // ceil(log2(2,400,000)) = 22 bits al menos
    parameter COUNT_BITS = 22; 
    reg [COUNT_BITS-1:0] delay_counter = 0; 
    reg delay_done = 1'b0; // Flag que indica si el retardo ha terminado

    // --- 3. Registros de Estado de las Luces ---
    reg [2:0] current_led_index = 3'b000; // Índice del LED actualmente encendido (0 a 7)
    reg direction = 1'b0; // 0 = Derecha (0 -> 7), 1 = Izquierda (7 -> 0)

    // --- 4. Lógica del Retardo (Síncrona) ---
    always @(posedge CLK) begin
        if (delay_counter == DELAY_CYCLES - 1) begin
            delay_counter <= 0;      // Resetear contador
            delay_done <= 1'b1;      // Indicar que el retardo ha terminado
        end else begin
            delay_counter <= delay_counter + 1; // Incrementar contador
            delay_done <= 1'b0;      // Resetear flag (a menos que haya terminado)
        end
    end

    // --- 5. Lógica de Movimiento de las Luces K.I.T.T. (Síncrona) ---
    always @(posedge CLK) begin
        if (delay_done) begin // Solo actua cuando el retardo ha terminado
            
            // Inicializar el patrón de LEDs
            //LED_OUT <= 8'b0000_0000; 
            //LED_OUT[current_led_index] <= 1'b0; // no funcionaría correctamente
            Mueve el LED en la dirección actual
            if (direction == 1'b0) begin // Moviendo a la derecha (0 -> 7)
                if (current_led_index == 7) begin // Si llegó al final (LED7)
                    direction <= 1'b1; // Cambiar dirección a izquierda
                    current_led_index <= 6; // Empezar a retroceder desde LED6
                end else begin
                    current_led_index <= current_led_index + 1; // Avanzar
                end
            end else begin // Moviendo a la izquierda (7 -> 0)
                if (current_led_index == 0) begin // Si llegó al final (LED0)
                    direction <= 1'b0; // Cambiar dirección a derecha
                    current_led_index <= 1; // Empezar a avanzar desde LED1
                end else begin
                    current_led_index <= current_led_index - 1; // Retroceder
                end
            end
            
            // Encender el LED correspondiente al índice actual
            // Se usa un "one-hot" (solo un bit en '1')
            LED_OUT[current_led_index] <= 1'b1; 
        end
    end
    
    // El 'initial' bloque es para inicializar el estado del LED en la simulación
    // En hardware, se inicializa al encender, pero ayuda en la simulación
    initial begin
        LED_OUT = 8'b0000_0001; // Empieza con el primer LED encendido
        current_led_index = 0;
        direction = 1'b0;
        delay_counter = 0;
        delay_done = 1'b0;
    end

endmodule