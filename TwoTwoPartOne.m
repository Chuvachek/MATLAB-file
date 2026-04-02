%% 1. Диаграмма для пункта 1: U = 0.8*Uном
% Номинальные параметры из основного расчёта
Mmax_nom = Mmax;     
sk_nom   = sk;       
a_nom    = a;

% НОВЫЕ параметры при U = 0.8*Uном
U_ph_new = 0.8 * U_ph;      % Напряжение уменьшено

% Пересчёт коэффициента приведения (E2ph остаётся прежним)
k_new = (0.95 * U_ph_new) / E2ph; 
r2_pr_new = (k_new^2) * r2;
x2_pr_new = (k_new^2) * x2;
x_kz_new = x1 + x2_pr_new;

% Новые коэффициенты
a_new = r1 / r2_pr_new;
sk_new = r2_pr_new / sqrt(r1^2 + x_kz_new^2);

% Новый максимальный момент (масштабируется как U²)
Mmax_new = (m * U_ph_new^2) / (2 * omega0 * (r1 + sqrt(r1^2 + x_kz_new^2)));

% Номинальный момент (при том же s_nom)
s_nom = (n0 - n_nom) / n0;
M_nom_new = (2 * Mmax_new * (1 + a_new * sk_new)) / ...
            (s_nom/sk_new + sk_new/s_nom + 2 * a_new * sk_new);

% Характеристики (M пропорционально U²)
M_nom = (2 * Mmax_nom * (1 + a_nom * sk_nom)) ./ ...
        (s./sk_nom + sk_nom./s + 2 * a_nom * sk_nom);

M_new = (2 * Mmax_new * (1 + a_new * sk_new)) ./ ...
        (s./sk_new + sk_new./s + 2 * a_new * sk_new);

n_mech_1 = n0 * (1 - s);
n_mech_2 = n0 * (1 - s);    % n0 не меняется!

% Характерные точки
n_Mmax_new = n0 * (1 - sk_new);
n_nom_new = n0 * (1 - s_nom);

%% График
figure('Color','w','Position',[150 150 900 600]);
hold on; grid on; grid minor;

plot(M_nom, n_mech_1, 'LineWidth', 2.0, 'Color', [0 0.45 0.74], ...
    'DisplayName', 'Исходная характеристика U_{ном}');

plot(M_new, n_mech_2, 'LineWidth', 2.0, 'Color', [0.2 0.6 0.2], ...
    'DisplayName', 'U = 0.8U_{ном}');

% Точки максимума
plot(Mmax_nom, n0*(1-sk_nom), 'ro', 'MarkerFaceColor', 'r', ...
    'DisplayName', 'M_{max} (U_{ном})', 'MarkerSize', 8);
plot(Mmax_new, n_Mmax_new, 'ro', 'MarkerFaceColor', [0.2 0.6 0.2], ...
    'DisplayName', 'M_{max} (0.8U)', 'MarkerSize', 8);

% Номинальные точки
plot(M_nom_pt, n_nom, 'ks', 'MarkerFaceColor', 'k', ...
    'DisplayName', 'M_{ном} (U_{ном})', 'MarkerSize', 8);
plot(M_nom_new, n_nom_new, 'ks', 'MarkerFaceColor', [0.2 0.6 0.2], ...
    'DisplayName', 'M_{ном} (0.8U)', 'MarkerSize', 8);

xlabel('Момент M, Н·м', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Скорость n, об/мин', 'FontSize', 11, 'FontWeight', 'bold');
title('Механические характеристики АД при U = 0.8U_{ном}', 'FontSize', 12);
legend('Location','best');
line([0 0], [min(n_mech_1) max(n_mech_1)], 'Color','k','LineWidth',1);

% Вывод расчётных параметров
fprintf('\n--- При U = 0.8*Uном ---\n');
fprintf('Uф_нов  = %.1f В (было %.1f)\n', U_ph_new, U_ph);
fprintf('k_нов   = %.4f (было %.4f)\n', k_new, k);
fprintf('r2''_нов = %.5f Ом (было %.5f)\n', r2_pr_new, r2_pr);
fprintf('Xкз_нов = %.4f Ом (было %.4f)\n', x_kz_new, x_kz);
fprintf('sk_нов  = %.4f (было %.4f)\n', sk_new, sk);
fprintf('a_нов   = %.4f (было %.4f)\n', a_new, a);
fprintf('Mmax_нов= %.1f Н·м (было %.1f, коэффициент %.2f)\n', ...
        Mmax_new, Mmax, Mmax_new/Mmax);
fprintf('Mном_нов= %.1f Н·м (было %.1f)\n', M_nom_new, M_nom_pt);