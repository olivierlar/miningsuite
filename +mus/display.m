function display(p)

chro = p.fields{1}.fields(1).value;
diat = p.fields{1}.fields(2).value;
rhyt = p.fields{2}.value;

text = '';
if ~isempty(chro)
    text = [text 'chro = ' num2str(chro) '  '];
end
if ~isempty(diat)
    text = [text 'letter = ' num2str(diat.letter) ' ' ...
          'accident = ' num2str(diat.accident) '  '];
end
if ~isempty(rhyt)
    text = [text 'bar = ',num2str(rhyt.bar) ' ' ...
          'inbar = ' num2str(rhyt.inbar) '  '];
end
disp(text);