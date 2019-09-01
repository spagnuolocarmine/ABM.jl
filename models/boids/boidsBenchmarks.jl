using BenchmarkTools
using Base

using Pkg
Pkg.add("Plots")
using Plots
Pkg.add("PyPlot") # Install a different backend
pyplot() # Switch to using the PyPlot.jl backend

#NUMERO DI AGENTI PER BENCHMARK CON DENSITA' VARIABILE E DENSITA' COSTANTE
x = [   100;
        200;
        400;
        800;
        1600;
        3200;
        6400;
        12800;
        25600;
        51200;
        102400;
        204800;
        409600;
        819200;
        1638400;];

#BANCHMARK MASON CON DENSITA' COSTANTE
mason = [   17088;
        8333.33;
        3802.28;
        1793.4;
        845.3;
        375;
        180.9;
        65.4;
        25.7;
        10.32;
        4.96;
        2.37;
        1.22;
        0.53;
        0.25;];

#BANCHMARK RUST CON DENSITA' COSTANTE
rust = [   12195;
        6666.66;
        2857.14;
        1428.57;
        689.66;
        375;
        176.5;
        78.1;
        34.96;
        16.66;
        7.69;
        3.56;
        1.72;
        0.90;
        0.45;];

#BANCHMARK NETLOGO CON DENSITA' COSTANTE
netlogo = [   495.04;
        205.76;
        116.27;
        56.17;
        26.73;
        11.26;
        6.45;
        3.13;
        1.61;
        0.74;
        0.17;
        0;
        0;
        0;
        0;];

y = [mason rust netlogo];

#PLOT CON DENSITA' COSTANTE
p1 = plot(x, y, title="PLOT CON DENSITA' COSTANTE",
        xlabel="Agenti", ylabel="step/s", label=["mason" "rust" "netlogo"])

#BANCHMARK MASON CON DENSITA' VARIABILE
mason = [   17755.68;
        7710.1;
        2888.59;
        1013.17;
        320.51;
        102.98;
        28.5;
        7.16;
        1.67;
        0.35;
        0.08;
        0.01;
        0;
        0;
        0;];

#BANCHMARK RUST CON DENSITA' VARIABILE
rust = [   16666.66;
        6250;
        2941.17;
        1428.57;
        666.66;
        322.58;
        161.29;
        80;
        37.7;
        16.12;
        7.7;
        3.6;
        1.78;
        0.86;
        0.41;];

#BANCHMARK NETLOGO CON DENSITA' VARIABILE
netlogo = [   471.69;
        196.78;
        84.03;
        38.61;
        22.22;
        9.6;
        3.8;
        1.6;
        0.56;
        0.2;
        0.05;
        0.01;
        0.003;
        0;
        0;];

y = [mason rust netlogo];

#PLOT CON DENSITA' VARIABILE
p2 = plot(x, y, title="PLOT CON DENSITA' VARIABILE",
        xlabel="Agenti", ylabel="step/s", label=["mason" "rust" "netlogo"])

#WIDTH/HEIGHT PER BENCHMARK CON AGENTI COSTANTI
x = [   200;
        282.8427125;
        400;
        565.6854249;
        800;
        1131.37085;
        1600;
        2262.7417;
        3200;
        4525.4834;
        6400;
        9050.966799;
        12800;
        16549.0332;
        20298.0664];

#BANCHMARK MASON CON AGENTI COSTANTI
mason = [       0.07;
                0.11;
                0.21;
                0.42;
                0.70;
                1.10;
                1.51;
                2.05;
                2.98;
                3.65;
                4.67;
                5.50;
                6.30;
                6.62;
                6.54;
                ];

#BANCHMARK RUST CON AGENTI COSTANTI
rust = [        8.0;
                7.69;
                8.33;
                8.33;
                8.0;
                7.69;
                7.4;
                7.14;
                7.14;
                7.69;
                8.0;
                8.33;
                8.69;
                8.33;
                9.09;
                ];

#BANCHMARK NETLOGO CON AGENTI COSTANTI
#netlogo = [   ];

y = [mason rust ];

#PLOT CON AGENTI COSTANTI
p3 = plot(x, y, title="PLOT CON AGENTI COSTANTI",
        xlabel="WIDTH/HEIGHT", ylabel="step/s", label=["mason" "rust" "netlogo"])


#MOSTRIAMO A SCHERMO I PLOT
plot(p1, p2, p3, layout=(3,1), size = (500, 500))
