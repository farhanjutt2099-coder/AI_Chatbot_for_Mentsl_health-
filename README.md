# AI Chatbot for Mental Health

This repository contains a mental health chatbot project built with Python, Streamlit, and machine learning tools.

## Project structure

- `AI_Chatbot_for_Mentsl_health-/` - main project folder containing the notebook, app, and dataset files.
- `AI_Mental_Health.ipynb` - Jupyter notebook for data exploration, preprocessing, model training, and chatbot experiments.
- `app.py` - Streamlit application for the mental health chatbot.
- `requirements.txt` - required Python packages for this project.
- `archive/` - supplemental data files used for training and analysis.
- `setup_env.ps1` - PowerShell script to create a local virtual environment and install dependencies.

## Setup instructions

Use the local virtual environment to avoid modifying an externally managed Python interpreter.

1. Open PowerShell in the repository root:

   `d:\Farhan Project\AI_Chatbot_for_Mentsl_health-`

2. Run the setup script:

   `.\setup_env.ps1`

3. Activate the environment:

   `.\.venv\Scripts\Activate.ps1`

4. Confirm installation:

   `python -m pip list --format=columns`

5. Run the Streamlit app:

   `streamlit run .\AI_Chatbot_for_Mentsl_health-\app.py`

## Notes

- If `requirements.txt` is inside a nested folder, the script will locate it automatically.
- If the project does not find `app.py`, install dependencies first and then run the app manually from the correct app location.
- This setup avoids the `externally-managed-environment` pip error by using a dedicated `.venv`.
