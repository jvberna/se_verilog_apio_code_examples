
module leds_blink (
    input  CLK,   // 12MHz clock
    output LED7,  // LED to blink
    output LED6, LED5, LED4,  LED3, LED2, LED1, LED0 // The rest of the LEDs are turned off.
);
 
  reg [23:0] counter = 0;

  //always @(posedge CLK) counter[23] <= ~counter[23]; // para usar con la simulación
  always @(posedge CLK) counter <= counter + 1;   // para usar con la el reloj de 12MHz

  assign LED7 = counter[23];

  //-- Turn off the other LEDs
  assign {LED6, LED5, LED4, LED3, LED2, LED1, LED0} = 3'b0;

endmodule