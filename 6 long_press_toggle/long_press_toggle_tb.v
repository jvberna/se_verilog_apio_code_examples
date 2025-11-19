`timescale 1ms / 100us

module long_press_toggle_tb;

    // 1. Declaración de señales
    reg CLK;
    reg BTN;
    wire LED;

    // 2. Instanciación del Módulo (UUT)
    long_press_toggle uut (
        .CLK(CLK),
        .BTN(BTN),
        .LED(LED)
    );

    // 3. Generación del Reloj de 1 KHz
    
    initial CLK = 0;

    always #0.5 CLK = ~CLK;

    // 4. Secuencia de Pruebas
    initial begin
        // Configuración para visualizar ondas
        $dumpvars(0, long_press_toggle_tb);

        // --- INICIO (0.0s) ---
        BTN = 0; // Botón suelto
        $display("Incio: Tiempo %0d ms | BTN=%b | LED=%b", $time/1, BTN, LED);
        
        // Esperamos 0.1 segundos antes de empezar
        #100; 

        // --- PRUEBA 1: Pulsación CORTA (0.2s) ---
        // No debería activar el LED porque dura menos de 1s
        $display("--- Pulsación Corta (0.2s) ---");
        BTN = 1; // Presionar
        #200; // Esperar 0.2s
        BTN = 0; // Soltar
        $display("Fin Corta: Tiempo %0d ms | BTN=%b | LED=%b (Esperado: 0)", $time/1, BTN, LED);

        // Esperamos un hueco de 0.2 segundos
        #200; // Esperar 0.2s

        // --- PRUEBA 2: Pulsación LARGA (> 1.0s) ---
        // Vamos a presionar durante 1.2 segundos.
        // El LED debería cambiar exactamente cuando se cumpla 1s de pulsación.
        $display("--- Pulsación Larga (Inicio) ---");
        BTN = 1; // Presionar (Tiempo aprox: 0.5s de simulación)
        
        // Mantenemos presionado 1.2 segundos
        #1_200; 
        
        BTN = 0; // Soltar (Tiempo aprox: 1.7s de simulación)
        $display("Fin Larga: Tiempo %0d ms | BTN=%b | LED=%b (Esperado: 1)", $time/1, BTN, LED);

        #300;
        
        $display("Fin de simulación a los 2 segundos.");
        $finish;
    end

endmodule