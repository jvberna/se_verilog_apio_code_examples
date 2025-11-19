
//Este testbench generará una señal de reloj (CLK) y aplicará un pulso para simular la lógica de incremento y la salida del LED.

`timescale 1ms/100us

module leds_blink_tb;

    // Declaración de señales del Testbench
    // Las señales que impulsan las entradas del DUT son de tipo 'reg'
    reg CLK; 
    
    // Las señales que reciben la salida del DUT son de tipo 'wire'
    wire LED7, LED6, LED5, LED4, LED3, LED2, LED1, LED0;

    // Parámetros de Simulación
    parameter CLK_PERIOD = 500; // 500 * 1ms = 500ms (Frecuencia de 10 Hz)
    parameter SIM_TIME = 10000; // 10000 * 1ms = 10 segundos de simulación
    
// --- Instanciación del Módulo a Probar (DUT) ---

    // El nombre del módulo es LEDS_blink
    leds_blink uut (
        .CLK(CLK), .LED7(LED7), .LED6(LED6), .LED5(LED5), .LED4(LED4),
        .LED3(LED3), .LED2(LED2), .LED1(LED1), .LED0(LED0)
    );

// --- Generación de la Señal de Reloj ---

    // Inicializa el reloj en un valor conocido
    initial begin
        CLK = 0; 
    end

    // Genera el pulso del reloj continuo
    always begin
        #(CLK_PERIOD) CLK = ~CLK; // Retraso de CLK_PERIOD
    end

// --- Estímulos y Verificación ---

    initial begin
        // Configuración de Trazas de Onda (.vcd)
        $dumpvars(0, leds_blink_tb); 
        
        // Mensaje de inicio
        $display("--- Simulacion de LED_blink Iniciada ---");
        $display("Tiempo(ns) | CLK | LED7 | LED6 LED5 LED4 LED3 LED2 LED1 LED0");
        $monitor("%5t      | %b   | %b | %b %b %b %b %b %b %b", $time, CLK, LED7, LED6, LED5, LED4, LED3, LED2, LED1, LED0);
        
        // Inicializa entradas (aunque ya lo hicimos con CLK = 0)
        // No hay otras entradas ademas de CLK
        
        // Espera un tiempo de simulación y luego termina
        #(SIM_TIME); 
        
        // Mensaje de finalización y detiene la simulación
        $display("--- Simulacion Finalizada en %t ns ---", $time);
        $finish; 
    end

endmodule