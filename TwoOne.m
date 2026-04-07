% РАЗДЕЛ 2.1: Естественные характеристики АД
clear; clc; close all;

%% 1. Исходные данные 
tip_AD = '4MTH225L6';
P_nom = 55000;      % 55 кВт
n_nom = 970;        
r1 = 0.039;         
x1 = 0.1;           
r2 = 0.029;         
x2 = 0.135;         
E2k = 290;          
f = 50;             
m = 3;              
U_ph = 220;         

%% 1.x Вывод исходных данных
fprintf('--- Исходные паспортные данные ---\n');
fprintf('Тип двигателя: %s\n', tip_AD);
fprintf('Pn      = %.1f кВт\n', P_nom/1000);
fprintf('nном    = %.1f об/мин\n', n_nom);
fprintf('Uф      = %.1f В\n', U_ph);
fprintf('f1      = %.1f Гц\n', f);
fprintf('r1      = %.4f Ом\n', r1);
fprintf('x1      = %.4f Ом\n', x1);
fprintf('r2      = %.4f Ом\n', r2);
fprintf('x2      = %.4f Ом\n', x2);
fprintf('E2k     = %.1f В\n\n', E2k);

%% 2. Расчет параметров приведения
% Для n_nom = 970 ближайшая синхронная n0 = 1000 => p = 3
p = 3; 
n0 = 1000;
omega0 = (2 * pi * n0) / 60;

% Приведение ротора
E2ph = E2k / sqrt(3);
k = (0.95 * U_ph) / E2ph; 
r2_pr = (k^2) * r2;
x2_pr = (k^2) * x2;
x_kz = x1 + x2_pr;

% Коэффициенты для формулы Клосса
a = r1 / r2_pr;
sk = r2_pr / sqrt(r1^2 + x_kz^2);
Mmax = (m * U_ph^2) / (2 * omega0 * (r1 + sqrt(r1^2 + x_kz^2)));

%% 2.x Вывод расчётных параметров и коэффициентов
fprintf('--- Расчётные параметры приведения ---\n');
fprintf('p       = %d (число пар полюсов)\n', p);
fprintf('n0      = %.1f об/мин (синхронная скорость)\n', n0);
fprintf('omega0  = %.4f рад/с\n', omega0);
fprintf('E2ф     = %.2f В\n', E2ph);
fprintf('k       = %.4f (коэф. трансформации)\n', k);
fprintf('r2''     = %.5f Ом (приведённое)\n', r2_pr);
fprintf('x2''     = %.5f Ом (приведённое)\n', x2_pr);
fprintf('xkZ     = %.5f Ом\n', x_kz);
fprintf('a       = %.5f (коэф. формулы Клосса)\n', a);
fprintf('sk      = %.5f (критическое скольжение)\n', sk);
fprintf('Mmax    = %.2f Н·м (максимальный момент)\n\n', Mmax);

%% 3. Формирование характеристик
% Расширенный диапазон скольжения для красоты (от генераторного до тормозного)
s = linspace(-0.5, 1.5, 1000); 
s(s==0) = 1e-6; % защита от нуля

% Полная формула Клосса
M = (2 * Mmax * (1 + a * sk)) ./ (s./sk + sk./s + 2 * a * sk);
n_mech = n0 * (1 - s);

%% 3.x Вывод контрольных точек характеристики
s_nom = (n0 - n_nom) / n0;
M_nom_pt = (2 * Mmax * (1 + a * sk)) / (s_nom/sk + sk/s_nom + 2 * a * sk);

fprintf('--- Характерные точки ---\n');
fprintf('sном    = %.5f (номинальное скольжение)\n', s_nom);
fprintf('Mном    = %.2f Н·м (момент в номинальной точке)\n', M_nom_pt);
fprintf('n(Mmax) = %.1f об/мин (скорость при Mmax)\n\n', n0*(1-sk));

%% 4. Построение графиков
figure('Color', 'w', 'Position', [100, 100, 1100, 600]);

% --- ЛЕВЫЙ ГРАФИК: M = f(n) (Классический вид) ---
subplot(1, 2, 1);
plot(M, n_mech, 'LineWidth', 2.5, 'Color', [0 0.45 0.74]); hold on;
grid on; grid minor;

