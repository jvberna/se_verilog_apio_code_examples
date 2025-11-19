`timescale 1ns / 1ps

module button_led_direct_tb;

    // 1. Declaración de señales
    // 'reg' para las señales que vamos a manipular (inputs del módulo)
    reg BTN;
    
    // 'wire' para las señales que vamos a observar (outputs del módulo)
    wire LED;

    // 2. Instanciación del módulo a probar (Unit Under Test - UUT)
    button_led_direct uut (
        .BTN(BTN),
        .LED(LED)
    );

    // 3. Generación de estímulos
    initial begin
        // Configuración para guardar ondas (útil para GTKWave)
        $dumpvars(0, button_led_direct_tb);

        // Inicialización
        $display("Iniciando simulación...");
        BTN = 0; // Botón suelto inicialmente

        // Secuencia de prueba
        // Nota: 1ms = 1,000,000 ns. Haremos cambios cada cierto tiempo.
        
        #100000; // Esperar 100 us
        BTN = 1; // Presionar botón
        $display("Tiempo: %0t | BTN = %b | LED = %b", $time, BTN, LED);

        #300000; // Mantener presionado 300 us (Total: 400 us)
        BTN = 0; // Soltar botón
        $display("Tiempo: %0t | BTN = %b | LED = %b", $time, BTN, LED);

        #200000; // Esperar 200 us (Total: 600 us)
        BTN = 1; // Presionar de nuevo
        $display("Tiempo: %0t | BTN = %b | LED = %b", $time, BTN, LED);

        #300000; // Mantener presionado 300 us (Total: 900 us)
        BTN = 0; // Soltar
        $display("Tiempo: %0t | BTN = %b | LED = %b", $time, BTN, LED);

        // Completar el tiempo restante para llegar a 1ms
        #100000; // (Total: 1,000,000 ns = 1 ms)
        
        $display("Fin de la simulación.");
        $finish; // Detener la simulación
    end

endmodule