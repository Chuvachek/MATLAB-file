%% ПУСКОВАЯ ДИАГРАММА (как в методичке)

clear; clc; close all;

%% Исходные данные (твои)
r2 = 0.0140;

P  = 38e3;
n_nom = 565;
I_nom = 192;
U_nom = 220;

w_nom = n_nom * pi / 30;
M_nom = P / w_nom;

n0 = n_nom * (U_nom / (U_nom - I_nom * r2));
c_phi = U_nom / n0;
kF = M_nom / I_nom;

k_M = r2 / (c_phi * kF);   % наклон

% Пусковые моменты
M_p = 3419;
M_per = 1872;

lambda = M_p / M_per;

% Число ступеней
s_nom = r2 / (c_phi * kF);
R_p = r2 * M_nom / (s_nom * M_p);
n = round(log(R_p / r2) / log(lambda));

%% Сопротивления ступеней
R = zeros(1,n);
for i = 1:n
    R(i) = r2 * lambda^(i-1);
end

%% Характеристики (прямые)
M = linspace(0, M_p, 200);

figure('Color','w'); hold on; grid on;

% Естественная характеристика
n_nat = n0 - k_M * M;
plot(M, n_nat, 'k', 'LineWidth', 2);

% Искусственные характеристики
for i = 1:n
    k_Mi = R(i) / (c_phi * kF);
    n_i = n0 - k_Mi * M;
    plot(M, n_i, 'Color', [0.5 0.5 0.5]);
end

%% ===== ПУСКОВАЯ "ЛЕСЕНКА" =====

M_levels = zeros(1,n+1);
M_levels(1) = M_p;

for i = 2:n+1
    M_levels(i) = M_levels(i-1) / lambda;
end

% Строим ступени
for i = 1:n
    % горизонтальный участок
    plot([M_levels(i), M_levels(i)], ...
         [n0 - k_M * M_levels(i), n0 - k_M * M_levels(i+1)], ...
         'b', 'LineWidth', 2);

    % наклонный участок
    k_Mi = R(i) / (c_phi * kF);

    plot([M_levels(i), M_levels(i+1)], ...
         [n0 - k_Mi * M_levels(i), n0 - k_Mi * M_levels(i+1)], ...
         'b', 'LineWidth', 2);
end

%% Вертикальные линии (как на рисунке)
xline(M_p, '--k');
xline(M_per, '--k');

%% Подписи
xlabel('Момент M, Н·м');
ylabel('Скорость n, об/мин');
title('Пусковая диаграмма Д-812');

xlim([0 M_p*1.1]);
ylim([0 n0*1.1]);
