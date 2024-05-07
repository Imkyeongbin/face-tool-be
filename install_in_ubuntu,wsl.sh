sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt install python3.10
python3.10 -m venv .venv
python -m pip install -U pip
pip install -r requirements.txt