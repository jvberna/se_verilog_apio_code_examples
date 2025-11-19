`timescale 1ns / 1ps // Define la escala de tiempo para la simulación

module test_button_led_toggle;

    // --- Señales del Testbench (registros para entradas, wires para salidas) ---
    reg CLK;    // Reloj
    reg BTN;    // Botón
    wire LED;   // LED (salida del módulo DUT)

    // --- Instanciación del Device Under Test (DUT) ---
    // Conecta las señales del testbench a los puertos de tu módulo
    button_led_toggle dut (
        .CLK(CLK),
        .BTN(BTN),
        .LED(LED)
    );

    // --- Generación del Reloj (CLK) ---
    // La Alhambra II tiene un reloj de 12 MHz.
    // Periodo = 1 / 12 MHz = 83.33 ns.
    // Generaremos pulsos cada la mitad del periodo, es decir, 41.66 ns.
    // Para simplificar, usaremos 40 ns, lo que equivale a un CLK de 12.5 MHz (suficientemente cercano para la simulación).
    parameter CLK_PERIOD = 83.33; // Periodo del reloj en ns (12 MHz)

    always begin
        CLK = 1'b0;
        #(CLK_PERIOD / 2); // Espera la mitad del periodo
        CLK = 1'b1;
        #(CLK_PERIOD / 2); // Espera la otra mitad del periodo
    end

    // --- Secuencia de Simulación (estimulación del botón) ---
    initial begin
        // 1. Inicialización
        BTN = 1'b0; // Botón no presionado 
        CLK = 1'b0; // Inicializa el reloj
        //LED = 1'b0; // Establecemos un valor inicial para el LED en el testbench
        $dumpvars(0, test_button_led_toggle); 

        $display("Inicio de la simulacion...");
        $display("Tiempo | CLK | BTN | LED");
        $monitor("%0t | %b   | %b   | %b", $time, CLK, BTN, LED);

        #200000; // Espera un poco para que el sistema se estabilice

        // --- Primera Pulsación de Botón ---
        $display("\n--- Primera pulsacion ---");
        BTN = 1'b1; // Presionar botón
        #200000; // Mantener presionado por un tiempo (ej. 200 ms)
                      // Esto equivale a 200,000,000 ns.
                      // En 200 ms, habrán ocurrido muchos ciclos de reloj (200ms / 83.33ns/ciclo = ~2.4 millones de ciclos).
                      // La detección de flanco garantiza que el LED cambie una sola vez.

        BTN = 1'b0; // Soltar botón
        #200000; // Esperar a que el usuario suelte y se estabilice

        // --- Segunda Pulsación de Botón ---
        $display("\n--- Segunda pulsacion ---");
        BTN = 1'b1; // Presionar botón
        #200000; // Mantener presionado
        BTN = 1'b0; // Soltar botón
        #200000; // Esperar

        // --- Tercera Pulsación de Botón ---
        $display("\n--- Tercera pulsacion ---");
        BTN = 1'b1; // Presionar botón
        #200000; // Mantener presionado
        BTN = 1'b0; // Soltar botón
        #200000; // Esperar

        // --- Finalizar Simulación ---
        $display("\nFin de la simulacion.");
        $finish; // Termina la simulación
    end

endmodule