from flask import Flask, g, render_template
from .extern_lib.AI_16_CP2.face_ds_project import FaceDSProject
import tracemalloc

tracemalloc.start()

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
    try:
        # app.run(host='0.0.0.0', debug=True)
        app.run(host='0.0.0.0')
    finally:
        # 애플리케이션이 종료되는 시점에 메모리 할당 정보 출력
        current, peak = tracemalloc.get_traced_memory()
        print(f"Current memory usage: {current / 10**6}MB; Peak usage: {peak / 10**6}MB")
        tracemalloc.stop()