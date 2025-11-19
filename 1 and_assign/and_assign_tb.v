`timescale 1ns/1ps   

module and_assign_tb;

reg a;
reg b;
wire y;

and_assign uut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    // GENERACIÓN DEL ARCHIVO DE ONDAS
    //$dumpfile("_build/default/and_assign_tb.vcd");   // nombre del archivo .vcd
    $dumpvars(0, and_assign_tb);      // registrar todas las señales del testbench

    // Mensajes en consola
    $display("Tiempo | a b | y");
    $monitor("%4t   | %b %b | %b", $time, a, b, y);

    // Estímulos
    a = 0; b = 0; #100;
    a = 0; b = 1; #100;
    a = 1; b = 0; #100;
    a = 1; b = 1; #100;

    $finish;
end

endmodule
