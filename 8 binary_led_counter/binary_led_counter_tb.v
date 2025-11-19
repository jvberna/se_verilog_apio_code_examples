`timescale 1ns / 1ps

module binary_led_counter_tb;

    // 1. Declaración de Señales
    reg CLK;
    reg BTN;
    wire [7:0] LED_OUT;

    // 2. Generación del Reloj (12 MHz)
    // Periodo ≈ 83.333 ns -> Semiperiodo ≈ 41.667 ns
    initial CLK = 0;
    always #41.667 CLK = ~CLK;

    // 3. Instanciación del Módulo (UUT) con AJUSTE DE TIEMPO
    binary_led_counter #(
        // -----------------------------------------------------------------
        // TRUCO DE SIMULACIÓN:
        // Reducimos el límite de 12,000,000 a solo 12,000.
        // Esto hace que el "segundo" simule pasar 1000 veces más rápido.
        // Así veremos el contador avanzar sin esperar horas.
        // Si quieres tiempo 100% real, borra esta línea.
        // -----------------------------------------------------------------
        .ONE_SEC_LIMIT(12000) 
    ) uut (
        .CLK(CLK),
        .BTN(BTN),
        .LED_OUT(LED_OUT)
    );

    // 4. Secuencia de Prueba (10 Segundos)
    initial begin
        // Configuración para visualizar ondas
        $dumpfile("binary_led_counter_tb.vcd");
        $dumpvars(0, binary_led_counter_tb);

        $display("--- Inicio de Simulación (Duración: 10s) ---");
        
        // ESTADO INICIAL: RESET
        // Nota: Tu código dice 'if (BTN == 1) Reset'.
        // Aunque tu comentario dice 'Activo en Bajo', el código manda.
        // Ponemos BTN en 1 para resetear inicialemente.
        BTN = 1; 
        #100_000; // Esperar un poco en Reset
        
        // SOLTAR RESET (Empezar a contar)
        $display("Liberando botón de reset...");
        BTN = 0; 

        // ESPERAR 10 SEGUNDOS
        // Usamos un delay grande. Como hemos 'acelerado' el contador
        // con el parámetro arriba, veremos el contador dar muchas vueltas.
        #10_000_000_000; 

        $display("--- Fin de Simulación tras 10 segundos ---");
        $finish;
    end

    // Monitorización opcional para ver el progreso en texto
    initial begin
        $monitor("Tiempo: %0t | BTN: %b | Contador Binario (LEDs): %d (%b)", 
                 $time, BTN, LED_OUT, LED_OUT);
    end

endmodule