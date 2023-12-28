from flask import Flask, g, render_template


import os
import sys

# 스크립트 파일의 절대 경로를 구합니다.
script_file_path = os.path.abspath(__file__)

project_root = os.path.join(os.path.dirname(script_file_path), '..')
sys.path.insert(0, project_root)

from extern_lib.AI_16_CP2.face_ds_project import FaceDSProject
# import tracemalloc

# tracemalloc.start()

app = Flask(__name__, template_folder='templates/dist', static_folder='templates/dist', static_url_path='')
face_ds_project = FaceDSProject()

@app.before_request
def add_face_ds_project_to_g():
    g.face_ds_project = face_ds_project

from views import api
app.register_blueprint(api.bp, url_prefix='/api')

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def catch_all(path):
    return render_template("index.html")

if __name__ == '__main__':
    # app.run(host='0.0.0.0', debug=True)
    app.run(host='0.0.0.0')
    