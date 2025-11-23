module leds_blink (
    input wire clk,      // Entrada del reloj (ej. 50 MHz)
    input wire rst,      // Botón de reset (opcional, pero recomendado)
    output reg led       // Salida hacia el LED
);

    // Definimos una constante para la frecuencia del reloj
    // 12 MHz = 12,000,000 ciclos por segundo.
    parameter FREQ_CLOCK = 12_000_000; // Frecuencia del reloj en Hz
    parameter CYCLES_TO_TOGGLE = FREQ_CLOCK - 1;

    // Necesitamos un registro lo suficientemente grande para contar hasta 12 millones.
    // 2^24 = 16.7 millones (muy pequeño)
    reg [23:0] counter; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            led <= 0;
        end else begin
            if (counter == CYCLES_TO_TOGGLE) begin
                led <= ~led;      // Invertimos el estado del LED (Toggle)
                counter <= 0;     // Reiniciamos el contador
            end else begin
                counter <= counter + 1; // Incrementamos la cuenta
            end
        end
    end

endmodule