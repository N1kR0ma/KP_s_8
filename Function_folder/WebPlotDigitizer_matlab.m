function Massiv = WebPlotDigitizer_matlab(file)

way = fileparts(which(mfilename));
way2file = way + file;
% 1. Читаем файл как текст
text = fileread(way2file);

% 2. Заменяем запятые на точки
if contains(text, ';')
    text = strrep(text, ';', ' ');
    text = strrep(text, ',', '.');
end
% 3. Перезаписываем файл
% 'w' - режим перезаписи
fid = fopen(way2file, 'w');  
fprintf(fid, '%s', text);

Massiv  = table2array(readtable(way2file));

Massiv = sortrows( Massiv, 1 );

fclose(fid);


end