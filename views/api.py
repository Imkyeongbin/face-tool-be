from flask import Blueprint, g, request, jsonify
from extern_lib.AI_16_CP2.face_ds_project import FaceDSProject
from views.util.image_processing import process_image

bp = Blueprint('api', __name__)

@bp.route('/verify-faces', methods=['POST'])
def verify_faces():
    origin_img = request.files.get('origin')  # 이미지 파일 가져오기
    target_img = request.files.get('target')  # 이미지 파일 가져오기
    result = None
    if origin_img and target_img:
        origin_img_array = process_image(origin_img)
        target_img_array = process_image(target_img)
        project = g.face_ds_project
        
        result = project.verify(origin_img_array, target_img_array)
        
    else:
        return jsonify({"error": "No image file provided"}), 400

    # 데이터를 처리하고 저장하는 로직 작성 (예: DB에 저장)
    response = {
        'status': 'success',
        'result_message': result['result_message'],
        'result_code': result['result_code'],
        'result_similarity' : [[float(x) for x in inner_list] for inner_list in result['result_list']]
    }
    return jsonify(response), 200

