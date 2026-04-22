function [Cement] = cement_modul_f(module) 
Cement_modul =...
    WebPlotDigitizer_matlab("\data\cement.txt")

Cement = interp1(Cement_modul(:,2),Cement_modul(:,1), module);

end