% Точки
plot(Mmax, n0*(1-sk), 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'M_{max} (крит.)');
n_nom_pt = n_nom;
M_nom_pt = (2 * Mmax * (1 + a * sk)) / (((n0-n_nom)/n0)/sk + sk/((n0-n_nom)/n0) + 2 * a * sk);
plot(M_nom_pt, n_nom_pt, 'ks', 'MarkerFaceColor', 'k', 'DisplayName', 'Ном. точка');

xlabel('Момент M, Н·м', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Скорость n, об/мин', 'FontSize', 11, 'FontWeight', 'bold');
title(['Механическая характеристика ', tip_AD], 'FontSize', 12);
legend('Location', 'best');
line([0 0], [min(n_mech) max(n_mech)], 'Color', 'k', 'LineWidth', 1); % Ось Y

% --- ПРАВЫЙ ГРАФИК: s = f(M) ---
subplot(1, 2, 2);
plot(M, s, 'LineWidth', 2.5, 'Color', [0.85 0.33 0.1]); hold on;
grid on; grid minor;

yline(0, '--g', 's = 0 (Синхр.)', 'LabelHorizontalAlignment', 'right');
yline(1, '--r', 's = 1 (Пуск)', 'LabelHorizontalAlignment', 'right');

set(gca, 'YDir', 'reverse');
xlabel('Момент M, Н·м', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Скольжение s', 'FontSize', 11, 'FontWeight', 'bold');
title('Зависимость s = f(M)', 'FontSize', 12);

sgtitle(['Анализ характеристик АД ', tip_AD], 'FontSize', 14, 'FontWeight', 'bold');


%% 5. Режим при f2 = 3*f1

f2 = 3 * f;

% Новые параметры
n0_2 = 3 * n0;
omega0_2 = 3 * omega0;

x1_2 = 3 * x1;
x2_2 = 3 * x2;

% Если U/f = const
U_ph2 = 3 * U_ph;

% Пересчет приведения
E2ph2 = E2ph * 3; % тоже растёт с частотой
k2 = (0.95 * U_ph2) / E2ph2;

r2_pr2 = (k2^2) * r2;
x2_pr2 = (k2^2) * x2_2;

x_kz2 = x1_2 + x2_pr2;

a2 = r1 / r2_pr2;

sk2 = r2_pr2 / sqrt(r1^2 + x_kz2^2);

Mmax2 = (m * U_ph2^2) / (2 * omega0_2 * (r1 + sqrt(r1^2 + x_kz2^2)));

%% Вывод
fprintf('\n--- При f2 = 3*f1 ---\n');
fprintf('n0_2   = %.1f об/мин\n', n0_2);
fprintf('sk_2   = %.5f\n', sk2);
fprintf('Mmax_2 = %.2f Н·м\n', Mmax2);

%% 6. Режим при p2 = 5*p (переключение полюсов)

p2 = 5 * p;

% Новые скорости
n0_2 = n0 / 5;
omega0_2 = omega0 / 5;

% Параметры НЕ меняются
r2_pr2 = r2_pr;
x_kz2 = x_kz;
a2 = a;

% Критическое скольжение то же
sk2 = sk;

% Новый максимальный момент
Mmax2 = (m * U_ph^2) / (2 * omega0_2 * (r1 + sqrt(r1^2 + x_kz2^2)));

% Номинальное скольжение (предполагаем то же)
s_nom2 = s_nom;

% Новый номинальный момент
M_nom2 = (2 * Mmax2 * (1 + a2 * sk2)) / (s_nom2/sk2 + sk2/s_nom2 + 2 * a2 * sk2);

% Новая номинальная скорость
n_nom2 = n0_2 * (1 - s_nom2);

%% Вывод
fprintf('\n--- При p2 = 5*p ---\n');
fprintf('n0_2   = %.1f об/мин\n', n0_2);
fprintf('sk_2   = %.5f\n', sk2);
fprintf('Mmax_2 = %.2f Н·м\n', Mmax2);
fprintf('Mnom_2 = %.2f Н·м\n', M_nom2);
fprintf('n_nom2 = %.1f об/мин\n', n_nom2);
