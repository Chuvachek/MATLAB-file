%% 5. Диаграмма для пункта 5: p = 5p

% Номинальные параметры
Mmax_nom = Mmax;     
sk_nom   = sk;       

% Новые параметры
n0_2 = n0 / 5;
omega0_2 = omega0 / 5;

sk_2 = sk;                  % НЕ меняется
a2 = a;                     % НЕ меняется
Mmax_2 = 5 * Mmax_nom;      % увеличивается в 5 раз

% Номинальный момент
Mnom_2 = 5 * M_nom_pt;

% Характеристики
M_nom = (2 * Mmax_nom * (1 + a * sk_nom)) ./ ...
        (s./sk_nom + sk_nom./s + 2 * a * sk_nom);

M_2 = (2 * Mmax_2 * (1 + a2 * sk_2)) ./ ...
      (s./sk_2 + sk_2./s + 2 * a2 * sk_2);

n_mech_1 = n0 * (1 - s);
n_mech_2 = n0_2 * (1 - s);

% Характерные точки
n_Mmax_2 = n0_2 * (1 - sk_2);

% Номинальная точка (корректно!)
s_nom = (n0 - n_nom) / n0;
n_nom_2 = n0_2 * (1 - s_nom);

%% График
figure('Color','w','Position',[150 150 900 600]);
hold on; grid on; grid minor;

plot(M_nom, n_mech_1, 'LineWidth', 2.0, 'Color', [0 0.45 0.74], ...
    'DisplayName', 'Исходная характеристика');

plot(M_2, n_mech_2, 'LineWidth', 2.0, 'Color', [0.85 0.33 0.10], ...
    'DisplayName', 'p = 5p');

plot(Mmax_2, n_Mmax_2, 'ro', 'MarkerFaceColor', 'r', ...
    'DisplayName', 'M_{max} (5p)');

plot(Mnom_2, n_nom_2, 'ks', 'MarkerFaceColor', 'k', ...
    'DisplayName', 'M_{ном} (5p)');

xlabel('Момент M, Н·м', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Скорость n, об/мин', 'FontSize', 11, 'FontWeight', 'bold');
title('Механические характеристики АД при переключении полюсов', 'FontSize', 12);

legend('Location','best');

line([0 0], [min([n_mech_1 n_mech_2]) max([n_mech_1 n_mech_2])], ...
    'Color','k','LineWidth',1);