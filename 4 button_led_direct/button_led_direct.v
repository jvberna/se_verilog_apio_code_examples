module button_led_direct (
    input wire BTN, // Entrada del botón (conectado al P10 de la Alhambra)
    output wire LED // Salida al LED (conectado al P6 de la Alhambra)
);

    // El botón de la Alhambra es Activo en Alto:
    // - Presionado (BTN = 1)
    // - No Presionado (BTN = 2)
    
    assign LED = BTN;

endmodule