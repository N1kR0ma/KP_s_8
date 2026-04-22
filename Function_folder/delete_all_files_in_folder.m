function delete_all_files_in_folder(target_folder)
    % Удаляет все файлы в указанной папке (подпапки не трогает)
    % target_folder - путь к папке
    
    % Проверяем, существует ли папка
    if ~exist(target_folder, 'dir')
       mkdir(target_folder);
    end
    
    % Получаем список всех файлов в папке (исключая подпапки)
    files = dir(fullfile(target_folder, '*.*'));
    files = files(~[files.isdir]); % Убираем папки
    
    if isempty(files)
        fprintf('В папке "%s" нет файлов для удаления\n', target_folder);
        return;
    end
    
    % Удаляем каждый файл
    deleted_count = 0;
    for i = 1:length(files)
        file_path = fullfile(target_folder, files(i).name);
        try
            delete(file_path);
            deleted_count = deleted_count + 1;
            fprintf('Удален: %s\n', files(i).name);
        catch ME
            warning('Не удалось удалить файл "%s": %s', files(i).name, ME.message);
        end
    end
    
    fprintf('\nУдалено файлов: %d из %d\n', deleted_count, length(files));
end