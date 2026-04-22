function move_file_to_named_folder(filename, target_folder_name)
    % Перемещает файл в папку с указанным названием
    % filename - имя файла (с путём или без)
    % target_folder_name - название целевой папки
       % Преобразуем входные аргументы в строковые скаляры
    if iscell(filename)
        filename = filename{1};
    elseif isstring(filename)
        filename = char(filename);
    end
    % Получаем информацию о файле
    [file_path, file_name, file_ext] = fileparts(filename);
    
    % Если путь не указан, используем текущую папку
    if isempty(file_path)
        file_path = pwd;
        source_file = fullfile(file_path, [file_name, file_ext]);
    else
        source_file = filename;
    end
    
    % Проверяем, существует ли исходный файл
    if ~exist(source_file, 'file')
        error('Файл "%s" не найден', source_file);
    end
    
    % Создаем полный путь к целевой папке
    target_folder = fullfile(file_path, target_folder_name);
    
    % Проверяем существование целевой папки и создаем если нужно
    if ~exist(target_folder, 'dir')
        mkdir(target_folder);
        fprintf('Создана папка: %s\n', target_folder);
    else
        fprintf('Папка уже существует: %s\n', target_folder);
    end
    
    % Формируем путь для перемещения
    target_file = fullfile(target_folder, [file_name, file_ext]);
    
    % Перемещаем файл
    try
        movefile(source_file, target_file);
        fprintf('Файл "%s" перемещен в "%s"\n', ...
            [file_name, file_ext], target_folder);
    catch ME
        error('Ошибка при перемещении файла: %s', ME.message);
    end
end