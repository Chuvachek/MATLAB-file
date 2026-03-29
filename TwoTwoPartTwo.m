%% 5. Диаграмма для пункта 1: U = 0.8*Uном и при r1 = 3*r1
% Номинальные параметры из предыдущего раздела
Mmax_nom = Mmax;     
sk_nom   = sk;       

% Параметры для второго случая по скриншоту
Mmax_2 = 1545;       % Н*м
Mnom_2 = 764;        % Н*м
sk_2   = 0.136;      % критическое скольжение
n0_2   = 1000;       % об/мин

% Момент для исходной характеристики
M_nom = (2 * Mmax_nom * (1 + a * sk_nom)) ./ ...
        (s./sk_nom + sk_nom./s + 2 * a * sk_nom);

% Для второй характеристики нужен свой коэффициент a2
% Если у тебя в курсовой он уже найден, подставь его сюда.
% Если нет, можно оставить как a2 = a для построения вида.
a2 = a;

M_2 = (2 * Mmax_2 * (1 + a2 * sk_2)) ./ ...
      (s./sk_2 + sk_2./s + 2 * a2 * sk_2);

n_mech_1 = n0 * (1 - s);
n_mech_2 = n0_2 * (1 - s);

% Характерные точки
n_Mmax_2 = n0_2 * (1 - sk_2);
s_nom_2 = (n0_2 - n0_2 + 0); % заглушка, если не нужен

figure('Color','w','Position',[150 150 900 600]);
hold on; grid on; grid minor;

plot(M_nom, n_mech_1, 'LineWidth', 2.0, 'Color', [0 0.45 0.74], ...
    'DisplayName', 'Исходная характеристика');
plot(M_2, n_mech_2, 'LineWidth', 2.0, 'Color', [0.85 0.33 0.10], ...
    'DisplayName', 'При r_1 = 3r_1');

plot(Mmax_2, n_Mmax_2, 'ro', 'MarkerFaceColor', 'r', ...
    'DisplayName', 'M_{max} второго случая');
plot(Mnom_2, n0_2*(1-(n0_2-764)/n0_2), 'ks', 'MarkerFaceColor', 'k', ...
    'DisplayName', 'M_n второго случая');

xlabel('Момент M, Н·м', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Скорость n, об/мин', 'FontSize', 11, 'FontWeight', 'bold');
title('Механические характеристики АД', 'FontSize', 12);
legend('Location','best');
line([0 0], [min([n_mech_1 n_mech_2]) max([n_mech_1 n_mech_2])], ...
    'Color','k','LineWidth',1);