from flask import Flask, render_template, request, jsonify
import datetime
import time
from threading import Thread
import logging

app = Flask(__name__)
alarms = {}
alarm_thread = None

def check_alarms():
    while True:
        current_time = datetime.datetime.now().strftime("%H:%M:%S")
        alarms_to_remove = []
        
        for alarm_time, alarm_data in alarms.items():
            if current_time == alarm_time and not alarm_data['triggered']:
                app.logger.info(f"Alarm triggered for {alarm_time}")
                alarms[alarm_time]['triggered'] = True
                alarms_to_remove.append(alarm_time)
        
        for alarm_time in alarms_to_remove:
            del alarms[alarm_time]
            
        time.sleep(1)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/set_alarm', methods=['POST'])
def set_alarm():
    data = request.get_json()
    hour = data.get('hour', '00')
    minute = data.get('minute', '00')
    second = data.get('second', '00')
    
    alarm_time = f"{hour}:{minute}:{second}"
    alarms[alarm_time] = {'triggered': False}
    
    app.logger.info(f"Alarm set for {alarm_time}")
    return jsonify({'message': f'Alarm set for {alarm_time}', 'status': 'success'})

@app.route('/get_alarms', methods=['GET'])
def get_alarms():
    active_alarms = [time for time, data in alarms.items() if not data['triggered']]
    return jsonify({'alarms': active_alarms})

@app.route('/current_time', methods=['GET'])
def get_current_time():
    return jsonify({'time': datetime.datetime.now().strftime("%H:%M:%S")})

if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    alarm_thread = Thread(target=check_alarms, daemon=True)
    alarm_thread.start()
    app.run(host='0.0.0.0', port=5000) 