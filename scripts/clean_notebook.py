import nbformat
from nbformat import read, write
from pathlib import Path
p = Path('AI_Chatbot_for_Mentsl_health-') / 'AI_Mental_Health.ipynb'
nb = read(str(p), as_version=4)
for cell in nb.cells:
    if 'outputs' in cell:
        cell['outputs'] = []
    if 'execution_count' in cell:
        cell['execution_count'] = None
write(nb, str(p))
print('Notebook outputs cleared:', p)
