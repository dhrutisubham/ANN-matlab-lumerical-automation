import os
import sys
from dotenv import load_dotenv
from pathlib import Path
sys.path.append(r'C:\Program Files\Lumerical\v231\api\python')
import lumapi

# Get the directory of the script
script_location = os.path.dirname(os.path.abspath(__file__))

# Construct the relative path based on the script's location
env_path = Path(script_location) / 'env/matlab/.env'

# Load .env file from the constructed path
load_dotenv(dotenv_path=env_path)

WORKING_DIRECTORY = os.getenv('WORKING_DIRECTORY')
WORKING_DIRECTORY = WORKING_DIRECTORY.replace('\\', '/')

env_path = Path(f'{WORKING_DIRECTORY}/env/lumerical/.env')
load_dotenv(dotenv_path=env_path)

TIME_WINDOW = float(os.getenv('TIME_WINDOW'))
# print(type(TIME_WINDOW))

ict = lumapi.INTERCONNECT(f'{WORKING_DIRECTORY}/layer_1_iris.icp')
ict.switchtodesign()

inPath = f'{WORKING_DIRECTORY}/input_data.txt'
wUpperPath = f'{WORKING_DIRECTORY}/w_upper.txt'
wLowerPath = f'{WORKING_DIRECTORY}/w_low.txt'
outPath = f'{WORKING_DIRECTORY}/output_data.txt'


ict.set("time window", TIME_WINDOW)

ict.select("FROM_PWL_1")
ict.set("filename", inPath)

ict.select("FROM_PWL_2")
ict.set("filename", wUpperPath)

ict.select("FROM_PWL_3")
ict.set("filename", wLowerPath)

ict.select("TO_PWL_1")
ict.set("filename", outPath)

ict.run()
ict.close()
os._exit(0)
