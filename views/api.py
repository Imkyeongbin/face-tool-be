from flask import Blueprint, g, request, jsonify

import os
import sys

# 스크립트 파일의 절대 경로를 구합니다.
script_file_path = os.path.abspath(__file__)

project_root = os.path.join(os.path.dirname(script_file_path), '..')
sys.path.insert(0, project_root)

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
    }
    if 'result_list' in result and isinstance(result['result_list'], list) and len(result['result_list']) > 0:
        response['result_list'] = [[float(x + 0.192444 * (x / 0.807555)) for x in inner_list] for inner_list in result['result_list']]
    return jsonify(response), 200

@bp.route('/identify-gender', methods=['POST'])
def distinguish_gender():
    target_img = request.files.get('target')  # 이미지 파일 가져오기
    result = None
    if target_img:
        target_img_array = process_image(target_img)
        project = g.face_ds_project
        
        result = project.distinguish(target_img_array)
        print(result)
        
    else:
        return jsonify({"error": "No image file provided"}), 400

    # 데이터를 처리하고 저장하는 로직 작성 (예: DB에 저장)
    response = {
        'status': 'success',
        'result_message': result['result_message'],
        'result_code': result['result_code'],
    }
    
    if 'result_list' in result and isinstance(result['result_list'], list) and len(result['result_list']) > 0:
        response['result_list'] = [
            {
                'gender': {k: float(v) for k, v in item['gender'].items()},
                'dominant_gender': item['dominant_gender']
            } for item in result['result_list']
        ]
    return jsonify(response), 200

